import 'package:flutter/material.dart';
import 'home_page.dart';
import 'src/theme_controller.dart';
import 'src/favorites_controller.dart';
// Supabase removed for lightweight local debugging on constrained devices.
import 'login_page.dart';
import 'signup_page.dart';
import 'user_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Supabase removed; using local username-only auth for lightweight debugging.
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController _controller = ThemeController();
  final FavoritesController _favorites = FavoritesController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    _favorites.addListener(() => setState(() {}));
    _controller.load();
    _favorites.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    _favorites.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Custom color choices
    const primary = Color(0xFF0A6CF4); // bright blue
    const secondary = Color(0xFF00C853); // green accent
    const scaffoldBg = Color(0xFFF6F8FB); // very light background

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      surface: scaffoldBg,
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Booking',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: scaffoldBg,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: primary,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // Card theming removed to avoid SDK type mismatches between
        // CardTheme (widget) and the SDK's CardThemeData expected here.
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.grey[900],
          displayColor: Colors.grey[900],
        ),
      ),
      // Dark theme variant (follows system by default)
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: secondary,
          surface: const Color(0xFF0F1720),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B1220),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          backgroundColor: Color.fromARGB(255, 170, 188, 214),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00C853),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white70,
          displayColor: Colors.white70,
        ),
      ),
      // Apply persisted/theme controller mode
      themeMode: _controller.mode,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/profile': (_) => const UserProfilePage(),
        '/home': (_) => HomePage.withControllers(_controller, _favorites),
      },
    );
  }
}
