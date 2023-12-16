import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final String city;
  final String temperature;
  final String rain;

  WeatherData(
      {required this.city, required this.temperature, required this.rain});
}

class WeatherService {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  WeatherService(this.apiKey);
  Future<WeatherData> getWeather() async {
    final response = await http.get(Uri.parse(
        '$baseUrl?lat=-27.216291&lon=-49.642963&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String cityName = data['name'];
      final String temperature = data['main']['temp'].toString();
      final String rain = data['rain'].toString();
      return WeatherData(city: cityName, temperature: temperature, rain: rain);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
