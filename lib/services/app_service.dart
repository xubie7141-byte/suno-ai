import 'package:shared_preferences/shared_preferences.dart';

class AppService {
  static final AppService _instance = AppService._internal();

  static AppService get instance => _instance;

  factory AppService() {
    return _instance;
  }

  AppService._internal();

  late SharedPreferences _prefs;
  String? _currentUserId;
  String? _apiBaseUrl;

  static Future<void> initialize() async {
    final instance = AppService.instance;
    instance._prefs = await SharedPreferences.getInstance();
    // 从本地存储获取配置
    instance._currentUserId = instance._prefs.getString('current_user_id');
    instance._apiBaseUrl = instance._prefs.getString('api_base_url') ?? 'http://localhost:8000';
  }

  String? get currentUserId => _currentUserId;
  String get apiBaseUrl => _apiBaseUrl ?? 'http://localhost:8000';

  Future<void> setCurrentUser(String userId) async {
    _currentUserId = userId;
    await _prefs.setString('current_user_id', userId);
  }

  Future<void> setApiBaseUrl(String url) async {
    _apiBaseUrl = url;
    await _prefs.setString('api_base_url', url);
  }

  void logout() {
    _currentUserId = null;
    _prefs.remove('current_user_id');
  }
}
