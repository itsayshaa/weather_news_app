class ForecastModel {

  final String date;

  final double maxTemp;

  final double minTemp;

  final int weatherCode;

  ForecastModel({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });

  factory ForecastModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return ForecastModel(
      date: json["date"] ?? "",

      maxTemp:
      (json["maxTemp"] ?? 0)
          .toDouble(),

      minTemp:
      (json["minTemp"] ?? 0)
          .toDouble(),

      weatherCode:
      json["weatherCode"] ?? 0,
    );
  }
}

class WeatherModel {

  final String cityName;

  final double temperature;

  final double windSpeed;

  final int humidity;

  final int weatherCode;

  final List<ForecastModel>
  forecasts;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.weatherCode,
    required this.forecasts,
  });

  factory WeatherModel.fromJson({
    required String city,

    required Map<String, dynamic>
    currentWeather,

    required Map<String, dynamic>
    dailyData,
  }) {

    final List<ForecastModel>
    forecastList = [];

    final List dates =
        dailyData["time"] ?? [];

    final List maxTemps =
        dailyData[
        "temperature_2m_max"] ??
            [];

    final List minTemps =
        dailyData[
        "temperature_2m_min"] ??
            [];

    final List weatherCodes =
        dailyData["weathercode"] ??
            [];

    for (int i = 0;
    i < dates.length;
    i++) {

      forecastList.add(
        ForecastModel(
          date: dates[i],

          maxTemp:
          (maxTemps[i]).toDouble(),

          minTemp:
          (minTemps[i]).toDouble(),

          weatherCode:
          weatherCodes[i],
        ),
      );
    }

    return WeatherModel(

      cityName: city,

      temperature:
      (currentWeather[
      "temperature"] ??
          0)
          .toDouble(),

      windSpeed:
      (currentWeather[
      "windspeed"] ??
          0)
          .toDouble(),

      humidity:
      currentWeather[
      "relativehumidity"] ??
          0,

      weatherCode:
      currentWeather[
      "weathercode"] ??
          0,

      forecasts: forecastList,
    );
  }
}