import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AiApiService {
  static const String _deepseekUrl = 'https://api.deepseek.com/v1/chat/completions';
  static const String _replicateUrl = 'https://api.replicate.com/v1/predictions';

  static Future<String> _getKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static String _parseError(String body, String defaultMsg) {
    final lower = body.toLowerCase();
    if (lower.contains('insufficient') || lower.contains('balance') || lower.contains('credit') || lower.contains('quota')) {
      return '账户余额不足，请前往平台充值后重试';
    }
    if (lower.contains('invalid') && lower.contains('key')) {
      return 'API密钥无效，请检查设置中的密钥是否正确';
    }
    if (lower.contains('rate') && lower.contains('limit')) {
      return '请求过于频繁，请稍后再试';
    }
    try {
      final json = jsonDecode(body);
      if (json['error'] != null) {
        final msg = json['error']['message'] ?? json['error'].toString();
        return msg.toString();
      }
    } catch (_) {}
    return defaultMsg;
  }

  static Future<String> generateCopywriting({required String prompt, required String type}) async {
    final apiKey = await _getKey('deepseek_key');
    if (apiKey.isEmpty) throw Exception('请先在设置中配置DeepSeek API密钥');

    final typeNames = {'广告': '广告文案', '社媒': '社交媒体文案', '产品': '产品描述', '邮件': '营销邮件'};
    final sysPrompt = '你是专业的' + (typeNames[type] ?? '营销文案') + '写作专家。请创作高质量中文文案，要求吸引人、有创意、符合受众喜好。';

    try {
      final response = await http.post(
        Uri.parse(_deepseekUrl),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'},
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [{'role': 'system', 'content': sysPrompt}, {'role': 'user', 'content': prompt}],
          'temperature': 0.8,
          'max_tokens': 2000,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? '生成失败';
      } else {
        throw Exception(_parseError(response.body, '文案生成失败'));
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) rethrow;
      throw Exception('网络连接失败，请检查网络');
    }
  }

  static Future<String> generateImage({required String prompt, required String style}) async {
    final apiKey = await _getKey('replicate_key');
    if (apiKey.isEmpty) throw Exception('请先在设置中配置Replicate API密钥');

    final styleMap = {
      'realistic': 'photorealistic, 8k uhd',
      'anime': 'anime style, vibrant colors',
      'oil_painting': 'oil painting style',
      'watercolor': 'watercolor painting',
      'cartoon': 'cartoon style, colorful'
    };

    final fullPrompt = prompt + ', ' + (styleMap[style] ?? '') + ', masterpiece';

    try {
      final createResponse = await http.post(
        Uri.parse(_replicateUrl),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'},
        body: jsonEncode({
          'version': 'da77bc59ee60423279fd632efb4795ab731d9e3ca9705ef3341091fb989b7eaf',
          'input': {'prompt': fullPrompt, 'negative_prompt': 'low quality, blurry', 'width': 1024, 'height': 1024, 'num_outputs': 1}
        }),
      ).timeout(const Duration(seconds: 30));

      if (createResponse.statusCode != 201) throw Exception(_parseError(createResponse.body, '图像生成请求失败'));

      final createData = jsonDecode(createResponse.body);
      final predictionId = createData['id'];

      for (int i = 0; i < 60; i++) {
        await Future.delayed(const Duration(seconds: 3));
        final statusResponse = await http.get(Uri.parse(_replicateUrl + '/' + predictionId), headers: {'Authorization': 'Bearer $apiKey'});

        if (statusResponse.statusCode == 200) {
          final statusData = jsonDecode(statusResponse.body);
          if (statusData['status'] == 'succeeded') {
            final output = statusData['output'];
            if (output is List && output.isNotEmpty) return output[0];
          } else if (statusData['status'] == 'failed') {
            throw Exception(_parseError(statusData['error']?.toString() ?? '', '图像生成失败'));
          }
        }
      }
      throw Exception('图像生成超时');
    } catch (e) {
      if (e.toString().contains('Exception:')) rethrow;
      throw Exception('网络连接失败');
    }
  }

  static Future<String> generateMusic({required String prompt, required int duration}) async {
    final apiKey = await _getKey('replicate_key');
    if (apiKey.isEmpty) throw Exception('请先在设置中配置Replicate API密钥');

    try {
      final createResponse = await http.post(
        Uri.parse(_replicateUrl),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'},
        body: jsonEncode({
          'version': 'b05b1dff1d8c6dc63d14b0cdb42135378dcb87f6373b0d3d341ede46e59e2b38',
          'input': {'prompt': prompt, 'duration': duration, 'model_version': 'stereo-melody-large', 'output_format': 'mp3'}
        }),
      ).timeout(const Duration(seconds: 30));

      if (createResponse.statusCode != 201) throw Exception(_parseError(createResponse.body, '音乐生成请求失败'));

      final createData = jsonDecode(createResponse.body);
      final predictionId = createData['id'];

      for (int i = 0; i < 120; i++) {
        await Future.delayed(const Duration(seconds: 3));
        final statusResponse = await http.get(Uri.parse(_replicateUrl + '/' + predictionId), headers: {'Authorization': 'Bearer $apiKey'});

        if (statusResponse.statusCode == 200) {
          final statusData = jsonDecode(statusResponse.body);
          if (statusData['status'] == 'succeeded') {
            final output = statusData['output'];
            if (output is String) return output;
          } else if (statusData['status'] == 'failed') {
            throw Exception(_parseError(statusData['error']?.toString() ?? '', '音乐生成失败'));
          }
        }
      }
      throw Exception('音乐生成超时');
    } catch (e) {
      if (e.toString().contains('Exception:')) rethrow;
      throw Exception('网络连接失败');
    }
  }

  static Future<void> saveHistory(String type, String input, String output) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('ai_history') ?? '[]';
    final history = List<Map<String, dynamic>>.from(jsonDecode(historyJson));
    history.insert(0, {'type': type, 'input': input, 'output': output, 'time': DateTime.now().toIso8601String()});
    if (history.length > 20) history.removeLast();
    await prefs.setString('ai_history', jsonEncode(history));
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('ai_history') ?? '[]';
    return List<Map<String, dynamic>>.from(jsonDecode(historyJson));
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ai_history');
  }
}

