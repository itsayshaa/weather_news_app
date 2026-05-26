import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {


  Future<Map<String, dynamic>?> _geoFromOpenMeteo(String city) async {
    try {
      final url = Uri.parse(
        "https://geocoding-api.open-meteo.com/v1/search"
            "?name=${Uri.encodeComponent(city)}"
            "&count=5&language=en&format=json",
      );

      final res = await http.get(url).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body);
      final results = (data["results"] as List?) ?? [];
      if (results.isEmpty) return null;

      for (final r in results) {
        if ((r["name"] ?? "").toString().toLowerCase() == city.toLowerCase()) {
          return r as Map<String, dynamic>;
        }
      }
      return results[0] as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }


  Future<Map<String, dynamic>?> _geoFromNominatim(String city) async {
    try {
      final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search"
            "?q=${Uri.encodeComponent(city)}"
            "&format=json&limit=1&addressdetails=1",
      );

      final res = await http.get(
        url,
        headers: {"User-Agent": "WeatherNewsApp/1.0"},
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode != 200) return null;

      final List data = jsonDecode(res.body);
      if (data.isEmpty) return null;

      final item = data[0];
      final addr = item["address"] as Map<String, dynamic>? ?? {};

      return {
        "latitude":  double.tryParse(item["lat"].toString()) ?? 0.0,
        "longitude": double.tryParse(item["lon"].toString()) ?? 0.0,
        "name": addr["city"]    ??
            addr["town"]    ??
            addr["village"] ??
            addr["county"]  ??
            (item["display_name"]?.toString().split(",")[0] ?? city),
        "country_code":
        (addr["country_code"] ?? "").toString().toUpperCase(),
      };
    } catch (_) {
      return null;
    }
  }


  Future<WeatherModel> fetchWeather(String city) async {
    final cleanCity = city.trim();


    Map<String, dynamic>? geo = await _geoFromOpenMeteo(cleanCity);
    geo ??= await _geoFromNominatim(cleanCity);

    if (geo == null) {
      throw Exception(
        '"$cleanCity" not found.\nCheck spelling or try a nearby city.',
      );
    }

    final double lat = (geo["latitude"]  as num).toDouble();
    final double lon = (geo["longitude"] as num).toDouble();
    final String cityName    = geo["name"]?.toString() ?? cleanCity;
    final String countryCode = (geo["country_code"] ?? "").toString().toUpperCase();
    final String displayName = countryCode.isNotEmpty ? "$cityName, $countryCode" : cityName;

    // Build URL using Uri.https so every part is encoded correctly
    final weatherUri = Uri.https(
      "api.open-meteo.com",
      "/v1/forecast",
      {
        "latitude":  lat.toString(),
        "longitude": lon.toString(),
        "current":   "temperature_2m,relative_humidity_2m,apparent_temperature,wind_speed_10m,weather_code,surface_pressure",
        "daily":     "weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max",
        "timezone":  "auto",
        "forecast_days": "7",
      },
    );

    http.Response weatherRes;
    try {
      weatherRes = await http
          .get(weatherUri)
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      throw Exception("No internet connection.\nCheck your network and try again.");
    } on TimeoutException {
      throw Exception("Request timed out. Try again.");
    }

    if (weatherRes.statusCode != 200) {

      print("Weather API error ${weatherRes.statusCode}: ${weatherRes.body}");
      throw Exception("Weather data unavailable (${weatherRes.statusCode}). Try again.");
    }

    final Map<String, dynamic> weatherData = jsonDecode(weatherRes.body);

    final current = weatherData["current"] as Map<String, dynamic>? ?? {};
    final daily   = weatherData["daily"]   as Map<String, dynamic>? ?? {};

    final List times        = (daily["time"]                             as List?) ?? [];
    final List maxTemps     = (daily["temperature_2m_max"]               as List?) ?? [];
    final List minTemps     = (daily["temperature_2m_min"]               as List?) ?? [];
    final List weatherCodes = (daily["weather_code"]                     as List?) ?? [];

    final List<ForecastModel> forecasts = [];
    for (int i = 0; i < times.length; i++) {
      forecasts.add(ForecastModel(
        date:        times[i].toString(),
        maxTemp:     double.tryParse(maxTemps[i].toString())     ?? 0.0,
        minTemp:     double.tryParse(minTemps[i].toString())     ?? 0.0,
        weatherCode: int.tryParse(weatherCodes[i].toString())   ?? 0,
      ));
    }

    return WeatherModel(
      cityName:    displayName,
      temperature: double.tryParse(current["temperature_2m"]?.toString()        ?? "") ?? 0.0,
      windSpeed:   double.tryParse(current["wind_speed_10m"]?.toString()        ?? "") ?? 0.0,
      humidity:    int.tryParse(current["relative_humidity_2m"]?.toString()     ?? "") ?? 0,
      weatherCode: int.tryParse(current["weather_code"]?.toString()             ?? "") ?? 0,
      forecasts:   forecasts,
    );
  }
}