class WeatherModel {
  final String city;
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final DateTime dateTime;

  const WeatherModel({
    required this.city,
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.dateTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['city'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      weatherCode: json['weatherCode'] as int,
      dateTime: DateTime.parse(json['dateTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temperature': temperature,
      'windSpeed': windSpeed,
      'weatherCode': weatherCode,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}