import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIApi {
  static const _apiKey = String.fromEnvironment('OPENAI_PROXY_API_KEY');
  static const _endpoint = String.fromEnvironment('OPENAI_PROXY_ENDPOINT');

  static Future<String> sendMessage({
    required String prompt,
    required bool isFarmer,
  }) async {
    if (_apiKey.isEmpty || _endpoint.isEmpty) {
      return "AI Assistant is currently unavailable.";
    }

    final systemPrompt = isFarmer
        ? "You are a helpful AI assistant for farmers. You provide insights on crop prices, farming techniques, and assist with selling products to the government-backed marketplace. Keep responses concise and supportive."
        : "You are a helpful AI assistant for customers buying fresh produce. You can answer questions about product quality, availability, recipes, and assist with ordering. Keep responses concise and friendly.";

    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['choices'][0]['message']['content'];
      } else {
        return "Sorry, I couldn't process your request right now.";
      }
    } catch (e) {
      return "An error occurred while connecting to the AI assistant.";
    }
  }
}
