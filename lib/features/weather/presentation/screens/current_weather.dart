import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/features/weather/data/models/weather_forcast.dart';
import 'package:weather/features/weather/presentation/controllers/weather_controller.dart';

class CurrentWeather extends ConsumerStatefulWidget {
  const CurrentWeather({super.key});

  @override
  ConsumerState<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends ConsumerState<CurrentWeather>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final int _selectedDayIndex = 0;
  late ScrollController _hourlyScrollController;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _initializeAnimations();
    _hourlyScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _hourlyScrollController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  Future<void> _initializeLocation() async {
    try {
      final locationStatus = await Geolocator.checkPermission();
      if (locationStatus == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (e) {
      debugPrint('Error initializing location: $e');
    }
  }

  void _scrollToCurrentHour() {
    if (!_hourlyScrollController.hasClients) return;

    final now = DateTime.now();
    final currentHour = now.hour;

    // Calculate scroll position (each card is 85 width + 12 margin = 97 pixels)
    // Subtract half the screen width to center the current hour
    final screenWidth = MediaQuery.of(context).size.width;
    final scrollPosition = (currentHour * 97.0) - (screenWidth / 2) + 97.0;

    // Ensure we don't scroll beyond bounds
    final maxScroll = _hourlyScrollController.position.maxScrollExtent;
    final targetScroll = scrollPosition.clamp(0.0, maxScroll);

    // Animate to the position with a spring effect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hourlyScrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeOutBack, // Gives a nice spring effect
      );
    });
  }

  Widget _buildHourlyForecastPage(WeatherForcast weather) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedDay = weather.forecast.forecastday[_selectedDayIndex];

    // Add scroll listener to handle scroll physics
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          // Add a slight bounce effect when scrolling ends
          final currentOffset = _hourlyScrollController.position.pixels;
          final previousOffset = notification.metrics.extentBefore;
          final isScrollingForward = currentOffset > previousOffset;

          _hourlyScrollController
              .animateTo(
            _hourlyScrollController.offset + (isScrollingForward ? 20 : -20),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          )
              .then((_) {
            _hourlyScrollController.animateTo(
              _hourlyScrollController.offset,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInCubic,
            );
          });
        }
        return false;
      },
      child: Container(
        color: colorScheme.surface,
        child: Column(
          children: [
            _buildPageIndicator(2),
            const SizedBox(height: 20),
            Text(
              'Hourly Forecast',
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              getDayFromDate(selectedDay.date.toString()),
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                controller: _hourlyScrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: selectedDay.hour.length,
                itemBuilder: (context, index) {
                  final hour = selectedDay.hour[index];
                  return _buildHourlyForecastCard(hour, index);
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void scrollToCurrentTime() {
    _scrollToCurrentHour();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final weatherAsyncValue = ref.watch(weatherByLocationProvider);

    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme(
          color: colorScheme.surface,
          elevation: 0,
        ),
      ),
      child: weatherAsyncValue.when(
        data: (WeatherForcast weather) => _buildWeatherContent(weather),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildWeatherContent(WeatherForcast weather) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildCurrentWeatherPage(weather),
          _buildDailyForecastPage(weather),
          _buildHourlyForecastPage(weather),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherPage(WeatherForcast weather) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.surface,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight),
            Text(
              weather.location.name,
              style: textTheme.displaySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              '${weather.location.region}, ${weather.location.country}',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const Spacer(flex: 1),
            _buildAnimatedWeatherIcon(weather),
            const SizedBox(height: 20),
            _buildTemperatureDisplay(weather),
            const Spacer(flex: 1),
            _buildWeatherMetrics(weather),
            const Spacer(flex: 1),
            _buildPageIndicator(0),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedWeatherIcon(WeatherForcast weather) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Card(
        elevation: 0,
        shape: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Hero(
            tag: 'weather_icon',
            child: Image.network(
              formatIconUrl(weather.current.condition.icon),
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyForecastPage(WeatherForcast weather) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.surface,
      child: Column(
        children: [
          _buildPageIndicator(1),
          const SizedBox(height: 20),
          Text(
            '3-Day Forecast',
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: weather.forecast.forecastday.take(3).length,
              itemBuilder: (context, index) {
                final day = weather.forecast.forecastday[index];
                return _buildDailyForecastCard(day, index);
              },
            ),
          ),
          _buildPageIndicator(2),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDailyForecastCard(Forecastday day, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = index == _selectedDayIndex;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.1) : colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getDayFromDate(day.date.toString()),
                      style: textTheme.titleLarge?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.day.condition.text,
                      style: textTheme.bodyMedium?.copyWith(
                        color: (isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface)
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.network(
                      formatIconUrl(day.day.condition.icon),
                      width: 48,
                      height: 48,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${day.day.maxtempC.round()}°',
                          style: textTheme.titleLarge?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${day.day.mintempC.round()}°',
                          style: textTheme.bodyLarge?.copyWith(
                            color: (isSelected
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurface)
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDailyMetric(
                  icon: Icons.water_drop,
                  value: '${day.day.avghumidity}%',
                  label: 'Humidity',
                  isSelected: isSelected,
                ),
                _buildDailyMetric(
                  icon: Icons.air,
                  value: '${day.day.maxwindKph}km/h',
                  label: 'Wind',
                  isSelected: isSelected,
                ),
                _buildDailyMetric(
                  icon: Icons.umbrella,
                  value: '${day.day.dailyChanceOfRain}%',
                  label: 'Rain',
                  isSelected: isSelected,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyMetric({
    required IconData icon,
    required String value,
    required String label,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color =
        isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface;

    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecastCard(Hour hour, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final hourTime = DateTime.parse(hour.time);
    final isCurrentHour = now.hour == hourTime.hour && now.day == hourTime.day;

    return Card(
      margin: const EdgeInsets.only(right: 12),
      color: isCurrentHour ? colorScheme.primaryContainer.withValues(alpha: 0.2) : colorScheme.surface,
      child: Container(
        width: 85, // Reduced width
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Makes the column take minimum space
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              toHourlyForcastTime(hour.time),
              style: textTheme.bodyMedium?.copyWith(
                color: isCurrentHour
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Image.network(
              formatIconUrl(hour.condition.icon),
              width: 40, // Reduced size
              height: 40,
            ),
            const SizedBox(height: 8),
            Text(
              '${hour.tempC.round()}°',
              style: textTheme.titleLarge?.copyWith(
                color: isCurrentHour
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Combine humidity and wind in a more compact way
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.water_drop,
                      size: 14,
                      color: (isCurrentHour
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface)
                          .withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${hour.humidity}%',
                      style: textTheme.bodySmall?.copyWith(
                        color: (isCurrentHour
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface)
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.air,
                      size: 14,
                      color: (isCurrentHour
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface)
                          .withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${hour.windKph}',
                      style: textTheme.bodySmall?.copyWith(
                        color: (isCurrentHour
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface)
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int page) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: 0.8,
      child: Icon(
        page == 0 ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
        color: colorScheme.onSurface,
        size: 30,
      ),
    );
  }

  Widget _buildLoadingState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Fetching weather data...',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: colorScheme.onError,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load weather data',
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onError,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onError.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  // ref.refresh(weatherByLocationProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureDisplay(WeatherForcast weather) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          '${weather.current.tempC.round()}°',
          style: textTheme.displayLarge?.copyWith(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          weather.current.condition.text,
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherMetrics(WeatherForcast weather) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetricItem(
              icon: Icons.water_drop,
              value: '${weather.current.humidity}%',
              label: 'Humidity',
            ),
            _buildMetricItem(
              icon: Icons.air,
              value: '${weather.current.windKph}km/h',
              label: 'Wind',
            ),
            _buildMetricItem(
              icon: Icons.visibility,
              value: '${weather.current.visKm}km',
              label: 'Visibility',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Column(
        children: [
          Icon(icon, color: colorScheme.onPrimaryContainer, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

//
// class CurrentWeather extends ConsumerStatefulWidget {
//   const CurrentWeather({super.key});
//
//   @override
//   ConsumerState<CurrentWeather> createState() => _CurrentWeatherState();
// }
//
// class _CurrentWeatherState extends ConsumerState<CurrentWeather>
//     with SingleTickerProviderStateMixin {
//   final ScrollController _scrollController = ScrollController();
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   double _scrollProgress = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     _initializeLocation();
//     _initializeAnimations();
//   }
//
//   void _initializeAnimations() {
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
//
//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOut,
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutCubic,
//     ));
//
//     _animationController.forward();
//   }
//
//   Future<void> _initializeLocation() async {
//     try {
//       final locationStatus = await Geolocator.checkPermission();
//       if (locationStatus == LocationPermission.denied) {
//         await Geolocator.requestPermission();
//       }
//     } catch (e) {
//       debugPrint('Error initializing location: $e');
//     }
//   }
//
//   void _onScroll() {
//     setState(() {
//       _scrollProgress = (_scrollController.offset / 300).clamp(0.0, 1.0);
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final weatherAsyncValue = ref.watch(weatherByLocationProvider);
//
//     return Theme(
//       data: Theme.of(context).copyWith(
//         cardTheme: CardTheme(
//           color: colorScheme.surfaceVariant.withValues(alpha: 0.8),
//           elevation: 0,
//         ),
//       ),
//       child: weatherAsyncValue.when(
//         data: (WeatherForcast weather) => _buildWeatherContent(weather),
//         loading: () => _buildLoadingState(),
//         error: (error, stack) => _buildErrorState(error),
//       ),
//     );
//   }
//
//   Widget _buildWeatherContent(WeatherForcast weather) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Scaffold(
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SlideTransition(
//           position: _slideAnimation,
//           child: CustomScrollView(
//             controller: _scrollController,
//             physics: const BouncingScrollPhysics(),
//             slivers: [
//               SliverToBoxAdapter(
//                 child: _buildMainWeatherSection(weather),
//               ),
//               SliverFadeTransition(
//                 opacity: _fadeAnimation,
//                 sliver: SliverToBoxAdapter(
//                   child: _buildHourlyForecastSection(weather),
//                 ),
//               ),
//               SliverFadeTransition(
//                 opacity: _fadeAnimation,
//                 sliver: SliverToBoxAdapter(
//                   child: _buildDailyForecastSection(weather),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMainWeatherSection(WeatherForcast weather) {
//     final textTheme = Theme.of(context).textTheme;
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           const SizedBox(height: kToolbarHeight),
//           Text(
//             weather.location.name,
//             style: textTheme.displaySmall?.copyWith(
//               color: colorScheme.onPrimaryContainer,
//               fontWeight: FontWeight.w300,
//             ),
//           ),
//           Text(
//             '${weather.location.region}, ${weather.location.country}',
//             style: textTheme.bodyLarge?.copyWith(
//               color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
//             ),
//           ),
//           const Spacer(flex: 1),
//           _buildWeatherIcon(weather),
//           const SizedBox(height: 20),
//           _buildTemperatureDisplay(weather),
//           const Spacer(flex: 1),
//           _buildWeatherMetrics(weather),
//           const Spacer(flex: 1),
//           TweenAnimationBuilder<double>(
//             tween: Tween(begin: 1.0, end: 1 - _scrollProgress),
//             duration: const Duration(milliseconds: 300),
//             builder: (context, value, child) {
//               return Opacity(
//                 opacity: value,
//                 child: child,
//               );
//             },
//             child: _buildScrollIndicator(),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWeatherIcon(WeatherForcast weather) {
//     return Hero(
//       tag: 'weather_icon_current',
//       child: Container(
//         width: 120,
//         height: 120,
//         decoration: BoxDecoration(
//           color:
//               Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
//           shape: BoxShape.circle,
//         ),
//         child: Image.network(
//           formatIconUrl(weather.current.condition.icon),
//           scale: 0.5,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTemperatureDisplay(WeatherForcast weather) {
//     final textTheme = Theme.of(context).textTheme;
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Column(
//       children: [
//         Text(
//           '${weather.current.tempC.round()}°',
//           style: textTheme.displayLarge?.copyWith(
//             color: colorScheme.onPrimaryContainer,
//             fontWeight: FontWeight.w200,
//           ),
//         ),
//         Text(
//           weather.current.condition.text,
//           style: textTheme.headlineSmall?.copyWith(
//             color: colorScheme.onPrimaryContainer,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWeatherMetrics(WeatherForcast weather) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Card(
//       color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildMetricItem(
//               icon: Icons.water_drop,
//               value: '${weather.current.humidity}%',
//               label: 'Humidity',
//             ),
//             _buildMetricItem(
//               icon: Icons.air,
//               value: '${weather.current.windKph}km/h',
//               label: 'Wind',
//             ),
//             _buildMetricItem(
//               icon: Icons.visibility,
//               value: '${weather.current.visKm}km',
//               label: 'Visibility',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMetricItem({
//     required IconData icon,
//     required String value,
//     required String label,
//   }) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: const Duration(milliseconds: 800),
//       curve: Curves.easeOutCubic,
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: value,
//           child: child,
//         );
//       },
//       child: Column(
//         children: [
//           Icon(icon, color: colorScheme.onPrimaryContainer, size: 24),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: textTheme.titleMedium?.copyWith(
//               color: colorScheme.onPrimaryContainer,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             label,
//             style: textTheme.bodySmall?.copyWith(
//               color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHourlyForecastSection(WeatherForcast weather) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       margin: const EdgeInsets.only(top: 20),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Hourly Forecast',
//             style: textTheme.headlineSmall?.copyWith(
//               color: colorScheme.onPrimaryContainer,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 120,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               physics: const BouncingScrollPhysics(),
//               itemCount: weather.forecast.forecastday.first.hour.length,
//               itemBuilder: (context, index) {
//                 final hour = weather.forecast.forecastday.first.hour[index];
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: _buildHourlyForecastCard(hour),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHourlyForecastCard(Hour hour) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Card(
//       child: Container(
//         width: 80,
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               toHourlyForcastTime(hour.time),
//               style: textTheme.bodyMedium?.copyWith(
//                 color: colorScheme.onSurfaceVariant,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Hero(
//               tag: 'weather_icon_${hour.time}',
//               child: Image.network(
//                 formatIconUrl(hour.condition.icon),
//                 width: 32,
//                 height: 32,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '${hour.tempC.round()}°',
//               style: textTheme.titleMedium?.copyWith(
//                 color: colorScheme.onSurfaceVariant,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDailyForecastSection(WeatherForcast weather) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       margin: const EdgeInsets.only(top: 20),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: colorScheme.surfaceVariant.withValues(alpha: 0.1),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '3-Day Forecast',
//             style: textTheme.headlineSmall?.copyWith(
//               color: colorScheme.onPrimaryContainer,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),
//           ...weather.forecast.forecastday
//               .take(3)
//               .map((day) => _buildDailyForecastCard(day)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDailyForecastCard(Forecastday day) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 10),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               getDayFromDate(day.date.toString()),
//               style: textTheme.titleMedium?.copyWith(
//                 color: colorScheme.onSurfaceVariant,
//               ),
//             ),
//             Row(
//               children: [
//                 Hero(
//                   tag: 'weather_icon_${day.date}',
//                   child: Image.network(
//                     formatIconUrl(day.day.condition.icon),
//                     width: 24,
//                     height: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   '${day.day.avgtempC.round()}°',
//                   style: textTheme.titleMedium?.copyWith(
//                     color: colorScheme.onSurfaceVariant,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildScrollIndicator() {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Column(
//       children: [
//         Icon(
//           Icons.keyboard_arrow_up,
//           color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
//           size: 30,
//         ),
//         Text(
//           'Swipe up for more details',
//           style: textTheme.bodySmall?.copyWith(
//             color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoadingState() {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       decoration: BoxDecoration(),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TweenAnimationBuilder<double>(
//               tween: Tween(begin: 0.0, end: 1.0),
//               duration: const Duration(milliseconds: 1500),
//               builder: (context, value, child) {
//                 return Transform.scale(
//                   scale: value,
//                   child: child,
//                 );
//               },
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: colorScheme.onPrimaryContainer,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Fetching weather data...',
//               style: textTheme.bodyLarge?.copyWith(
//                 color: colorScheme.onPrimaryContainer,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorState(Object error) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//
//     return Container(
//       decoration: BoxDecoration(),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.error_outline,
//                 size: 48,
//                 color: colorScheme.onError,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'Failed to load weather data',
//                 style: textTheme.titleLarge?.copyWith(
//                   color: colorScheme.onError,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 error.toString(),
//                 textAlign: TextAlign.center,
//                 style: textTheme.bodyMedium?.copyWith(
//                   color: colorScheme.onError.withValues(alpha: 0.8),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               FilledButton.icon(
//                 onPressed: () {
//                   ref.refresh(weatherByLocationProvider);
//                 },
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Try Again'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
String getDayFromDate(String date) {
  final dateTime = DateTime.parse(date);
  final now = DateTime.now();
  if (dateTime.day == now.day) {
    return 'Today';
  } else if (dateTime.day == now.day + 1) {
    return 'Tomorrow';
  } else {
    return DateFormat('EEEE').format(dateTime);
  }
}

String formatIconUrl(String url) {
  if (url.startsWith('//')) {
    return 'https:$url';
  } else if (url.startsWith('file://')) {
    return url.replaceAll('file://', 'https://');
  } else {
    return url;
  }
}

String toHourlyForcastTime(String dateTimeString) {
  List<String> parts = dateTimeString.split(' ');
  String timePart = parts[1];
  List<String> timeParts = timePart.split(':');
  int hour = int.parse(timeParts[0]);

  String period = (hour >= 12) ? 'PM' : 'AM';
  if (hour == 0) {
    hour = 12;
  } else if (hour > 12) {
    hour -= 12;
  }

  return '$hour $period';
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:svg_flutter/svg.dart';
// import 'package:weather/features/weather/data/models/weather_forcast.dart';
// import 'package:weather/features/weather/presentation/controllers/weather_controller.dart';
//
// class CurrentWeather extends ConsumerStatefulWidget {
//   const CurrentWeather({super.key});
//
//   @override
//   ConsumerState<CurrentWeather> createState() => _CurrentWeatherState();
// }
//
// class _CurrentWeatherState extends ConsumerState<CurrentWeather> {
//   final ScrollController _scrollController = ScrollController();
//   double _scrollProgress = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     _initializeLocation();
//   }
//
//   void _onScroll() {
//     setState(() {
//       _scrollProgress = (_scrollController.offset / 300).clamp(0.0, 1.0);
//     });
//   }
//
//   Future<void> _initializeLocation() async {
//     try {
//       final locationStatus = await Geolocator.checkPermission();
//       if (locationStatus == LocationPermission.denied) {
//         await Geolocator.requestPermission();
//       }
//     } catch (e) {
//       debugPrint('Error initializing location: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final weatherAsyncValue = ref.watch(weatherByLocationProvider);
//
//     return weatherAsyncValue.when(
//       data: (WeatherForcast weather) => _buildWeatherContent(weather),
//       loading: () => _buildLoadingState(),
//       error: (error, stack) => _buildErrorState(error),
//     );
//   }
//
//   Widget _buildWeatherContent(WeatherForcast weather) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.blue.shade400,
//               Colors.blue.shade600,
//             ],
//           ),
//         ),
//         child: CustomScrollView(
//           controller: _scrollController,
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             // Main Weather Display
//             SliverToBoxAdapter(
//               child: _buildMainWeatherSection(weather),
//             ),
//             // Hourly Forecast
//             SliverToBoxAdapter(
//               child: _buildHourlyForecastSection(weather),
//             ),
//             // 3-Day Forecast
//             SliverToBoxAdapter(
//               child: _buildDailyForecastSection(weather),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMainWeatherSection(WeatherForcast weather) {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           const SizedBox(height: kToolbarHeight),
//           // Location
//           _buildLocationHeader(weather),
//           const SizedBox(height: 40),
//           // Weather Icon
//           _buildWeatherIcon(weather),
//           const SizedBox(height: 20),
//           // Temperature
//           _buildTemperatureDisplay(weather),
//           const SizedBox(height: 40),
//           // Weather Metrics
//           _buildWeatherMetrics(weather),
//           const Spacer(),
//           // Scroll Indicator
//           _buildScrollIndicator(),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLocationHeader(WeatherForcast weather) {
//     return Column(
//       children: [
//         Text(
//           weather.location.name,
//           style: const TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.w300,
//             color: Colors.white,
//           ),
//         ),
//         Text(
//           '${weather.location.region}, ${weather.location.country}',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.white.withValues(alpha: 0.8),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWeatherIcon(WeatherForcast weather) {
//     return Container(
//       width: 120,
//       height: 120,
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.1),
//         shape: BoxShape.circle,
//       ),
//       child: Image.network(
//         formatIconUrl(weather.current.condition.icon),
//         scale: 0.5,
//       ),
//     );
//   }
//
//   Widget _buildTemperatureDisplay(WeatherForcast weather) {
//     return Column(
//       children: [
//         Text(
//           '${weather.current.tempC.round()}°',
//           style: const TextStyle(
//             fontSize: 72,
//             fontWeight: FontWeight.w200,
//             color: Colors.white,
//           ),
//         ),
//         Text(
//           weather.current.condition.text,
//           style: const TextStyle(
//             fontSize: 24,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWeatherMetrics(WeatherForcast weather) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.1),
//             blurRadius: 10,
//             spreadRadius: 5,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildMetricItem(
//             icon: Icons.water_drop,
//             value: '${weather.current.humidity}%',
//             label: 'Humidity',
//           ),
//           _buildMetricItem(
//             icon: Icons.air,
//             value: '${weather.current.windKph}km/h',
//             label: 'Wind',
//           ),
//           _buildMetricItem(
//             icon: Icons.visibility,
//             value: '${weather.current.visKm}km',
//             label: 'Visibility',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMetricItem({
//     required IconData icon,
//     required String value,
//     required String label,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.white, size: 24),
//         const SizedBox(height: 8),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.white.withValues(alpha: 0.8),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildHourlyForecastSection(WeatherForcast weather) {
//     return Container(
//       margin: const EdgeInsets.only(top: 20),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.1),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Hourly Forecast',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 120,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               physics: const BouncingScrollPhysics(),
//               itemCount: weather.forecast.forecastday.first.hour.length,
//               itemBuilder: (context, index) {
//                 final hour = weather.forecast.forecastday.first.hour[index];
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: _buildHourlyForecastCard(hour),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 20),
//           Center(child: _buildScrollIndicator()),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHourlyForecastCard(Hour hour) {
//     return Container(
//       width: 80,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             toHourlyForcastTime(hour.time),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Image.network(
//             formatIconUrl(hour.condition.icon),
//             width: 32,
//             height: 32,
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '${hour.tempC.round()}°',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDailyForecastSection(WeatherForcast weather) {
//     return Container(
//       margin: const EdgeInsets.only(top: 20),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.1),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             '3-Day Forecast',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 20),
//           ...weather.forecast.forecastday.take(3).map((day) => _buildDailyForecastCard(day)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDailyForecastCard(Forecastday day) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             getDayFromDate(day.date.toString()),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//             ),
//           ),
//           Row(
//             children: [
//               Image.network(
//                 formatIconUrl(day.day.condition.icon),
//                 width: 24,
//                 height: 24,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 '${day.day.avgtempC.round()}°',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildScrollIndicator() {
//     return Column(
//       children: [
//         Icon(
//           Icons.keyboard_arrow_up,
//           color: Colors.white.withValues(alpha: 0.8),
//           size: 30,
//         ),
//         Text(
//           'Swipe up for more details',
//           style: TextStyle(
//             color: Colors.white.withValues(alpha: 0.8),
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             strokeWidth: 2,
//             color: Colors.white,
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Fetching weather data...',
//             style: TextStyle(color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(Object error) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 48,
//               color: Theme.of(context).colorScheme.error,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Failed to load weather data',
//               style: TextStyle(color: Theme.of(context).colorScheme.error),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               error.toString(),
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodySmall,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: () {
//                 ref.refresh(weatherByLocationProvider);
//               },
//               icon: const Icon(Icons.refresh),
//               label: const Text('Try Again'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// String getDayFromDate(String date) {
//   final dateTime = DateTime.parse(date);
//   final now = DateTime.now();
//   if (dateTime.day == now.day) {
//     return 'Today';
//   } else if (dateTime.day == now.day + 1) {
//     return 'Tomorrow';
//   } else {
//     return DateFormat('EEEE').format(dateTime);
//   }
// }
//
// String formatIconUrl(String url) {
//   if (url.startsWith('//')) {
//     return 'https:$url';
//   } else if (url.startsWith('file://')) {
//     return url.replaceAll('file://', 'https://');
//   } else {
//     // Assume it's already in https format
//     return url;
//   }
// }
//
// String toHourlyForcastTime(String dateTimeString) {
//   // Split the datetime string into date and time parts
//   List<String> parts = dateTimeString.split(' ');
//
//   // Extract the time part (e.g., "14:00")
//   String timePart = parts[1];
//
//   // Parse the hour and minute from the time part
//   List<String> timeParts = timePart.split(':');
//   int hour = int.parse(timeParts[0]);
//   // int minute = int.parse(timeParts[1]);
//
//   // Determine AM/PM and format the hour accordingly
//   String period = (hour >= 12) ? 'PM' : 'AM';
//   if (hour == 0) {
//     hour = 12; // Midnight edge case
//   } else if (hour > 12) {
//     hour -= 12; // Convert 24-hour format to 12-hour format
//   }
//
//   // Construct the formatted time string
//   String formattedTime = '$hour $period';
//
//   return formattedTime;
// }
//
// class ForcastCard extends StatelessWidget {
//   const ForcastCard(
//       {super.key,
//       required this.iconPath,
//       required this.value,
//       required this.description});
//   final String iconPath;
//   final String value;
//   final String description;
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return SizedBox(
//       width: size.width * 0.26,
//       height: size.height * 0.15,
//       child: Card(
//         elevation: 0.5,
//         margin:
//             EdgeInsets.symmetric(horizontal: size.width * 0.015, vertical: 1),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               description,
//               style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).colorScheme.onSecondaryContainer,
//                   ),
//               textAlign: TextAlign.center,
//             ),
//             Container(
//               alignment: Alignment.center,
//               width: 30,
//               height: 30,
//               child: Image.network(
//                 iconPath,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Text(
//               value,
//               style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                     color: Theme.of(context).colorScheme.onSecondaryContainer,
//                     fontWeight: FontWeight.normal,
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class InfoCardChild extends StatelessWidget {
//   const InfoCardChild({
//     super.key,
//     required this.svgPath,
//     required this.value,
//     required this.description,
//     this.elevation,
//   });
//   final String svgPath;
//   final String value;
//   final String description;
//   final double? elevation;
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return SizedBox(
//       width: size.width * 0.26,
//       height: size.height * 0.15,
//       child: Card(
//         elevation: elevation ?? 0.5,
//         margin:
//             EdgeInsets.symmetric(horizontal: size.width * 0.015, vertical: 1),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SvgPicture.asset(
//               svgPath,
//               width: 20,
//               height: 20,
//               colorFilter: ColorFilter.mode(
//                 Theme.of(context).colorScheme.onSecondaryContainer,
//                 BlendMode.srcIn,
//               ),
//             ),
//             Text(
//               value,
//               style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                     color: Theme.of(context).colorScheme.onSecondaryContainer,
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                   ),
//             ),
//             Text(
//               description,
//               style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                     color: Theme.of(context)
//                         .colorScheme
//                         .onSecondaryContainer
//                         .withValues(alpha: 0.6),
//                   ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
