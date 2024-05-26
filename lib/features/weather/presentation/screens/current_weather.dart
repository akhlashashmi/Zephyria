import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    final currentLocation = ref.watch(currentLocationProvider(HiveBoxes.preferences.name));
    final weatherAsyncValue = ref.watch(currentWeatherProvider(currentLocation));
    final Size size = MediaQuery.of(context).size;
    return weatherAsyncValue.when(
      data: (WeatherData weather) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(size.width * 0.015),
              alignment: Alignment.center,
              width: size.width * 0.6,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: IntrinsicWidth(
                child: Text(
                  '${weather.location?.name}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.3,
            child: Lottie.asset(
              Utils.getAnimationFileName(
                  weather.current!.condition!.text.toString()),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${weather.current?.tempC}°',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                    ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            // padding: EdgeInsets.all(size.width * 0.05),
            alignment: Alignment.center,
            width: size.width * 0.9,
            height: size.height * 0.25,
            decoration: BoxDecoration(
              // color: Theme.of(context)
              //     .colorScheme
              //     .secondaryContainer
              //     .withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                InfoCardChild(
                    svgPath: 'assets/svg/thermometer-icon.svg',
                    value: '${weather.current?.feelslikeC}°',
                    description: 'feels like'),
                InfoCardChild(
                    svgPath: 'assets/svg/drop-humidity-icon.svg',
                    value: '${weather.current?.humidity}',
                    description: 'Humidity'),
                InfoCardChild(
                    svgPath: 'assets/svg/wind-icon.svg',
                    value: '${weather.current?.windMph}',
                    description: 'Wind Speed'),
                // Text('Temperature: ${weather.current?.feelslikeC}°C'),
                // Text('Humidity: ${weather.current?.humidity}%'),
                // Text('Wind Speed: ${weather.current?.windMph} mph'),
                // Text('Condition: ${weather.current?.condition?.text}'),
              ],
            ),
          )
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text(
        err.toString(),
        style: const TextStyle(color: Colors.red),
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
      alignment: Alignment.center,
      width: size.width * 0.24,
      height: size.height * 0.15,
      decoration: BoxDecoration(
        color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.3),
        border: Border.all(color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer),
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
