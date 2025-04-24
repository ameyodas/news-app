import 'package:flutter/material.dart';

class INTheme {
  static ThemeData light() {
    return ThemeData.light().copyWith(
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.black, unselectedItemColor: Colors.black45),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 64, 64, 64),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              visualDensity: VisualDensity.compact)),
      iconTheme: const IconThemeData(size: 20.0, color: Colors.black),
      iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
              foregroundColor: Colors.black.withAlpha(200),
              backgroundColor: Colors.transparent,
              elevation: 0,
              //padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              visualDensity: VisualDensity.compact)),
      appBarTheme: const AppBarTheme(color: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.black.withAlpha(16),
        hintStyle: TextStyle(
          fontFamily: 'Raleway',
          color: Colors.black.withAlpha(128),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withAlpha(24), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withAlpha(24), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withAlpha(24), width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.black,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white, unselectedItemColor: Colors.white54),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 32, 32, 32),
            backgroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            visualDensity: VisualDensity.compact),
      ),
      iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
              foregroundColor: Colors.white.withAlpha(200),
              backgroundColor: Colors.transparent,
              elevation: 0,
              //padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              visualDensity: VisualDensity.compact)),
      iconTheme: const IconThemeData(size: 20.0, color: Colors.white),
      appBarTheme: const AppBarTheme(color: Colors.black),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withAlpha(16),
        hintStyle: TextStyle(
          fontFamily: 'Raleway',
          color: Colors.white.withAlpha(128),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withAlpha(24), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withAlpha(24), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withAlpha(24), width: 1),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  static ThemeMode mode = ThemeMode.dark;
  static ThemeMode toggleMode() {
    mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    return mode;
  }
}
