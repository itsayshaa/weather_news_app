import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/news_model.dart';

class NewsService {

  final String apiKey =
      "pub_9c4deda9b70f4c60b667558f191e9d5a";

  Future<List<NewsModel>> fetchNews(
      String category,
      ) async {

    try {

      final url =
          "https://newsdata.io/api/1/latest"
          "?apikey=$apiKey"
          "&country=us"
          "&language=en"
          "&category=$category";

      print(url);

      final response =
      await http
          .get(
        Uri.parse(url),
      )
          .timeout(
        const Duration(
          seconds: 10,
        ),
      );

      print(
        response.statusCode,
      );

      print(
        response.body,
      );

      if (response.statusCode ==
          200) {

        final data =
        jsonDecode(
          response.body,
        );

        final List articles =
            data["results"] ?? [];

        return articles.map(
              (article) {

            return NewsModel
                .fromJson(
              article,
            );
          },
        ).toList();

      } else {

        throw Exception(
          "Failed to load news",
        );
      }

    } on SocketException {

      throw Exception(
        "No Internet Connection",
      );

    } on HttpException {

      throw Exception(
        "Server Error",
      );

    } on FormatException {

      throw Exception(
        "Invalid Response",
      );

    } catch (e) {

      print(e);

      throw Exception(
        "Something went wrong",
      );
    }
  }
}