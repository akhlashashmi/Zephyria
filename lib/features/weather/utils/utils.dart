import 'package:flutter/material.dart';

class Utils {
  static String getAnimationFileName(String condition) {
    switch (condition) {
      case 'Sunny':
      case 'Clear':
        return 'assets/lottie/sunny.json';
      case 'Partly cloudy':
      case 'Cloudy':
      case 'Overcast':
      case 'Mist':
      case 'Fog':
      case 'Freezing fog':
        return 'assets/lottie/cloudy.json';
      case 'Patchy rain nearby':
      case 'Light drizzle':
      case 'Patchy light drizzle':
      case 'Patchy light rain':
      case 'Light rain':
      case 'Moderate rain at times':
      case 'Moderate rain':
      case 'Heavy rain at times':
      case 'Heavy rain':
      case 'Patchy freezing drizzle nearby':
      case 'Freezing drizzle':
      case 'Heavy freezing drizzle':
      case 'Light freezing rain':
      case 'Moderate or heavy freezing rain':
      case 'Patchy sleet nearby':
      case 'Light sleet':
      case 'Moderate or heavy sleet':
      case 'Blowing snow':
      case 'Blizzard':
      case 'Patchy snow nearby':
      case 'Patchy light snow':
      case 'Light snow':
      case 'Patchy moderate snow':
      case 'Moderate snow':
      case 'Patchy heavy snow':
      case 'Heavy snow':
      case 'Ice pellets':
      case 'Light showers of ice pellets':
      case 'Moderate or heavy showers of ice pellets':
      case 'Light rain shower':
      case 'Moderate or heavy rain shower':
      case 'Torrential rain shower':
      case 'Light sleet showers':
      case 'Moderate or heavy sleet showers':
      case 'Light snow showers':
      case 'Moderate or heavy snow showers':
        return 'assets/lottie/rain_with_sun.json'; // assuming rain_with_sun.json can be used for various precipitation conditions
      case 'Thundery outbreaks in nearby':
      case 'Patchy light rain with thunder':
      case 'Moderate or heavy rain with thunder':
      case 'Patchy light snow with thunder':
      case 'Moderate or heavy snow with thunder':
        return 'assets/lottie/thunderstorm.json';
      default:
        return 'assets/lottie/cloudy.json'; // default to cloudy if no matching condition is found
    }
  }

  static String parseDateTime(String dateTime) {
    final dateTimeParsed = DateTime.parse(dateTime);
    final hour = dateTimeParsed.hour;
    final minute = dateTimeParsed.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : hour;
    return '$hour12:$minute $amPm';
  }

  static String formatTo12HourTime(String datetime) {
    List<String> parts = datetime.split(' ');
    String timePart = parts[1];

    List<String> timeParts = timePart.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    String period = hour >= 12 ? 'PM' : 'AM';

    if (hour > 12) {
      hour = hour - 12;
    } else if (hour == 0) {
      hour = 12;
    }

    String formattedHour = hour.toString().padLeft(2, '0');
    String formattedMinute = minute.toString().padLeft(2, '0');

    String formattedTime = '$formattedHour:$formattedMinute $period';
    return formattedTime;
  }

    /// Formats the icon URL from the weather API to ensure it's a valid path.
  static String formatIconUrl(String iconPath) {
    return 'https:$iconPath'; // Assuming the API returns a relative path
  }

  /// Converts a time string (e.g., `2024-12-09 14:00`) to a 12-hour format with AM/PM.
  static String toHourlyForcastTime(String time) {
    final parsedTime = DateTime.parse(time);
    final formattedTime = TimeOfDay.fromDateTime(parsedTime);
    final hour = formattedTime.hourOfPeriod == 0 ? 12 : formattedTime.hourOfPeriod;
    final period = formattedTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:00 $period';
  }

}
