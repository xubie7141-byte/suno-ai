import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/ai_api_service.dart';
import 'settings_screen.dart';

class AiToolsScreen extends StatelessWidget {
  const AiToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('AI创作工具', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            tooltip: 'API设置',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
          children: [
            _buildToolCard(context, title: 'AI文案', subtitle: '智能生成营销文案', icon: Icons.edit_note, gradient: [Colors.blue.shade700, Colors.blue.shade900], toolType: 'copywriting'),
            _buildToolCard(context, title: 'AI绘画', subtitle: 'AI艺术图像生成', icon: Icons.palette, gradient: [Colors.purple.shade700, Colors.purple.shade900], toolType: 'image'),
            _buildToolCard(context, title: 'AI音乐', subtitle: 'AI作曲生成音乐', icon: Icons.music_note, gradient: [Colors.orange.shade700, Colors.orange.shade900], toolType: 'music'),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required List<Color> gradient, required String toolType}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AiToolDetailScreen(toolType: toolType))),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: gradient[0].withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: Icon(icon, size: 40, color: Colors.white)),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class AiToolDetailScreen extends StatefulWidget {
  final String toolType;
  const AiToolDetailScreen({super.key, required this.toolType});
  @override
  State<AiToolDetailScreen> createState() => _AiToolDetailScreenState();
}

class _AiToolDetailScreenState extends State<AiToolDetailScreen> {
  final _inputCtrl = TextEditingController();
  bool _loading = false;
  String? _result;
  String? _error;
  String _copyType = '广告';
  String _imageStyle = 'realistic';
  int _musicDuration = 10;

  String get _title => {'copywriting': 'AI文案', 'image': 'AI绘画', 'music': 'AI音乐'}[widget.toolType] ?? 'AI工具';
  String get _hint => {'copywriting': '描述您的产品或服务...', 'image': '描述您想生成的图像...', 'music': '描述您想要的音乐风格...'}[widget.toolType] ?? '输入需求...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text(_title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF16213E),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOptions(),
            const SizedBox(height: 20),
            const Text('输入描述', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _inputCtrl,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: _hint,
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _loading ? null : _generate,
                style: ElevatedButton.styleFrom(backgroundColor: _loading ? Colors.grey : Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _loading
                    ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)), SizedBox(width: 12), Text('生成中...', style: TextStyle(color: Colors.white))])
                    : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.auto_awesome, color: Colors.white), SizedBox(width: 8), Text('开始生成', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))]),
              ),
            ),
            const SizedBox(height: 24),
            if (_error != null) Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red)), child: Row(children: [const Icon(Icons.error, color: Colors.red), const SizedBox(width: 12), Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red)))])),
            if (_result != null) _buildResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions() {
    if (widget.toolType == 'copywriting') {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('文案类型', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(spacing: 10, children: ['广告', '社媒', '产品', '邮件'].map((t) => ChoiceChip(label: Text(t), selected: t == _copyType, onSelected: (_) => setState(() => _copyType = t), selectedColor: Colors.blue, labelStyle: TextStyle(color: t == _copyType ? Colors.white : Colors.grey), backgroundColor: Colors.white.withOpacity(0.1))).toList()),
      ]);
    } else if (widget.toolType == 'image') {
      final styles = {'realistic': '写实', 'anime': '动漫', 'oil_painting': '油画', 'watercolor': '水彩', 'cartoon': '卡通'};
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('图像风格', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(spacing: 10, runSpacing: 10, children: styles.entries.map((e) => ChoiceChip(label: Text(e.value), selected: e.key == _imageStyle, onSelected: (_) => setState(() => _imageStyle = e.key), selectedColor: Colors.purple, labelStyle: TextStyle(color: e.key == _imageStyle ? Colors.white : Colors.grey), backgroundColor: Colors.white.withOpacity(0.1))).toList()),
      ]);
    } else if (widget.toolType == 'music') {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('音乐时长', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Slider(value: _musicDuration.toDouble(), min: 5, max: 30, divisions: 5, label: '\秒', activeColor: Colors.orange, onChanged: (v) => setState(() => _musicDuration = v.round()))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: Text('\秒', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
        ]),
      ]);
    }
    return const SizedBox();
  }

  Widget _buildResult() {
    if (widget.toolType == 'copywriting') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.blue.withOpacity(0.5))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 8), Text('生成结果', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 12),
          SelectableText(_result!, style: const TextStyle(color: Colors.white, height: 1.6)),
        ]),
      );
    } else if (widget.toolType == 'image') {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 8), Text('生成的图像', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(_result!, fit: BoxFit.cover, loadingBuilder: (c, child, p) => p == null ? child : Container(height: 300, alignment: Alignment.center, child: const CircularProgressIndicator()))),
      ]);
    } else if (widget.toolType == 'music') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.withOpacity(0.5))),
        child: Column(children: [
          const Row(children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 8), Text('音乐生成完成', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange.shade900, Colors.orange.shade700]), borderRadius: BorderRadius.circular(12)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.music_note, color: Colors.white, size: 32), SizedBox(width: 12), Text('您的AI音乐', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))])),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () async { final uri = Uri.parse(_result!); if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication); }, icon: const Icon(Icons.download, color: Colors.white), label: const Text('下载音乐', style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, padding: const EdgeInsets.symmetric(vertical: 14)))),
        ]),
      );
    }
    return Text(_result!, style: const TextStyle(color: Colors.white));
  }

  Future<void> _generate() async {
    final input = _inputCtrl.text.trim();
    if (input.isEmpty) { setState(() => _error = '请输入内容'); return; }
    setState(() { _loading = true; _error = null; _result = null; });
    try {
      String result;
      if (widget.toolType == 'copywriting') {
        result = await AiApiService.generateCopywriting(prompt: input, type: _copyType);
      } else if (widget.toolType == 'image') {
        result = await AiApiService.generateImage(prompt: input, style: _imageStyle);
      } else if (widget.toolType == 'music') {
        result = await AiApiService.generateMusic(prompt: input, duration: _musicDuration);
      } else {
        throw Exception('未知工具类型');
      }
      setState(() => _result = result);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() { _inputCtrl.dispose(); super.dispose(); }
}
