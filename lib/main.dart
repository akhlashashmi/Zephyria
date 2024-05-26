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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent).copyWith(),
        useMaterial3: true,
        textTheme: GoogleFonts.asapTextTheme(), 
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor:Theme.of(context).colorScheme.surface,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        textTheme: GoogleFonts.asapTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
