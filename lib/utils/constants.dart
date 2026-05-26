class AppConstants {

  static const String appName =
      "Weather + News Hybrid App";

  static const String defaultCity =
      "London";

  static const String geoCodingBaseUrl =
      "https://geocoding-api.open-meteo.com/v1/search";

  static const String weatherBaseUrl =
      "https://api.open-meteo.com/v1/forecast";

  static const String newsBaseUrl =
      "https://newsdata.io/api/1/latest";

  static const String newsApiKey =
      "pub_9c4deda9b70f4c60b667558f191e9d5a";

  static const List<String>
  newsCategories = [
    "sports",
    "technology",
    "business",
    "entertainment",
    "science",
    "health",
  ];
}