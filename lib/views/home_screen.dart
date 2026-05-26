import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../widgets/theme_switcher_sheet.dart';

import 'news_screen.dart';
import 'weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const WeatherScreen(),
    const NewsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBody: true,

      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: themeProvider.primary.withOpacity(0.85),
        onPressed: () => ThemeSwitcherSheet.show(context),
        child: const Icon(Icons.palette_outlined, color: Colors.white, size: 20),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        backgroundColor: Colors.transparent,
        color: themeProvider.primary,
        buttonBackgroundColor: themeProvider.secondary,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.cloud, color: Colors.white),
          Icon(Icons.newspaper, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}