import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class LoadWeather extends WeatherEvent {
  const LoadWeather();
}

class RefreshWeather extends WeatherEvent {
  const RefreshWeather();
}