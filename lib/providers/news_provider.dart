import 'package:flutter/material.dart';

import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsProvider extends ChangeNotifier {

  final NewsService _service =
  NewsService();

  List<NewsModel> _news = [];

  List<NewsModel> get news =>
      _news;

  bool _isLoading = false;

  bool get isLoading =>
      _isLoading;

  String _error = "";

  String get error => _error;

  String _selectedCategory =
      "technology";

  String get selectedCategory =>
      _selectedCategory;

  Future<void> getNews(
      String category,
      ) async {

    try {

      _isLoading = true;

      _error = "";

      notifyListeners();

      _selectedCategory =
          category;

      final result =
      await _service
          .fetchNews(category);

      _news = result;

    } catch (e) {

      _error = e.toString();

    } finally {

      _isLoading = false;

      notifyListeners();
    }
  }

  Future<void> refreshNews()
  async {

    await getNews(
      _selectedCategory,
    );
  }
}