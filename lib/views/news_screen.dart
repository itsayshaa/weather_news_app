import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../providers/theme_provider.dart';

import '../utils/app_text_styles.dart';
import '../utils/constants.dart';

import '../widgets/custom_loader.dart';
import '../widgets/error_widget.dart';
import '../widgets/news_card.dart';

import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NewsProvider>(context, listen: false).getNews("technology");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeProvider.gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text("Top Headlines", style: AppTextStyles.whiteHeading),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.newsCategories.length,
                  itemBuilder: (context, index) {
                    final category = AppConstants.newsCategories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ChoiceChip(
                        label: Text(
                          category.toUpperCase(),
                          style: AppTextStyles.chipText,
                        ),
                        selected: provider.selectedCategory == category,
                        onSelected: (_) => provider.getNews(category),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refreshNews,
                  color: themeProvider.primary,
                  child: provider.isLoading
                      ? const CustomLoader()
                      : provider.error.isNotEmpty
                      ? CustomErrorWidget(message: provider.error)
                      : ListView.builder(
                    itemCount: provider.news.length,
                    itemBuilder: (context, index) {
                      final news = provider.news[index];
                      return NewsCard(
                        news: news,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  NewsDetailsScreen(news: news),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
