import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'd8c48eb00c654d774c6d1cfac5e98de2'; // User should replace this
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    // For demonstration, if apiKey is 'YOUR_API_KEY', return mock data
    if (apiKey == 'YOUR_API_KEY') {
      return {
        'main': {'temp': 301.15, 'humidity': 70},
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
