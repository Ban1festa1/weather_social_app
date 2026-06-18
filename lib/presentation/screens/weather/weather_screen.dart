import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/weather_model.dart';
import '../../../data/repositories/weather_repository.dart';
import '../../../data/services/weather_api_service.dart';
import '../../blocs/weather/weather_bloc.dart';
import '../../blocs/weather/weather_event.dart';
import '../../blocs/weather/weather_state.dart';
import '../create_post/create_post_screen.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  Future<void> _openCreatePostScreen(
    BuildContext context,
    WeatherModel weather,
  ) async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(weather: weather),
      ),
    );

    if (!context.mounted) return;

    if (created == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пост сохранён локально'),
        ),
      );
    }
  }

  IconData _getWeatherIcon(int weatherCode) {
    if (weatherCode == 0) {
      return Icons.wb_sunny;
    }

    if (weatherCode >= 1 && weatherCode <= 3) {
      return Icons.cloud;
    }

    if (weatherCode >= 45 && weatherCode <= 48) {
      return Icons.foggy;
    }

    if (weatherCode >= 51 && weatherCode <= 67) {
      return Icons.grain;
    }

    if (weatherCode >= 71 && weatherCode <= 77) {
      return Icons.ac_unit;
    }

    if (weatherCode >= 80 && weatherCode <= 82) {
      return Icons.water_drop;
    }

    if (weatherCode >= 95) {
      return Icons.thunderstorm;
    }

    return Icons.cloud;
  }

  String _getWeatherDescription(int weatherCode) {
    if (weatherCode == 0) {
      return 'Ясно';
    }

    if (weatherCode >= 1 && weatherCode <= 3) {
      return 'Облачно';
    }

    if (weatherCode >= 45 && weatherCode <= 48) {
      return 'Туман';
    }

    if (weatherCode >= 51 && weatherCode <= 67) {
      return 'Морось или дождь';
    }

    if (weatherCode >= 71 && weatherCode <= 77) {
      return 'Снег';
    }

    if (weatherCode >= 80 && weatherCode <= 82) {
      return 'Ливень';
    }

    if (weatherCode >= 95) {
      return 'Гроза';
    }

    return 'Погодные условия';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherBloc(
        weatherRepository: WeatherRepository(
          weatherApiService: WeatherApiService(),
        ),
      )..add(const LoadWeather()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Погода'),
        ),
        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading || state is WeatherInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is WeatherFailure) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Не удалось загрузить погоду',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () {
                              context
                                  .read<WeatherBloc>()
                                  .add(const RefreshWeather());
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Повторить'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            if (state is WeatherLoaded) {
              final weather = state.weather;
              final temperature = weather.temperature.toStringAsFixed(0);
              final windSpeed = weather.windSpeed.toStringAsFixed(1);
              final description = _getWeatherDescription(weather.weatherCode);

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<WeatherBloc>().add(const RefreshWeather());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              _getWeatherIcon(weather.weatherCode),
                              size: 72,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              weather.city,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '$temperature°C',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(description),
                            const SizedBox(height: 8),
                            Text('Ветер: $windSpeed км/ч'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _openCreatePostScreen(context, weather),
                      icon: const Icon(Icons.add),
                      label: const Text('Создать пост с погодой'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<WeatherBloc>().add(
                              const RefreshWeather(),
                            );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Обновить погоду'),
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('Неизвестное состояние погоды'),
            );
          },
        ),
      ),
    );
  }
}