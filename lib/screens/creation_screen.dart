import 'package:flutter/material.dart';

class CreationScreen extends StatefulWidget {
  const CreationScreen({Key? key}) : super(key: key);

  @override
  State<CreationScreen> createState() => _CreationScreenState();
}

class _CreationScreenState extends State<CreationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleController = TextEditingController();
  final _lyricsController = TextEditingController();
  String _selectedGenre = '流行';
  String _selectedMood = '欢快';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _lyricsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创作间'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '新创建'),
            Tab(text: '草稿'),
            Tab(text: '已生成'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCreationForm(),
          _buildDraftsList(),
          _buildGeneratedList(),
        ],
      ),
    );
  }

  Widget _buildCreationForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 歌曲标题
          const Text('歌曲标题', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: '输入你的歌曲标题',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 24),

          // 歌词
          const Text('歌词', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _lyricsController,
            decoration: InputDecoration(
              hintText: '输入歌词或让AI帮你生成...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            maxLines: 6,
          ),
          const SizedBox(height: 24),

          // 风格选择
          const Text('音乐风格', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedGenre,
            items: ['流行', '摇滚', '民族', '电子', '古典'].map((genre) {
              return DropdownMenuItem(value: genre, child: Text(genre));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGenre = value ?? '流行';
              });
            },
          ),
          const SizedBox(height: 24),

          // 心情选择
          const Text('心情氛围', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedMood,
            items: ['欢快', '悲伤', '平静', '激烈', '浪漫'].map((mood) {
              return DropdownMenuItem(value: mood, child: Text(mood));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedMood = value ?? '欢快';
              });
            },
          ),
          const SizedBox(height: 32),

          // 生成按钮
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // TODO: 生成音乐
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('开始生成音乐...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
              ),
              child: const Text('🎵 生成音乐'),
            ),
          ),
          const SizedBox(height: 16),

          // AI辅助按钮
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                // TODO: AI生成歌词
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('AI正在生成歌词...')),
                );
              },
              child: const Text('✨ AI 生成歌词'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text('草稿 ${index + 1}'),
            subtitle: Text('创建于 ${DateTime.now().toString().split('.')[0]}'),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(child: Text('编辑')),
                const PopupMenuItem(child: Text('删除')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneratedList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.music_note),
            title: Text('生成的歌曲 ${index + 1}'),
            subtitle: const Text('已生成'),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
