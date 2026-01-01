import 'package:dio/dio.dart';
import 'app_service.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  static ApiClient get instance => _instance;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  late Dio _dio;

  void initialize() {
    final baseUrl = AppService.instance.apiBaseUrl;
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 可以在这里添加认证token
          final userId = AppService.instance.currentUserId;
          if (userId != null) {
            options.headers['Authorization'] = 'Bearer $userId';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          print('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // 音乐相关API
  Future<dynamic> getMusicList({
    int page = 1,
    int pageSize = 20,
    String? genre,
    String? mood,
  }) async {
    try {
      final response = await _dio.get(
        '/api/music',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          if (genre != null) 'genre': genre,
          if (mood != null) 'mood': mood,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 生成音乐
  Future<dynamic> generateMusic({
    required String title,
    required String lyrics,
    required String genre,
    required String mood,
    String? instrumentChoice,
    String? singerStyle,
    int? tempo,
  }) async {
    try {
      final response = await _dio.post(
        '/api/music/generate',
        data: {
          'title': title,
          'lyrics': lyrics,
          'genre': genre,
          'mood': mood,
          'instrument_choice': instrumentChoice,
          'singer_style': singerStyle,
          'tempo': tempo,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 获取生成状态
  Future<dynamic> getGenerationStatus(String generationId) async {
    try {
      final response = await _dio.get('/api/music/generation/$generationId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 收藏音乐
  Future<dynamic> favoriteMusic(String musicId) async {
    try {
      final response = await _dio.post('/api/favorites', data: {'music_id': musicId});
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 取消收藏
  Future<dynamic> unfavoriteMusic(String musicId) async {
    try {
      final response = await _dio.delete('/api/favorites/$musicId');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // 获取收藏列表
  Future<dynamic> getFavorites({int page = 1, int pageSize = 20}) async {
    try {
      final response = await _dio.get(
        '/api/favorites',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // ============ AI工具 API ============

  // AI数字人 - 创建虚拟形象
  Future<dynamic> createAvatar({
    required String avatarType,
    required String voiceStyle,
    String? name,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ai-tools/avatar/create',
        data: {
          'avatar_type': avatarType,
          'voice_style': voiceStyle,
          'name': name,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // AI数字人 - 生成视频
  Future<dynamic> generateAvatarVideo({
    required String avatarId,
    required String script,
    String? audioUrl,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ai-tools/avatar/generate-video',
        data: {
          'avatar_id': avatarId,
          'script': script,
          'audio_url': audioUrl,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // AI文案 - 生成营销文案
  Future<dynamic> generateCopywriting({
    required String copywritingType,
    required String productName,
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ai-tools/copywriting/generate',
        data: {
          'copywriting_type': copywritingType,
          'product_name': productName,
          'description': description,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // AI视频 - 生成视频
  Future<dynamic> generateVideo({
    required String videoType,
    required String script,
    int duration = 30,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ai-tools/video/generate',
        data: {
          'video_type': videoType,
          'script': script,
          'duration': duration,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // AI绘画 - 生成图片
  Future<dynamic> generateImage({
    required String prompt,
    String style = 'realistic',
  }) async {
    try {
      final response = await _dio.post(
        '/api/ai-tools/image/generate',
        data: {
          'prompt': prompt,
          'style': style,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // AI PPT - 生成演示文稿
  Future<dynamic> generatePpt({
    required String topic,
    required int slideCount,
    required String outline,
  }) async {
    try {
      final response = await _dio.post(
        '/api/ai-tools/ppt/generate',
        data: {
          'topic': topic,
          'slide_count': slideCount,
          'outline': outline,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // AI工具 - 获取状态
  Future<dynamic> getAiToolsStatus() async {
    try {
      final response = await _dio.get('/api/ai-tools/status');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
