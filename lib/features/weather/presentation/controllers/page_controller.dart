// StateNotifier to manage the selected index
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedIndexNotifier extends StateNotifier<int> {
  SelectedIndexNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}

final selectedIndexProvider =
    StateNotifierProvider<SelectedIndexNotifier, int>((ref) {
  return SelectedIndexNotifier();
});