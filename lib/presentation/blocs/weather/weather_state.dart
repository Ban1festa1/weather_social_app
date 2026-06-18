import 'package:equatable/equatable.dart';

import '../../../data/models/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;

  const WeatherLoaded({
    required this.weather,
  });

  @override
  List<Object?> get props => [weather];
}

class WeatherFailure extends WeatherState {
  final String message;

  const WeatherFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}