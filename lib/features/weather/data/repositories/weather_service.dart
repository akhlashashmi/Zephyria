import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:weather/constants/constants.dart';
import 'package:weather/features/weather/data/models/location.dart';
import 'package:weather/features/weather/data/models/weather_data.dart';
import 'package:weather/features/weather/data/models/weather_forcast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherProvider = Provider<WeatherService>((ref) {
  return WeatherService(
    apiKey: AppConstants.apiKey,
    baseUrl: AppConstants.baseUrl,
  );
});

class WeatherService {
  final String apiKey;
  final String baseUrl;

  WeatherService({
    required this.baseUrl,
    required this.apiKey,
  });

  Future<WeatherData> fetchWeather(String location) async {
    developer.log(baseUrl);
    try {
      developer.log('Fetching weather for location: $location', name: 'WeatherService');
      final response = await http.get(Uri.parse('$baseUrl/current.json?key=$apiKey&q=$location'));

      if (response.statusCode == 200) {
        developer.log('Weather data fetched successfully', name: 'WeatherService');
        return WeatherData.fromJson(jsonDecode(response.body));
      } else {
        developer.log('Failed to load weather data: ${response.statusCode}', name: 'WeatherService', error: response.body);
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      developer.log('Exception occurred while fetching weather: $e', name: 'WeatherService', error: e);
      rethrow;
    }
  }

  Future<WeatherData> fetchWeatherByCoordinates(double lat, double lon) async {
    try {
      developer.log('Fetching weather for coordinates: lat=$lat, lon=$lon', name: 'WeatherService');
      final response = await http.get(Uri.parse('$baseUrl/current.json?key=$apiKey&q=$lat,$lon'));

      if (response.statusCode == 200) {
        developer.log('Weather data fetched successfully by coordinates', name: 'WeatherService');
        return WeatherData.fromJson(jsonDecode(response.body));
      } else {
        developer.log('Failed to load weather data by coordinates: ${response.statusCode}', name: 'WeatherService', error: response.body);
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      developer.log('Exception occurred while fetching weather by coordinates: $e', name: 'WeatherService', error: e);
      throw e;
    }
  }

  Future<List<SearchedLocation>> searchLocations(String query) async {
    try {
      developer.log('Searching locations for query: $query', name: 'WeatherService');
      final response = await http.get(Uri.parse('$baseUrl/search.json?key=$apiKey&q=$query'));

      if (response.statusCode == 200) {
        developer.log('Location search successful', name: 'WeatherService');
        final jsonData = jsonDecode(response.body) as List;
        return jsonData.map((jsonLocation) => SearchedLocation.fromJson(jsonLocation)).toList();
      } else {
        developer.log('Failed to load locations: ${response.statusCode}', name: 'WeatherService', error: response.body);
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      developer.log('Exception occurred while searching locations: $e', name: 'WeatherService', error: e);
      throw e;
    }
  }

  Future<WeatherForcast> fetchFiveDayForecast({double? lat, double? lon, String? city = 'islamabad'}) async {
    try {
      late final http.Response response;
      if (lat == null || lon == null) {
        developer.log('Fetching 5-day forecast for city: $city', name: 'WeatherService');
        response = await http.get(Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=5&aqi=no&alerts=no'));
      } else {
        developer.log('Fetching 5-day forecast for coordinates: lat=$lat, lon=$lon', name: 'WeatherService');
        response = await http.get(Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$lat,$lon&days=5'));
      }

      if (response.statusCode == 200) {
        developer.log('5-day forecast data fetched successfully', name: 'WeatherService');
        return WeatherForcast.fromJson(jsonDecode(response.body));
      } else {
        developer.log('Failed to load 5-day forecast data: ${response.statusCode}', name: 'WeatherService', error: response.body);
        throw Exception('Failed to load weather forecast');
      }
    } catch (e) {
      developer.log('Exception occurred while fetching 5-day forecast: $e', name: 'WeatherService', error: e);
      throw e;
    }
  }
}
