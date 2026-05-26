import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';

class ForecastCard
    extends StatelessWidget {

  final ForecastModel forecast;

  const ForecastCard({
    super.key,
    required this.forecast,
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

    return Container(

      width: 140,

      margin:
      const EdgeInsets.only(
        right: 15,
      ),

      child: ClipRRect(

        borderRadius:
        BorderRadius.circular(25),

        child: BackdropFilter(

          filter: ImageFilter.blur(
            sigmaX: 8,
            sigmaY: 8,
          ),

          child: Container(

            padding:
            const EdgeInsets.all(
              18,
            ),

            decoration: BoxDecoration(

              color:
              Colors.white.withOpacity(
                0.15,
              ),

              borderRadius:
              BorderRadius.circular(
                25,
              ),

              border: Border.all(
                color:
                Colors.white24,
              ),
            ),

            child: Column(

              mainAxisAlignment:
              MainAxisAlignment
                  .spaceEvenly,

              children: [

                Text(
                  DateFormat("EEE")
                      .format(
                    DateTime.parse(
                      forecast.date,
                    ),
                  ),

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                Text(
                  getWeatherIcon(
                    forecast.weatherCode,
                  ),

                  style: const TextStyle(
                    fontSize: 42,
                  ),
                ),

                Text(
                  "${forecast.maxTemp.toStringAsFixed(0)}° / ${forecast.minTemp.toStringAsFixed(0)}°",

                  textAlign:
                  TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}