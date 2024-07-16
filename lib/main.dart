import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather/features/weather/presentation/controllers/theme_controller.dart';
import 'package:weather/features/weather/presentation/screens/home.dart';
import 'package:weather/features/weather/utils/color_schemes.dart';
import 'package:weather/features/weather/utils/hive_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive and open the box
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox(HiveBoxes.preferences);
  await Hive.openBox(HiveBoxes.settings);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider(HiveBoxes.preferences));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        colorScheme: ColorSchemes.light,
        useMaterial3: true,
        textTheme: GoogleFonts.asapTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorSchemes.light.surface,
          foregroundColor: ColorSchemes.light.onSurface,
        ),
        scaffoldBackgroundColor: ColorSchemes.light.surface,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorSchemes.dark,
        useMaterial3: true,
        textTheme: GoogleFonts.asapTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: ColorSchemes.dark.surface,
          foregroundColor: ColorSchemes.dark.onSurface,
        ),
        scaffoldBackgroundColor: ColorSchemes.dark.surface,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
