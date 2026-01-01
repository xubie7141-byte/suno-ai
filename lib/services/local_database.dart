import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();

  static LocalDatabase get instance => _instance;

  factory LocalDatabase() {
    return _instance;
  }

  LocalDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'suno_ai.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 创建用户表
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        avatar_url TEXT,
        bio TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // 创建音乐表
    await db.execute('''
      CREATE TABLE musics (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        description TEXT,
        lyrics TEXT,
        cover_image_url TEXT,
        music_url TEXT,
        video_url TEXT,
        genre TEXT NOT NULL,
        mood TEXT NOT NULL,
        duration INTEGER NOT NULL,
        likes INTEGER DEFAULT 0,
        downloads INTEGER DEFAULT 0,
        is_favorite INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER,
        user_id TEXT,
        is_local_generation INTEGER DEFAULT 0
      )
    ''');

    // 创建音乐创作草稿表
    await db.execute('''
      CREATE TABLE music_creations (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        lyrics TEXT,
        genre TEXT NOT NULL,
        mood TEXT NOT NULL,
        instrument_choice TEXT,
        singer_style TEXT,
        tempo INTEGER,
        status TEXT NOT NULL,
        error_message TEXT,
        generated_music_url TEXT,
        generated_video_url TEXT,
        cover_image_url TEXT,
        created_at INTEGER NOT NULL,
        completed_at INTEGER,
        parameters TEXT
      )
    ''');

    // 创建收藏夹表
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        music_id TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY(music_id) REFERENCES musics(id)
      )
    ''');

    // 创建播放历史表
    await db.execute('''
      CREATE TABLE play_history (
        id TEXT PRIMARY KEY,
        music_id TEXT NOT NULL,
        played_at INTEGER NOT NULL,
        FOREIGN KEY(music_id) REFERENCES musics(id)
      )
    ''');
  }

  // 关闭数据库
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }

  // 通用查询方法
  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  // 通用插入方法
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
  }

  // 通用更新方法
  Future<int> update(String table, Map<String, dynamic> values, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  // 通用删除方法
  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
