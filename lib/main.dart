import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather/features/weather/presentation/controllers/theme_controller.dart';
import 'package:weather/features/weather/presentation/screens/home.dart';
import 'package:weather/features/weather/utils/hive_box_names.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive and open the box
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox(HiveBoxes.preferences.name);
  await Hive.openBox(HiveBoxes.settings.name);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider(HiveBoxes.preferences.name));

    // Create color schemes for light and dark themes
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.orangeAccent,
      brightness: Brightness.light,
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: Colors.orangeAccent,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        textTheme: GoogleFonts.asapTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.surface,
          foregroundColor: lightColorScheme.onSurface,
        ),
        scaffoldBackgroundColor: lightColorScheme.background,
        // navigationBarTheme: NavigationBarThemeData(
        //   backgroundColor: lightColorScheme.surface,
        //   indicatorColor: lightColorScheme.primary,
        // ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
        textTheme: GoogleFonts.asapTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.background,
          foregroundColor: darkColorScheme.onBackground,
        ),
        scaffoldBackgroundColor: darkColorScheme.background,
        // navigationBarTheme: NavigationBarThemeData(
        //   backgroundColor: darkColorScheme.surface,
        //   indicatorColor: darkColorScheme.primary,
        // ),
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
