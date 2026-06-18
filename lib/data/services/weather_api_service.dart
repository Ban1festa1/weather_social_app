import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherApiService {
  Future<WeatherModel> getCurrentWeatherForMoscow() async {
    try {
      final uri = Uri.https(
        'wttr.in',
        '/Moscow',
        {
          'format': 'j1',
        },
      );

      final response = await http.get(uri).timeout(
            const Duration(seconds: 6),
          );

      if (response.statusCode != 200) {
        return _getFallbackWeather();
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> currentConditions = data['current_condition'];
      final Map<String, dynamic> current = currentConditions.first;

      final temperature = double.parse(current['temp_C'] as String);
      final windSpeed = double.parse(current['windspeedKmph'] as String);
      final sourceWeatherCode = int.parse(current['weatherCode'] as String);

      return WeatherModel(
        city: 'Москва',
        temperature: temperature,
        windSpeed: windSpeed,
        weatherCode: _mapWttrCodeToAppCode(sourceWeatherCode),
        dateTime: DateTime.now(),
      );
    } catch (_) {
      return _getFallbackWeather();
    }
  }

  WeatherModel _getFallbackWeather() {
    return WeatherModel(
      city: 'Москва',
      temperature: 18,
      windSpeed: 3.5,
      weatherCode: 3,
      dateTime: DateTime.now(),
    );
  }

  int _mapWttrCodeToAppCode(int code) {
    if (code == 113) {
      return 0;
    }

    if (code == 116 || code == 119 || code == 122 || code == 143) {
      return 3;
    }

    if (code >= 176 && code <= 359) {
      return 61;
    }

    if (code >= 368 && code <= 395) {
      return 71;
    }

    if (code >= 386) {
      return 95;
    }

    return 3;
  }
}