import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/note_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NoteProvider()..loadNotes(),
        ),

        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider =
    context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Simple Note App',

      // =========================
      // THEME
      // =========================

      themeMode: themeProvider.themeMode,

      // LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,

        brightness: Brightness.light,

        primaryColor: const Color(0xFF3566CC),

        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3566CC),
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),

        floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3566CC),
          foregroundColor: Colors.white,
        ),

        inputDecorationTheme:
        InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade200,

          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF3566CC),
              width: 1.5,
            ),
          ),
        ),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        useMaterial3: true,

        brightness: Brightness.dark,

        primaryColor: const Color(0xFF3566CC),

        scaffoldBackgroundColor:
        const Color(0xFF101727),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3566CC),
          brightness: Brightness.dark,
        ),

        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF101727),
          foregroundColor: Colors.white,
        ),

        floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3566CC),
          foregroundColor: Colors.white,
        ),

        inputDecorationTheme:
        InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1B2435),

          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF3566CC),
              width: 1.5,
            ),
          ),
        ),
      ),

      // =========================
      // HOME
      // =========================

      home: const HomePage(),
    );
  }
}