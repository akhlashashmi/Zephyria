import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:weather/features/weather/utils/hive_constants.dart';
import 'dart:developer' as developer;


final currentLocationProvider = StateNotifierProvider.family<HiveValueController, String, String>((ref, boxName) {
  return HiveValueController(ref.read(hiveBoxProvider(boxName)), HiveKeys.currentLocation, 'islamabad');
});

class HiveValueController extends StateNotifier<String> {
  final Box box;
  final String key;

  HiveValueController(this.box, this.key, String defaultValue) : super(defaultValue) {
    _fetchValue();
  }

  Future<void> _fetchValue() async {
    try {
      developer.log('Fetching value from Hive box with key: $key');
      final value = box.get(key, defaultValue: state);
      developer.log('Fetched value: $value');
      state = value;
    } catch (e) {
      developer.log('Error fetching value from Hive box: $e', level: 1000);
    }
  }

  Future<void> setValue(String newValue) async {
    try {
      developer.log('Setting new value in Hive box with key: $key, value: $newValue');
      await box.put(key, newValue);
      state = newValue;
      developer.log('New value set: $newValue');
    } catch (e) {
      developer.log('Error setting value in Hive box: $e', level: 1000);
    }
  }
}

final hiveBoxProvider = Provider.family<Box, String>((ref, boxName) {
  try {
    final box = Hive.box(boxName);
    ref.onDispose(() {
      developer.log('Disposing Hive box: $boxName');
      box.close();
    });
    return box;
  } catch (e) {
    developer.log('Error opening Hive box: $e', level: 1000);
    rethrow;
  }
});