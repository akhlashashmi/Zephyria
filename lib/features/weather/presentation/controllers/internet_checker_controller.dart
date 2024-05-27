import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final internetProvider = Provider<InternetConnectionChecker>((ref) {
  return InternetConnectionChecker();
});

final isConnectedProvider = FutureProvider<bool>((ref) async {
  final internet = ref.watch(internetProvider);
  return await internet.hasConnection;
});