import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AiApiService {
  static const String _deepseekKeyPref = 'deepseek_api_key';
  static const String _replicateKeyPref = 'replicate_api_key';

  static Future<String?> getDeepseekKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deepseekKeyPref);
  }

  static Future<String?> getReplicateKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_replicateKeyPref);
  }

  static Future<void> saveDeepseekKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deepseekKeyPref, key);
  }

  static Future<void> saveReplicateKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_replicateKeyPref, key);
  }

  // AI文案 (DeepSeek)
  static Future<String> generateCopywriting({
    required String prompt,
    required String type,
  }) async {
    final apiKey = await getDeepseekKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('请先在设置中配置DeepSeek API密钥');
    }

    final systemPrompt = _getCopywritingSystemPrompt(type);
    
    final response = await http.post(
      Uri.parse('https://api.deepseek.com/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'deepseek-chat',
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.7,
        'max_tokens': 2000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('生成失败: ${response.body}');
    }
  }

  static String _getCopywritingSystemPrompt(String type) {
    switch (type) {
      case '广告': return '你是一位专业的广告文案撰写人，擅长撰写吸引人的广告文案。请根据用户提供的产品或服务信息，撰写一段精彩的广告文案。';
      case '社媒': return '你是一位社交媒体运营专家，擅长撰写有吸引力的社交媒体帖子。请根据用户的需求，撰写适合社交平台传播的内容。';
      case '产品': return '你是一位产品文案专家，擅长撰写产品描述和卖点介绍。请根据用户提供的产品信息，撰写详细的产品描述。';
      case '邮件': return '你是一位邮件营销专家，擅长撰写营销邮件。请根据用户的需求，撰写一封专业的营销邮件。';
      default: return '你是一位专业的文案撰写人，请根据用户的需求撰写高质量的文案。';
    }
  }

  // AI绘画 (Replicate - SDXL)
  static Future<String> generateImage({
    required String prompt,
    String style = 'realistic',
  }) async {
    final apiKey = await getReplicateKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('请先在设置中配置Replicate API密钥');
    }

    final enhancedPrompt = _enhanceImagePrompt(prompt, style);

    final createResponse = await http.post(
      Uri.parse('https://api.replicate.com/v1/predictions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $apiKey',
      },
      body: jsonEncode({
        'version': '39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b',
        'input': {
          'prompt': enhancedPrompt,
          'negative_prompt': 'ugly, blurry, low quality, distorted',
          'width': 1024,
          'height': 1024,
          'num_inference_steps': 30,
        },
      }),
    );

    if (createResponse.statusCode != 201) {
      throw Exception('创建任务失败: ${createResponse.body}');
    }

    final createData = jsonDecode(createResponse.body);
    final predictionId = createData['id'];

    for (int i = 0; i < 60; i++) {
      await Future.delayed(const Duration(seconds: 2));
      final statusResponse = await http.get(
        Uri.parse('https://api.replicate.com/v1/predictions/$predictionId'),
        headers: {'Authorization': 'Token $apiKey'},
      );
      final statusData = jsonDecode(statusResponse.body);
      final status = statusData['status'];
      if (status == 'succeeded') {
        final output = statusData['output'];
        if (output is List && output.isNotEmpty) return output[0];
        throw Exception('生成结果为空');
      } else if (status == 'failed') {
        throw Exception('生成失败: ${statusData['error']}');
      }
    }
    throw Exception('生成超时，请重试');
  }

  static String _enhanceImagePrompt(String prompt, String style) {
    final stylePrefix = {
      'realistic': 'photorealistic, highly detailed, professional photography,',
      'anime': 'anime style, vibrant colors, detailed illustration,',
      'oil_painting': 'oil painting style, classical art, detailed brushwork,',
      'watercolor': 'watercolor painting, soft colors, artistic,',
      'cartoon': 'cartoon style, colorful, fun,',
    };
    return '${stylePrefix[style] ?? ''} $prompt';
  }

  // AI音乐 (Replicate - MusicGen)
  static Future<String> generateMusic({
    required String prompt,
    int duration = 10,
  }) async {
    final apiKey = await getReplicateKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('请先在设置中配置Replicate API密钥');
    }

    final createResponse = await http.post(
      Uri.parse('https://api.replicate.com/v1/predictions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $apiKey',
      },
      body: jsonEncode({
        'version': '671ac645ce5e552cc63a54a2bbff63fcf798043055d2dac5fc9e36a837eedcfb',
        'input': {
          'prompt': prompt,
          'duration': duration,
          'model_version': 'stereo-large',
          'output_format': 'mp3',
        },
      }),
    );

    if (createResponse.statusCode != 201) {
      throw Exception('创建任务失败: ${createResponse.body}');
    }

    final createData = jsonDecode(createResponse.body);
    final predictionId = createData['id'];

    for (int i = 0; i < 120; i++) {
      await Future.delayed(const Duration(seconds: 3));
      final statusResponse = await http.get(
        Uri.parse('https://api.replicate.com/v1/predictions/$predictionId'),
        headers: {'Authorization': 'Token $apiKey'},
      );
      final statusData = jsonDecode(statusResponse.body);
      final status = statusData['status'];
      if (status == 'succeeded') {
        final output = statusData['output'];
        if (output != null) return output.toString();
        throw Exception('生成结果为空');
      } else if (status == 'failed') {
        throw Exception('生成失败: ${statusData['error']}');
      }
    }
    throw Exception('生成超时，请重试');
  }
}
