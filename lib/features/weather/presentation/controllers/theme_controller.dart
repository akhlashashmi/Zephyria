import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:weather/features/weather/presentation/controllers/current_location_controller.dart';
import 'package:weather/features/weather/utils/hive_box_names.dart';
import 'dart:developer' as developer;

final themeProvider = StateNotifierProvider.family<ThemeController, bool, String>((ref, boxName) {
  return ThemeController(ref.read(hiveBoxProvider(boxName)));
});

class ThemeController extends StateNotifier<bool> {
  final Box box;
  final String key = HiveKeyNames.isDarkTheme.name;

  ThemeController(this.box) : super(false) {
    _fetchValue();
  }

  Future<void> _fetchValue() async {
    try {
      developer.log('Fetching isDarkTheme value from Hive box');
      final value = box.get(key, defaultValue: false);
      developer.log('Fetched isDarkTheme value: $value');
      state = value;
    } catch (e) {
      developer.log('Error fetching isDarkTheme value from Hive box: $e', level: 1000);
    }
  }

  Future<void> toggleTheme() async {
    try {
      final newValue = !state;
      developer.log('Toggling theme in Hive box, new value: $newValue');
      await box.put(key, newValue);
      state = newValue;
      developer.log('Theme toggled, new isDarkTheme value: $newValue');
    } catch (e) {
      developer.log('Error toggling theme in Hive box: $e', level: 1000);
    }
  }
}