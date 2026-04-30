import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String? apiKey = dotenv.env['OPENWEATHER_API_KEY'];
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    if (apiKey == null || apiKey!.isEmpty) {
      // Mock data if no API key is provided
      return {
        'main': {'temp': 28.5, 'humidity': 70},
        'weather': [{'description': 'clear sky', 'main': 'Clear', 'icon': '01d'}],
        'wind': {'speed': 3.5},
        'name': 'Guwahati'
      };
    }

    final url = Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
