import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.icon, this.text});
  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? EvaIcons.wifi_off,
            size: 100,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(height: 10),
          Text(
            text ?? 'No internet!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
