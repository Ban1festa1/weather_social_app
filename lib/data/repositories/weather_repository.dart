import '../models/weather_model.dart';
import '../services/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService weatherApiService;

  WeatherRepository({
    required this.weatherApiService,
  });

  Future<WeatherModel> getCurrentWeather() {
    return weatherApiService.getCurrentWeatherForMoscow();
  }
}