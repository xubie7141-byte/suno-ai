import 'package:flutter/material.dart';

class AiToolsScreen extends StatefulWidget {
  const AiToolsScreen({Key? key}) : super(key: key);

  @override
  State<AiToolsScreen> createState() => _AiToolsScreenState();
}

class _AiToolsScreenState extends State<AiToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI工具集'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // AI数字人
            _buildToolCard(
              icon: '🎭',
              title: 'AI数字人',
              subtitle: '创建智能虚拟化身',
              color: Colors.blue,
              onTap: () => _showToolDetail(context, 'AI数字人', 'ai_avatar'),
            ),
            const SizedBox(height: 12),

            // AI文案
            _buildToolCard(
              icon: '✍️',
              title: 'AI文案',
              subtitle: '快速生成营销文案',
              color: Colors.green,
              onTap: () => _showToolDetail(context, 'AI文案', 'ai_copywriting'),
            ),
            const SizedBox(height: 12),

            // AI视频
            _buildToolCard(
              icon: '🎬',
              title: 'AI视频',
              subtitle: '生成高质量视频内容',
              color: Colors.purple,
              onTap: () => _showToolDetail(context, 'AI视频', 'ai_video'),
            ),
            const SizedBox(height: 12),

            // AI音乐
            _buildToolCard(
              icon: '🎵',
              title: 'AI音乐',
              subtitle: '生成高质量音乐',
              color: Colors.red,
              onTap: () => _showToolDetail(context, 'AI音乐', 'ai_music'),
            ),
            const SizedBox(height: 12),

            // AI绘画
            _buildToolCard(
              icon: '🎨',
              title: 'AI绘画',
              subtitle: '快速生成图片',
              color: Colors.orange,
              onTap: () => _showToolDetail(context, 'AI绘画', 'ai_image'),
            ),
            const SizedBox(height: 12),

            // AI PPT
            _buildToolCard(
              icon: '📊',
              title: 'AI PPT',
              subtitle: '快速生成演示文稿',
              color: Colors.teal,
              onTap: () => _showToolDetail(context, 'AI PPT', 'ai_ppt'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 图标
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 30)),
                ),
              ),
              const SizedBox(width: 16),

              // 文字
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // 箭头
              Icon(Icons.arrow_forward, color: color),
            ],
          ),
        ),
      ),
    );
  }

  void _showToolDetail(BuildContext context, String toolName, String toolType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiToolDetailScreen(
          toolName: toolName,
          toolType: toolType,
        ),
      ),
    );
  }
}

// AI工具详情屏幕
class AiToolDetailScreen extends StatefulWidget {
  final String toolName;
  final String toolType;

  const AiToolDetailScreen({
    Key? key,
    required this.toolName,
    required this.toolType,
  }) : super(key: key);

  @override
  State<AiToolDetailScreen> createState() => _AiToolDetailScreenState();
}

class _AiToolDetailScreenState extends State<AiToolDetailScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.toolName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 输入区域
            _buildInputArea(),
            const SizedBox(height: 24),

            // 生成按钮
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _generateContent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('生成${widget.toolName}'),
              ),
            ),
            const SizedBox(height: 24),

            // 结果区域
            if (isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text('正在生成${widget.toolName}，请稍候...'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    switch (widget.toolType) {
      case 'ai_avatar':
        return _buildAvatarInput();
      case 'ai_copywriting':
        return _buildCopywritingInput();
      case 'ai_video':
        return _buildVideoInput();
      case 'ai_music':
        return _buildMusicInput();
      case 'ai_image':
        return _buildImageInput();
      case 'ai_ppt':
        return _buildPptInput();
      default:
        return const SizedBox();
    }
  }

  Widget _buildAvatarInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('选择虚拟形象', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildAvatarOption('👩 女性', 'female'),
              _buildAvatarOption('👨 男性', 'male'),
              _buildAvatarOption('🧑 中性', 'neutral'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('配置语音', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton(
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: '女声', child: Text('女声')),
            DropdownMenuItem(value: '男声', child: Text('男声')),
            DropdownMenuItem(value: '中性', child: Text('中性')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildAvatarOption(String label, String type) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildCopywritingInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('文案类型', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton(
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: '广告', child: Text('广告文案')),
            DropdownMenuItem(value: '社媒', child: Text('社交媒体')),
            DropdownMenuItem(value: '产品', child: Text('产品描述')),
            DropdownMenuItem(value: '邮件', child: Text('邮件营销')),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        const Text('描述产品或主题', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '输入产品名称或需求...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildVideoInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('视频类型', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton(
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: '宣传', child: Text('产品宣传视频')),
            DropdownMenuItem(value: '教程', child: Text('教程视频')),
            DropdownMenuItem(value: '故事', child: Text('故事视频')),
            DropdownMenuItem(value: '音乐', child: Text('音乐视频')),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        const Text('视频脚本或描述', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '输入视频脚本...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildMusicInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('音乐风格', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton(
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: '流行', child: Text('流行')),
            DropdownMenuItem(value: '摇滚', child: Text('摇滚')),
            DropdownMenuItem(value: '爵士', child: Text('爵士')),
            DropdownMenuItem(value: '古典', child: Text('古典')),
            DropdownMenuItem(value: '电子', child: Text('电子')),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        const Text('心情', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton(
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: '欢快', child: Text('欢快')),
            DropdownMenuItem(value: '悲伤', child: Text('悲伤')),
            DropdownMenuItem(value: '平静', child: Text('平静')),
            DropdownMenuItem(value: '激烈', child: Text('激烈')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildImageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('图片描述', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '描述你想要的图片...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        const Text('风格', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton(
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: '写实', child: Text('写实')),
            DropdownMenuItem(value: '卡通', child: Text('卡通')),
            DropdownMenuItem(value: '油画', child: Text('油画')),
            DropdownMenuItem(value: '水彩', child: Text('水彩')),
            DropdownMenuItem(value: '素描', child: Text('素描')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildPptInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('演示主题', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '输入演示主题...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 16),
        const Text('幻灯片数量', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton(
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: '5', child: Text('5张')),
            DropdownMenuItem(value: '10', child: Text('10张')),
            DropdownMenuItem(value: '15', child: Text('15张')),
            DropdownMenuItem(value: '20', child: Text('20张')),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        const Text('内容大纲', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: '输入主要内容和要点...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  void _generateContent() {
    setState(() {
      isLoading = true;
    });

    // 模拟生成过程
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.toolName}生成成功！'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}
