import 'package:flutter/material.dart';

class TColors {
  TColors._(); // Private constructor to prevent instantiation

  static const Color primary = Color(0xFF4b68ff);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C7570);
  static  Color textWhite = Colors.white;

  // Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static  Color darkContainer = Colors.white.withOpacity(0.5);

  // Button Colors
  static const Color buttonPrimary = Color (0xFF4b68ff);
  static const Color buttonSecondary = Color (0xFF6C757D);

  static const Color buttonDisabled = Color (0xFFC4C4C4);

// Border Colors
  static const Color borderPrimary = Color (0xFFD9D9D9);
  static const Color borderSecondary = Color (0xFFE6E6E6);

// Error and Validation Colors
  static const Color error = Color (0xFFD32F2F);
  static const Color success = Color (0xFF388E3C);
  static const Color warning = Color (0xFFF57C00);
  static const Color info = Color (0xFF1976D2);

  // Neutral Shades
  static const Color black = Color (0xFF000000);
  static const Color darkerGrey = Color (0xFF333333);
  static const Color darkGrey = Color (0xFF4F4F4F); // Renamed from original 'darkerGrey'
  static const Color grey = Color (0xFF939393); // Renamed from original 'grey'
  static const Color softGrey = Color (0xFFF4F4F4);
  static const Color lightGrey = Color (0xFFF9F9F9);
  static const Color white = Color (0xFFFFFFFF);


}
