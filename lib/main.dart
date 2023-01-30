import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/libraries/libraries.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.purple,
      accentColor: Colors.blue,
      primaryColorDark: Colors.purple,
    );

    return MaterialApp(
      title: "syncmov",
      theme: ThemeData(
        colorScheme: colorScheme,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: colorScheme.copyWith(brightness: Brightness.dark),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.white10),
          ),
        ),
      ),
      home: const LibrariesPage(),
    );
  }
}
