import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchKeywordProvider = Provider<TextEditingController>((ref) {
  return TextEditingController();
});
