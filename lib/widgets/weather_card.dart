import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/weather_model.dart';

class WeatherCard
    extends StatelessWidget {

  final WeatherModel weather;

  const WeatherCard({
    super.key,
    required this.weather,
  });

  String getWeatherIcon(
      int code) {

    if (code == 0) {
      return "☀";
    } else if (code <= 3) {
      return "☁";
    } else if (code <= 67) {
      return "🌧";
    } else {
      return "⛈";
    }
  }

  @override
  Widget build(BuildContext context) {

    return ClipRRect(

      borderRadius:
      BorderRadius.circular(30),

      child: BackdropFilter(

        filter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),

        child: Container(

          padding:
          const EdgeInsets.all(25),

          decoration: BoxDecoration(

            color:
            Colors.white.withOpacity(
              0.10,
            ),

            borderRadius:
            BorderRadius.circular(
              30,
            ),

            border: Border.all(
              color:
              Colors.white24,
            ),
          ),

          child: Column(

            children: [

              Text(
                weather.cityName,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Text(
                getWeatherIcon(
                  weather.weatherCode,
                ),

                style: const TextStyle(
                  fontSize: 70,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                "${weather.temperature.toStringAsFixed(1)}°C",

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              Row(

                mainAxisAlignment:
                MainAxisAlignment
                    .spaceAround,

                children: [

                  weatherInfo(
                    Icons.water_drop,
                    "Humidity",
                    "${weather.humidity}%",
                  ),

                  weatherInfo(
                    Icons.air,
                    "Wind",
                    "${weather.windSpeed} km/h",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget weatherInfo(
      IconData icon,
      String title,
      String value,
      ) {

    return Column(

      children: [

        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),

        const SizedBox(
          height: 8,
        ),

        Text(
          title,

          style: const TextStyle(
            color: Colors.white70,
          ),
        ),

        const SizedBox(
          height: 4,
        ),

        Text(
          value,

          style: const TextStyle(
            color: Colors.white,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ],
    );
  }
}