import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../providers/theme_provider.dart';
import '../models/weather_model.dart';

import '../widgets/custom_loader.dart';
import '../widgets/error_widget.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  bool _showSearch = false;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    Future.microtask(() {
      Provider.of<WeatherProvider>(context, listen: false).loadSavedCity();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    searchController.dispose();
    super.dispose();
  }

  String getWeatherEmoji(int code) {
    if (code == 0) return '☀️';
    if (code <= 3) return '⛅';
    if (code <= 48) return '🌫️';
    if (code <= 57) return '🌧️';
    if (code <= 67) return '🌨️';
    if (code <= 77) return '❄️';
    if (code <= 82) return '🌦️';
    if (code <= 86) return '🌨️';
    return '⛈️';
  }

  String getWeatherLabel(int code) {
    if (code == 0) return 'Clear Sky';
    if (code <= 3) return 'Partly Cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 57) return 'Drizzle';
    if (code <= 67) return 'Rainy';
    if (code <= 77) return 'Snow';
    if (code <= 82) return 'Rain Showers';
    if (code <= 86) return 'Snow Showers';
    return 'Thunderstorm';
  }

  String getUVLevel(double temp) {
    if (temp >= 35) return 'Extreme';
    if (temp >= 28) return 'High';
    if (temp >= 20) return 'Moderate';
    return 'Low';
  }

  Color getUVColor(double temp) {
    if (temp >= 35) return const Color(0xffef4444);
    if (temp >= 28) return const Color(0xfff97316);
    if (temp >= 20) return const Color(0xfffbbf24);
    return const Color(0xff22c55e);
  }

  String getFeelsLike(double temp, double wind) {
    final feels = temp - (wind * 0.1);
    return feels.toStringAsFixed(1);
  }

  String getVisibility(int code) {
    if (code <= 1) return '10+ km';
    if (code <= 3) return '8 km';
    if (code <= 48) return '2 km';
    return '5 km';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: themeProvider.gradientColors.first,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeProvider.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: provider.isLoading
              ? const CustomLoader()
              : provider.error.isNotEmpty
              ? _buildErrorState(provider, themeProvider)
              : provider.weather == null
              ? _buildEmptyState(themeProvider)
              : _buildWeatherContent(
              provider, themeProvider, size, context),
        ),
      ),
    );
  }

  Widget _buildErrorState(WeatherProvider provider, ThemeProvider theme) {
    return Column(
      children: [
        _buildTopBar(theme),
        Expanded(child: CustomErrorWidget(message: provider.error)),
      ],
    );
  }

  Widget _buildEmptyState(ThemeProvider theme) {
    return Column(
      children: [
        _buildTopBar(theme),
        const Expanded(
          child: Center(
            child: Text(
              'Search a city to get started',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherContent(WeatherProvider provider, ThemeProvider theme,
      Size size, BuildContext context) {
    final weather = provider.weather!;

    return RefreshIndicator(
      onRefresh: provider.refreshWeather,
      color: theme.primary,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildTopBar(theme)),
          SliverToBoxAdapter(
              child: _buildHeroSection(weather, theme, size)),
          SliverToBoxAdapter(
              child: _buildStatsRow(weather, theme)),
          SliverToBoxAdapter(
              child: _buildSectionTitle('7-Day Forecast')),
          SliverToBoxAdapter(
              child: _buildForecastStrip(weather, theme)),
          SliverToBoxAdapter(
              child: _buildSectionTitle('Today\'s Highlights')),
          SliverToBoxAdapter(
              child: _buildHighlightsGrid(weather, theme)),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }


  Widget _buildTopBar(ThemeProvider theme) {
    final provider = Provider.of<WeatherProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  provider.currentCity.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _showSearch = !_showSearch),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(_showSearch ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showSearch ? Icons.close : Icons.search_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _showSearch ? 'Cancel' : 'Search',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _showSearch
                ? Padding(
              padding: const EdgeInsets.only(top: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (val) {
                        if (val.trim().isNotEmpty) {
                          Provider.of<WeatherProvider>(context,
                              listen: false)
                              .getWeather(val.trim());
                          setState(() => _showSearch = false);
                          searchController.clear();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter city name...',
                        hintStyle:
                        const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.search,
                            color: Colors.white54),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white),
                          onPressed: () {
                            final val = searchController.text.trim();
                            if (val.isNotEmpty) {
                              Provider.of<WeatherProvider>(context,
                                  listen: false)
                                  .getWeather(val);
                              setState(() => _showSearch = false);
                              searchController.clear();
                            }
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }


  Widget _buildHeroSection(
      WeatherModel weather, ThemeProvider theme, Size size) {
    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            ScaleTransition(
              scale: _pulseAnimation,
              child: Text(
                getWeatherEmoji(weather.weatherCode),
                style: const TextStyle(fontSize: 90),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${weather.temperature.toStringAsFixed(1)}°',
              style: TextStyle(
                color: Colors.white,
                fontSize: 86,
                fontWeight: FontWeight.w200,
                letterSpacing: -4,
                shadows: [
                  Shadow(
                    color: theme.primary.withOpacity(0.4),
                    blurRadius: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              getWeatherLabel(weather.weatherCode),
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 20,
                fontWeight: FontWeight.w300,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              weather.cityName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatsRow(WeatherModel weather, ThemeProvider theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statItem(Icons.water_drop_outlined, '${weather.humidity}%',
                    'Humidity'),
                _verticalDivider(),
                _statItem(Icons.air_rounded,
                    '${weather.windSpeed.toStringAsFixed(0)} km/h', 'Wind'),
                _verticalDivider(),
                _statItem(Icons.thermostat_outlined,
                    '${getFeelsLike(weather.temperature, weather.windSpeed)}°',
                    'Feels Like'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            )),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(width: 1, height: 44, color: Colors.white12);
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 1, color: Colors.white12)),
        ],
      ),
    );
  }

  Widget _buildForecastStrip(WeatherModel weather, ThemeProvider theme) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: weather.forecasts.length,
        itemBuilder: (context, index) {
          final f = weather.forecasts[index];
          final isToday = index == 0;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 90,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isToday
                        ? theme.primary.withOpacity(0.35)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isToday ? theme.primary : Colors.white12,
                      width: isToday ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        isToday ? 'Today' : _shortDay(f.date),
                        style: TextStyle(
                          color: isToday ? Colors.white : Colors.white70,
                          fontSize: 12,
                          fontWeight: isToday
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                      Text(
                        getWeatherEmoji(f.weatherCode),
                        style: const TextStyle(fontSize: 26),
                      ),
                      Column(
                        children: [
                          Text(
                            '${f.maxTemp.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${f.minTemp.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _shortDay(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      return days[date.weekday % 7];
    } catch (_) {
      return dateStr.length >= 5 ? dateStr.substring(5) : dateStr;
    }
  }

  Widget _buildHighlightsGrid(WeatherModel weather, ThemeProvider theme) {
    final items = [
      _HighlightItem(
        icon: Icons.wb_sunny_outlined,
        title: 'UV Index',
        value: getUVLevel(weather.temperature),
        subtitle: 'Based on temperature',
        valueColor: getUVColor(weather.temperature),
      ),
      _HighlightItem(
        icon: Icons.visibility_outlined,
        title: 'Visibility',
        value: getVisibility(weather.weatherCode),
        subtitle: 'Clear conditions',
        valueColor: Colors.white,
      ),
      _HighlightItem(
        icon: Icons.compress_rounded,
        title: 'Pressure',
        value: '1013 hPa',
        subtitle: 'Normal pressure',
        valueColor: Colors.white,
      ),
      _HighlightItem(
        icon: Icons.water_outlined,
        title: 'Humidity',
        value: '${weather.humidity}%',
        subtitle: weather.humidity > 70
            ? 'High — feels muggy'
            : weather.humidity > 40
            ? 'Comfortable'
            : 'Dry air',
        valueColor: Colors.white,
      ),
      _HighlightItem(
        icon: Icons.wind_power_outlined,
        title: 'Wind Speed',
        value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
        subtitle: weather.windSpeed > 40
            ? 'Strong winds'
            : weather.windSpeed > 20
            ? 'Moderate breeze'
            : 'Light breeze',
        valueColor: Colors.white,
      ),
      _HighlightItem(
        icon: Icons.thermostat_rounded,
        title: 'Feels Like',
        value:
        '${getFeelsLike(weather.temperature, weather.windSpeed)}°C',
        subtitle: 'Wind chill factor',
        valueColor: Colors.white,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildHighlightCard(items[index], theme);
        },
      ),
    );
  }

  Widget _buildHighlightCard(_HighlightItem item, ThemeProvider theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(item.icon, color: Colors.white54, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.value,
                    style: TextStyle(
                      color: item.valueColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightItem {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color valueColor;

  const _HighlightItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.valueColor,
  });
}