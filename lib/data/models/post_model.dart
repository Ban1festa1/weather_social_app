import 'weather_model.dart';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String city;
  final String comment;
  final WeatherModel weather;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.city,
    required this.comment,
    required this.weather,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      city: json['city'] as String,
      comment: json['comment'] as String,
      weather: WeatherModel.fromJson(
        json['weather'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'city': city,
      'comment': comment,
      'weather': weather.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}