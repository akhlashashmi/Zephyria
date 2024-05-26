import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final void Function() onPressed;
  final bool showButton;

  const SearchField({super.key, required this.controller, required this.hint, required this.onChanged, required this.onSubmitted, required this.onPressed, this.showButton = true});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        suffixIcon: showButton ? IconButton(
          icon: const Icon(Icons.send),
          onPressed: onPressed,
        ) : null,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}