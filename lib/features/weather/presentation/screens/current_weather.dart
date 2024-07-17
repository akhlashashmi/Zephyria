import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:weather/features/weather/data/models/weather_forcast.dart';
import 'package:weather/features/weather/presentation/controllers/current_location_controller.dart';
import 'package:weather/features/weather/presentation/controllers/weather_controller.dart';
import 'package:weather/features/weather/utils/hive_constants.dart';
import 'package:weather/features/weather/utils/utils.dart';

class CurrentWeather extends ConsumerWidget {
  const CurrentWeather({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation =
        ref.watch(currentLocationProvider(HiveBoxes.preferences));
    // final weatherAsyncValue = ref.watch(currentWeatherProvider(currentLocation));
    final forcastAsyncValue =
        ref.watch(fiveDayForecastProvider(currentLocation));

    final Size size = MediaQuery.of(context).size;
    return forcastAsyncValue.when(
      data: (WeatherForcast weather) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.05),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.7,
                  child: Text(
                    weather.current.condition.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
                SizedBox(height: size.height * 0.002),
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.5,
                  child: Text(
                    Utils.formatTo12HourTime(
                        weather.current.lastUpdated.toString()),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer
                              .withOpacity(0.8),
                        ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              width: size.width * 0.5,
              height: size.height * 0.3,
              child: Text(
                '${(weather.current.tempC).toStringAsFixed(0)}°',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 70,
                    ),
              ),
            ),
            // SizedBox(
            //   width: size.width * 0.5,
            //   height: size.height * 0.3,
            //   child: Lottie.asset(
            //     Utils.getAnimationFileName(
            //       weather.current.condition.text.toString(),
            //     ),
            //   ),
            // ),
            SizedBox(height: size.height * 0.01),

            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         '${(weather.current.tempC).toStringAsFixed(0)}°',
            //         style: Theme.of(context).textTheme.displayLarge!.copyWith(
            //               color: Theme.of(context)
            //                   .colorScheme
            //                   .onSecondaryContainer,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 50,
            //             ),
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.end,
            //         children: [
            //           Text(
            //             weather.location.name,
            //             style: Theme.of(context).textTheme.titleLarge!.copyWith(
            //                   color: Theme.of(context)
            //                       .colorScheme
            //                       .onSecondaryContainer,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //           ),
            //           Text(
            //             '${weather.location.region}, ${weather.location.country}',
            //             style: Theme.of(context).textTheme.bodySmall!.copyWith(
            //                   color: Theme.of(context)
            //                       .colorScheme
            //                       .onSecondaryContainer,
            //                 ),
            //           ),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            SizedBox(height: size.height * 0.015),
            SizedBox(
              width: size.width * 0.92,
              height: size.height * 0.15,
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.015),
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InfoCardChild(
                      svgPath: 'assets/svg/drop-humidity-icon.svg',
                      value: '${weather.current.humidity} %',
                      description: 'Humidity',
                      elevation: 0,
                    ),
                    InfoCardChild(
                      svgPath: 'assets/svg/wind.svg',
                      value:
                          '${weather.current.windKph.toStringAsFixed(0)} km/h',
                      description: 'Wind Speed',
                      elevation: 0,
                    ),
                    InfoCardChild(
                      svgPath: 'assets/svg/visibility.svg',
                      value: '${weather.current.visKm} km',
                      description: 'Visibility',
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height * 0.015),
            // Container(
            //   clipBehavior: Clip.hardEdge,
            //   alignment: Alignment.center,
            //   width: size.width * 0.9,
            //   height: size.height * 0.15,
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).colorScheme.surface,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: weather.forecast.forecastday.length,
            //     itemBuilder: (context, index) {
            //       return ForcastCard(
            //         iconPath: formatIconUrl(weather
            //                 .forecast.forecastday[index].day.condition.icon)
            //             .replaceFirst('file', 'https'),
            //         value:
            //             '${weather.forecast.forecastday[index].day.maxtempC}° C',
            //         description: weather
            //             .forecast.forecastday[index].day.condition.text
            //             .toString(),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(height: size.height * 0.015),
            Container(
              clipBehavior: Clip.hardEdge,
              width: size.width * 0.85,
              // height: size.height * 0.15,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    'Hourly Forcast',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    '3 Days Forcast',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.015),
            Container(
              clipBehavior: Clip.hardEdge,
              alignment: Alignment.center,
              width: size.width * 0.9,
              height: size.height * 0.15,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weather.forecast.forecastday.first.hour.length,
                itemBuilder: (context, index) {
                  return ForcastCard(
                    iconPath: formatIconUrl(weather.forecast.forecastday.first
                            .hour[index].condition.icon)
                        .replaceFirst('file', 'https'),
                    value:
                        '${weather.forecast.forecastday.first.hour[index].tempC}° C',
                    description: toHourlyForcastTime(
                        weather.forecast.forecastday.first.hour[index].time),
                  );
                },
              ),
            ),
            SizedBox(height: size.height * 0.015),
          ],
        ),
      ),
      loading: () => Center(
        child: SizedBox(
          width: size.width * 0.15,
          height: size.width * 0.15,
          child: const CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
      error: (err, stack) => const Center(
        child: Text(
          'Error',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

String formatIconUrl(String url) {
  if (url.startsWith('//')) {
    return 'https:$url';
  } else if (url.startsWith('file://')) {
    return url.replaceAll('file://', 'https://');
  } else {
    // Assume it's already in https format
    return url;
  }
}

String toHourlyForcastTime(String dateTimeString) {
  // Split the datetime string into date and time parts
  List<String> parts = dateTimeString.split(' ');

  // Extract the time part (e.g., "14:00")
  String timePart = parts[1];

  // Parse the hour and minute from the time part
  List<String> timeParts = timePart.split(':');
  int hour = int.parse(timeParts[0]);
  // int minute = int.parse(timeParts[1]);

  // Determine AM/PM and format the hour accordingly
  String period = (hour >= 12) ? 'PM' : 'AM';
  if (hour == 0) {
    hour = 12; // Midnight edge case
  } else if (hour > 12) {
    hour -= 12; // Convert 24-hour format to 12-hour format
  }

  // Construct the formatted time string
  String formattedTime = '$hour $period';

  return formattedTime;
}

class ForcastCard extends StatelessWidget {
  const ForcastCard(
      {super.key,
      required this.iconPath,
      required this.value,
      required this.description});
  final String iconPath;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.26,
      height: size.height * 0.15,
      child: Card(
        elevation: 0.5,
        margin:
            EdgeInsets.symmetric(horizontal: size.width * 0.015, vertical: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
              textAlign: TextAlign.center,
            ),
            Container(
              alignment: Alignment.center,
              width: 30,
              height: 30,
              child: Image.network(
                iconPath,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCardChild extends StatelessWidget {
  const InfoCardChild({
    super.key,
    required this.svgPath,
    required this.value,
    required this.description,
    this.elevation,
  });
  final String svgPath;
  final String value;
  final String description;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.26,
      height: size.height * 0.15,
      child: Card(
        elevation: elevation ?? 0.5,
        margin:
            EdgeInsets.symmetric(horizontal: size.width * 0.015, vertical: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSecondaryContainer,
                BlendMode.srcIn,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
