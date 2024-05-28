import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/features/weather/data/models/location.dart';
import 'package:weather/features/weather/presentation/controllers/theme_controller.dart';
import 'package:weather/features/weather/utils/hive_box_names.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  final TextEditingController controller = TextEditingController();
  late AsyncValue<List<SearchedLocation>> weatherAsyncValue;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider(HiveBoxes.preferences.name));
    final changeIsDark =
        ref.watch(themeProvider(HiveBoxes.preferences.name).notifier);
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.fromLTRB(size.width * 0.05, 0, size.width * 0.05, 0),
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: size.height * 0.07),
          SwitchListTile.adaptive(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            value: isDark,
            onChanged: (value) => changeIsDark.toggleTheme(),
            title: const Text('Change Theme'),
            subtitle: Text(
              'Turn it on to enable dark theme',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.8),
                  ),
            ),
          )
        ]),
      ),
    );
  }
}
