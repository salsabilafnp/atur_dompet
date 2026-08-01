import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // COLOR PALETTE
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color linkBlue = Color(0xFF0000FF);

  static const Color surfaceBase = Color(0xFFFFFFFF);
  static const Color surfaceInverted = Color(0xFF000000);
  static const Color surfaceSunken = Color(0xFFF0F0F0);

  static const Color success = Color(0xFF008000);
  static const Color warning = Color(0xFFFFA500);
  static const Color error = Color(0xFFFF0000);
  static const Color info = Color(0xFF0000FF);

  static const Color borderDisabled = Color(0xFFCCCCCC);
  static const Color bgDisabled = Color(0xFFF5F5F5);
  static const Color hoverGrey = Color(0xFFE8E8E8);

  // TYPOGRAPHY (Archivo Black, Work Sans, Space Mono)
  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      // Headlines - Archivo Black
      displayLarge: GoogleFonts.archivoBlack(
        fontSize: 48,
        height: 1.0,
        color: textColor,
      ),
      displayMedium: GoogleFonts.archivoBlack(
        fontSize: 32,
        height: 1.05,
        color: textColor,
      ),
      displaySmall: GoogleFonts.archivoBlack(
        fontSize: 28,
        height: 1.1,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.workSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.workSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: textColor,
      ),
      // Body - Work Sans
      bodyLarge: GoogleFonts.workSans(
        fontSize: 16,
        height: 1.6,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.workSans(
        fontSize: 14,
        height: 1.5,
        color: textColor,
      ),
      bodySmall: GoogleFonts.workSans(
        fontSize: 12,
        height: 1.4,
        color: textColor,
      ),
      // Labels / Buttons
      labelLarge: GoogleFonts.archivoBlack(
        fontSize: 14,
        letterSpacing: 2.0,
        color: textColor,
      ),
    );
  }

  // Helper untuk Font Mono (Space Mono)
  static TextStyle monoTextStyle({
    double fontSize = 15,
    Color color = black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.spaceMono(
      fontSize: fontSize,
      height: 1.5,
      color: color,
      fontWeight: fontWeight,
    );
  }

  // LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: black,
    scaffoldBackgroundColor: surfaceBase,

    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: black,
      onPrimary: white,
      secondary: black,
      onSecondary: white,
      surface: surfaceBase,
      onSurface: black,
      error: error,
      onError: white,
    ),

    // Typography
    textTheme: _buildTextTheme(black),

    // Card Theme (Default: 3px border, 0 radius, 0 elevation)
    cardTheme: const CardThemeData(
      color: white,
      elevation: 0,
      margin: EdgeInsets.all(16), // sp-3
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // NO ROUNDED CORNERS
        side: BorderSide(color: black, width: 3),
      ),
    ),

    // Input Decoration (TextFormField / TextField)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceSunken,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      hintStyle: monoTextStyle(color: black.withOpacity(0.5)),
      labelStyle: GoogleFonts.archivoBlack(fontSize: 14, color: black),
      helperStyle: GoogleFonts.workSans(fontSize: 12, color: black),
      errorStyle: GoogleFonts.workSans(fontSize: 12, color: error),
      // Borders
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: black, width: 3),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: black, width: 3),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: black, width: 5), // Focus 5px
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: error, width: 3),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: borderDisabled, width: 3),
      ),
    ),

    // Button - Primary (FilledButton / ElevatedButton)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return surfaceSunken;
          if (states.contains(WidgetState.pressed)) return black;
          if (states.contains(WidgetState.hovered)) return white;
          return black;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return borderDisabled;
          if (states.contains(WidgetState.hovered)) return black;
          return white;
        }),
        shape: WidgetStateProperty.resolveWith((states) {
          final borderWidth = states.contains(WidgetState.pressed) ? 5.0 : 3.0;
          final borderColor = states.contains(WidgetState.disabled)
              ? borderDisabled
              : black;
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: borderColor, width: borderWidth),
          );
        }),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.archivoBlack(fontSize: 14, letterSpacing: 2.0),
        ),
      ),
    ),

    // Button - Secondary (OutlinedButton)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed)) {
            return black;
          }
          return white;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed)) {
            return white;
          }
          return black;
        }),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: black, width: 3),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.archivoBlack(fontSize: 14, letterSpacing: 2.0),
        ),
      ),
    ),

    // Button - Ghost (TextButton)
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) return linkBlue;
          return black;
        }),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.workSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: white,
      disabledColor: bgDisabled,
      selectedColor: black,
      secondarySelectedColor: black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      labelStyle: GoogleFonts.archivoBlack(
        fontSize: 10,
        letterSpacing: 1.0,
        color: black,
      ),
      secondaryLabelStyle: GoogleFonts.archivoBlack(
        fontSize: 10,
        letterSpacing: 1.0,
        color: white,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: black, width: 2),
      ),
      elevation: 0,
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return bgDisabled;
        if (states.contains(WidgetState.selected)) return black;
        return white;
      }),
      checkColor: WidgetStateProperty.all(white),
      side: const BorderSide(color: black, width: 3),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    // Radio Theme (Satu-satunya pengecualian yang berbentuk lingkaran)
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return borderDisabled;
        return black;
      }),
    ),

    // Tooltip Theme
    tooltipTheme: TooltipThemeData(
      decoration: const BoxDecoration(
        color: black,
        borderRadius: BorderRadius.zero,
      ),
      textStyle: monoTextStyle(fontSize: 13, color: white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(color: black, thickness: 3, space: 24),
  );

  // DARK THEME (Brutalist Inverted)
  static final ThemeData darkTheme = lightTheme.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: surfaceInverted,
    colorScheme: const ColorScheme.dark(
      primary: white,
      onPrimary: black,
      secondary: white,
      onSecondary: black,
      surface: surfaceInverted,
      onSurface: white,
      error: error,
      onError: white,
    ),
    textTheme: _buildTextTheme(white),
    cardTheme: lightTheme.cardTheme.copyWith(
      color: surfaceInverted,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: white, width: 3),
      ),
    ),
    dividerTheme: const DividerThemeData(color: white, thickness: 3, space: 24),
  );
}
