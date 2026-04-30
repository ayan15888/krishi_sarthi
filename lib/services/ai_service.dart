import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  final String? apiKey = dotenv.env['NVIDIA_API_KEY'];
  final String? baseUrl = dotenv.env['NVIDIA_BASE_URL'];
  final String? model = dotenv.env['DEFAULT_CHAT_MODEL'];

  Future<String> getCropAdvice(String query, String language) async {
    if (apiKey == null || baseUrl == null) {
      return "AI Service is not configured. Please check your .env file.";
    }

    final systemPrompt = language == 'as' 
        ? "আপুনি এজন বিশেষজ্ঞ কৃষি পৰামৰ্শদাতা। অসমীয়া ভাষাত খেতিৰ বিষয়ে উত্তৰ দিয়ক।"
        : "You are an expert agricultural advisor. Provide farming advice in English.";

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          "model": model,
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": query}
          ],
          "temperature": 0.5,
          "top_p": 1,
          "max_tokens": 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "Error from AI Service: ${response.statusCode}";
      }
    } catch (e) {
      return "Failed to connect to AI Service: $e";
    }
  }
}
