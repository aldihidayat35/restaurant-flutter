import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Soft & modern color palette
  static const Color _primaryLight = Color(0xFF6C63FF);
  static const Color _primaryDark = Color(0xFF8B83FF);
  static const Color _secondaryLight = Color(0xFFFF6584);
  static const Color _secondaryDark = Color(0xFFFF8FA3);
  static const Color _surfaceLight = Color(0xFFF8F9FE);
  static const Color _surfaceDark = Color(0xFF1A1A2E);
  static const Color _cardLight = Color(0xFFFFFFFF);
  static const Color _cardDark = Color(0xFF16213E);
  static const Color _backgroundDark = Color(0xFF0F0F23);
  static const Color _textLight = Color(0xFF2D3142);
  static const Color _textDark = Color(0xFFE8E8F0);
  static const Color _subtextLight = Color(0xFF9A9BB2);
  static const Color _subtextDark = Color(0xFF7F7F9A);
  static const Color _starColor = Color(0xFFFFB74D);

  static Color get starColor => _starColor;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _primaryLight,
        secondary: _secondaryLight,
        surface: _surfaceLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _textLight,
      ),
      scaffoldBackgroundColor: _surfaceLight,
      cardColor: _cardLight,
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _textLight,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _textLight,
          ),
          headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textLight,
          ),
          titleLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textLight,
          ),
          titleMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _textLight,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: _textLight),
          bodyMedium: TextStyle(fontSize: 14, color: _subtextLight),
          bodySmall: TextStyle(fontSize: 12, color: _subtextLight),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: _textLight,
        ),
        iconTheme: const IconThemeData(color: _textLight),
      ),
      cardTheme: CardThemeData(
        color: _cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      iconTheme: const IconThemeData(color: _primaryLight),
      chipTheme: ChipThemeData(
        backgroundColor: _primaryLight.withValues(alpha: 0.1),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _primaryLight,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: _primaryDark,
        secondary: _secondaryDark,
        surface: _surfaceDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _textDark,
      ),
      scaffoldBackgroundColor: _backgroundDark,
      cardColor: _cardDark,
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
          headlineSmall: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
          titleLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
          titleMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _textDark,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: _textDark),
          bodyMedium: TextStyle(fontSize: 14, color: _subtextDark),
          bodySmall: TextStyle(fontSize: 12, color: _subtextDark),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: _textDark,
        ),
        iconTheme: const IconThemeData(color: _textDark),
      ),
      cardTheme: CardThemeData(
        color: _cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      iconTheme: const IconThemeData(color: _primaryDark),
      chipTheme: ChipThemeData(
        backgroundColor: _primaryDark.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _primaryDark,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }
}
