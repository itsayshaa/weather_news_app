import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../utils/constants.dart';

class WeatherProvider extends ChangeNotifier {

  final WeatherService _service =
  WeatherService();

  WeatherModel? _weather;

  WeatherModel? get weather =>
      _weather;

  bool _isLoading = false;

  bool get isLoading =>
      _isLoading;

  String _error = "";

  String get error => _error;

  String _currentCity =
      AppConstants.defaultCity;

  String get currentCity =>
      _currentCity;

  Future<void> getWeather(
      String city,
      ) async {

    try {

      _isLoading = true;

      _error = "";

      notifyListeners();

      _currentCity = city;

      await saveCity(city);

      final result =
      await _service
          .fetchWeather(city);

      _weather = result;

    } catch (e) {

      _error = e.toString();

    } finally {

      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> refreshWeather()
  async {

    await getWeather(
      _currentCity,
    );
  }

  Future<void> saveCity(
      String city,
      ) async {

    final prefs =
    await SharedPreferences
        .getInstance();

    await prefs.setString(
      "city",
      city,
    );
  }

  Future<void> loadSavedCity()
  async {

    final prefs =
    await SharedPreferences
        .getInstance();

    final savedCity =
    prefs.getString("city");

    if (savedCity != null) {

      await getWeather(
        savedCity,
      );

    } else {

      await getWeather(
        AppConstants.defaultCity,
      );
    }
  }
}