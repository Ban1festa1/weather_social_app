import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/weather_repository.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({
    required this.weatherRepository,
  }) : super(const WeatherInitial()) {
    on<LoadWeather>(_onLoadWeather);
    on<RefreshWeather>(_onRefreshWeather);
  }

  Future<void> _onLoadWeather(
    LoadWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    try {
      final weather = await weatherRepository.getCurrentWeather();
      emit(WeatherLoaded(weather: weather));
    } catch (error) {
      emit(
        WeatherFailure(
          message: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshWeather(
    RefreshWeather event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      final weather = await weatherRepository.getCurrentWeather();
      emit(WeatherLoaded(weather: weather));
    } catch (error) {
      emit(
        WeatherFailure(
          message: error.toString(),
        ),
      );
    }
  }
}