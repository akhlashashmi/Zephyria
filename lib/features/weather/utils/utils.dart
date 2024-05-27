class Utils {
  static String getAnimationFileName(String condition) {
    switch (condition) {
      case 'Sunny':
      case 'Clear':
        return 'assets/lottie/sunny.json';
      case 'Partly Cloudy':
      case 'Cloudy':
      case 'Mist':
      case 'Overcast':
        return 'assets/lottie/cloudy.json';
      case 'Patchy rain possible':
      case 'Patchy snow possible':
      case 'Patchy sleet possible':
      case 'Patchy freezing drizzle possible':
      case 'Light rain':
      case 'Moderate rain':
      case 'Heavy rain':
      case 'Light snow':
      case 'Moderate snow':
      case 'Heavy snow':
      case 'Light sleet':
      case 'Moderate sleet':
      case 'Heavy sleet':
        return 'assets/lottie/rain_with_sun.json'; // assuming rain_with_sun.json can be used for various rain conditions
      case 'Thundery outbreaks possible':
      case 'Thunder shower':
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
}
