import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF9C27B0);
  static const Color secondaryColor = Color(0xFFFF5252);
  static const Color backgroundColor = Color(0xFFF8FAFC); 
  static const Color surfaceColor = Colors.white;
  static const Color textPrimary = Color(0xFF1E1E1E); 
  static const Color textSecondary = Color(0xFF757575); 
  
  static const Color priorityHigh = Color(0xFFFF5252);
  static const Color priorityMedium = Color(0xFFFF9800);
  static const Color priorityLow = Color(0xFF4CAF50);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.poppins(color: textPrimary),
        bodyMedium: GoogleFonts.poppins(color: textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
