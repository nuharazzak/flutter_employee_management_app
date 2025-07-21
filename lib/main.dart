import 'package:flutter/material.dart';

import 'package:flutter_employee_management_app/screens/home.dart';

import 'package:google_fonts/google_fonts.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 10, 134, 236),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 32, 3, 147),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
          backgroundColor: kColorScheme.primaryContainer,
          selectedItemColor: kColorScheme.onPrimaryContainer,
          unselectedItemColor: kColorScheme.onPrimaryContainer.withValues(
            alpha: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primary,
            foregroundColor: kColorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kColorScheme.primary,
          foregroundColor: kColorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Colors.white, width: 3),
          ),
        ),
        iconTheme: const IconThemeData().copyWith(
          color: kColorScheme.onPrimaryContainer,
        ),
        textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme)
            .copyWith(
              titleLarge: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kColorScheme.primaryContainer,
                  fontSize: 30,
                ),
              ),
              bodyMedium: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kColorScheme.primary,
                  fontSize: 25,
                ),
              ),
              bodySmall: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
      ),

      themeMode: ThemeMode.light,
      home: const Home(),
    ),
  );
}
