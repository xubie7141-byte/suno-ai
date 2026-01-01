import 'package:flutter/material.dart';
import '../services/ai_api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _deepseekCtrl = TextEditingController();
  final _replicateCtrl = TextEditingController();
  bool _loading = true;
  bool _hideDeepseek = true;
  bool _hideReplicate = true;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    final dk = await AiApiService.getDeepseekKey();
    final rk = await AiApiService.getReplicateKey();
    setState(() {
      _deepseekCtrl.text = dk ?? '';
      _replicateCtrl.text = rk ?? '';
      _loading = false;
    });
  }

  Future<void> _saveKeys() async {
    setState(() => _loading = true);
    try {
      await AiApiService.saveDeepseekKey(_deepseekCtrl.text.trim());
      await AiApiService.saveReplicateKey(_replicateCtrl.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('API密钥已保存'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: '), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('API设置', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF16213E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 20),
                  _buildKeyField('DeepSeek API Key', '用于AI文案', _deepseekCtrl, _hideDeepseek, () => setState(() => _hideDeepseek = !_hideDeepseek), Colors.blue),
                  const SizedBox(height: 16),
                  _buildKeyField('Replicate API Token', '用于AI绘画/音乐', _replicateCtrl, _hideReplicate, () => setState(() => _hideReplicate = !_hideReplicate), Colors.purple),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveKeys,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('保存设置', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade900, Colors.purple.shade900]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(Icons.info_outline, color: Colors.white), SizedBox(width: 8), Text('配置说明', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))]),
          SizedBox(height: 8),
          Text('DeepSeek: 用于AI文案\nReplicate: 用于AI绘画、音乐\n\n密钥仅保存在本地设备', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildKeyField(String title, String subtitle, TextEditingController ctrl, bool hide, VoidCallback toggle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.key, color: color),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            ]),
          ]),
          const SizedBox(height: 12),
          TextField(
            controller: ctrl,
            obscureText: hide,
            style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
            decoration: InputDecoration(
              hintText: '粘贴API密钥...',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              suffixIcon: IconButton(icon: Icon(hide ? Icons.visibility : Icons.visibility_off, color: Colors.grey), onPressed: toggle),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _deepseekCtrl.dispose();
    _replicateCtrl.dispose();
    super.dispose();
  }
}
