import 'package:flutter/material.dart';

class AppTheme {
  static const Color verdeScuro = Color(0xFF2F5D31);
  static const Color verde = Color(0xFF4C7A3F);
  static const Color verdeChiaro = Color(0xFF8FB573);
  static const Color crema = Color(0xFFF7F3E8);
  static const Color carta = Color(0xFFFDFBF5);
  static const Color sabbia = Color(0xFFE4DECB);
  static const Color ambra = Color(0xFFD9A441);
  static const Color terra = Color(0xFF96603C);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: verde,
      primary: verdeScuro,
      secondary: verdeChiaro,
      tertiary: ambra,
      surface: carta,
    ),
    scaffoldBackgroundColor: crema,
    fontFamily: 'serif',
    cardTheme: CardThemeData(
      color: carta,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: sabbia),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: verdeScuro,
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: carta,
      indicatorColor: verdeChiaro.withValues(alpha: 0.3),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: carta,
      side: const BorderSide(color: sabbia),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: const TextStyle(color: verdeScuro),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: verdeScuro,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(color: verdeScuro, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(color: verdeScuro, fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(color: Color(0xFF4A4A3F)),
    ),
  );

  static TextStyle titoloSezione = const TextStyle(
    color: verdeScuro, fontSize: 20, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic,
  );
}
