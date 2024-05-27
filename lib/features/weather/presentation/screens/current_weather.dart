import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:weather/features/weather/data/models/weather_data.dart';
import 'package:weather/features/weather/presentation/controllers/current_location_controller.dart';
import 'package:weather/features/weather/presentation/controllers/weather_controller.dart';
import 'package:weather/features/weather/utils/hive_box_names.dart';
import 'package:weather/features/weather/utils/utils.dart';

class CurrentWeather extends ConsumerWidget {
  const CurrentWeather({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation =
        ref.watch(currentLocationProvider(HiveBoxes.preferences.name));
    final weatherAsyncValue =
        ref.watch(currentWeatherProvider(currentLocation));
    final Size size = MediaQuery.of(context).size;
    return weatherAsyncValue.when(
      data: (WeatherData weather) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.07),
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: size.width * 0.7,
                child: Text(
                  '${weather.current?.condition?.text}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface,
                      ),
                ),
              ),
              SizedBox(height: size.height * 0.002),
              Container(
                alignment: Alignment.center,
                width: size.width * 0.5,
                child: Text(
                  Utils.parseDateTime(
                      weather.current!.lastUpdated.toString()),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer.withOpacity(0.8),
                      ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.45,
            child: Lottie.asset(
              Utils.getAnimationFileName(
                weather.current!.condition!.text.toString(),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            padding: EdgeInsets.fromLTRB(
              size.width * 0.07,
              0,
              size.width * 0.07,
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(weather.current?.tempC)?.toStringAsFixed(0)}°',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${weather.location?.name}',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${weather.location?.region}, ${weather.location?.country}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.center,
            width: size.width * 0.9,
            height: size.height * 0.15,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InfoCardChild(
                    svgPath: 'assets/svg/thermometer-icon.svg',
                    value: '${weather.current?.feelslikeC}° C',
                    description: 'feels like'),
                InfoCardChild(
                    svgPath: 'assets/svg/drop-humidity-icon.svg',
                    value: '${weather.current?.humidity}',
                    description: 'humidity'),
                InfoCardChild(
                    svgPath: 'assets/svg/wind.svg',
                    value: '${weather.current?.windKph} kph',
                    description: 'wind speed'),
                InfoCardChild(
                    svgPath: 'assets/svg/visibility.svg',
                    value: '${weather.current?.visKm} km',
                    description: 'visibility'),
                InfoCardChild(
                    svgPath: 'assets/svg/pressure.svg',
                    value: '${weather.current?.pressureIn} ',
                    description: 'pressure'),
                InfoCardChild(
                    svgPath: 'assets/svg/gust.svg',
                    value: '${weather.current?.gustKph} kph',
                    description: 'gust'),
              ],
            ),
          )
        ],
      ),
      loading: () => Container(
        width: size.width,
        height: size.height,
        child: SizedBox(
          width: size.width * 1,
          height: size.width * 1,
          child: const CircularProgressIndicator(),
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

class InfoCardChild extends StatelessWidget {
  const InfoCardChild(
      {super.key,
      required this.svgPath,
      required this.value,
      required this.description});
  final String svgPath;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(size.width * 0.015, 0, size.width * 0.015, 0),
      alignment: Alignment.center,
      width: size.width * 0.24,
      height: size.height * 0.15,
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
        border:
            Border.all(color: Theme.of(context).colorScheme.secondaryContainer),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSecondaryContainer,
              BlendMode.srcIn,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSecondaryContainer
                      .withOpacity(0.5),
                ),
          ),
        ],
      ),
    );
  }
}
