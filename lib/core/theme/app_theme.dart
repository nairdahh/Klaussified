import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klaussified/business_logic/theme/theme_state.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/core/theme/text_styles.dart';

class AppTheme {
  // Helper to get theme based on variant and brightness
  static ThemeData getTheme({
    required ThemeVariant variant,
    required bool isDark,
  }) {
    if (isDark) {
      return variant == ThemeVariant.classic
          ? darkThemeClassic
          : darkThemeCatppuccin;
    } else {
      return variant == ThemeVariant.classic
          ? lightThemeClassic
          : lightThemeCatppuccin;
    }
  }

  // Legacy getters for backward compatibility
  static ThemeData get lightTheme => lightThemeClassic;

  static ThemeData get darkTheme => darkThemeClassic;

  // Classic Theme - Light
  static ThemeData get lightThemeClassic {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.christmasRed,
        secondary: AppColors.christmasGreen,
        surface: AppColors.backgroundWhite,
        error: AppColors.error,
        onPrimary: AppColors.textOnRed,
        onSecondary: AppColors.textOnGreen,
        onSurface: AppColors.textPrimary,
        onError: AppColors.snowWhite,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.christmasRed,
        foregroundColor: AppColors.snowWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.snowWhite,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: AppColors.shadowLight,
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.christmasRed,
          foregroundColor: AppColors.snowWhite,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.christmasRed,
          side: const BorderSide(color: AppColors.christmasRed, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.christmasRed,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.christmasRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.christmasRed,
        foregroundColor: AppColors.snowWhite,
        elevation: 4,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.paleGreen,
        selectedColor: AppColors.christmasGreen,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 16,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundWhite,
        selectedItemColor: AppColors.christmasRed,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Tab Bar Theme
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.christmasRed,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.christmasRed,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.snowWhite,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Font Family - Using Google Fonts for Poppins
      textTheme: GoogleFonts.poppinsTextTheme(AppTextStyles.textTheme),
    );
  }

  // Classic Theme - Dark
  static ThemeData get darkThemeClassic {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.christmasRed,
        secondary: AppColors.christmasGreen,
        surface: Color(0xFF2d2d2d), // Dark gray for cards
        error: AppColors.error,
        onPrimary: AppColors.textOnRed,
        onSecondary: AppColors.textOnGreen,
        onSurface: AppColors.snowWhite,
        onError: AppColors.snowWhite,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: const Color(0xFF1a1a1a), // Very dark gray

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.christmasRed,
        foregroundColor: AppColors.snowWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.snowWhite,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: const Color(0xFF2d2d2d), // Dark gray
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.christmasRed,
          foregroundColor: AppColors.snowWhite,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.christmasRed,
          side: const BorderSide(color: AppColors.christmasRed, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.christmasRed,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2d2d2d),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.christmasRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Colors.grey.shade500,
        ),
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Colors.grey.shade300,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.christmasRed,
        foregroundColor: AppColors.snowWhite,
        elevation: 4,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2d2d2d),
        selectedColor: AppColors.christmasGreen,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.snowWhite,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade800,
        thickness: 1,
        space: 16,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF2d2d2d),
        selectedItemColor: AppColors.christmasRed,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Tab Bar Theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.christmasRed,
        unselectedLabelColor: Colors.grey.shade400,
        indicatorColor: AppColors.christmasRed,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: Color(0xFF1a1a1a),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF2d2d2d),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.snowWhite,
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Colors.grey.shade300,
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2d2d2d),
        contentTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.snowWhite,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Font Family - Using Google Fonts for Poppins
      textTheme: GoogleFonts.poppinsTextTheme(
        AppTextStyles.textTheme.apply(
          bodyColor: AppColors.snowWhite,
          displayColor: AppColors.snowWhite,
        ),
      ),

      // Text field text color
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.christmasRed,
        selectionColor: AppColors.christmasRed,
        selectionHandleColor: AppColors.christmasRed,
      ),
    );
  }

  // Catppuccin Theme - Light (Latte)
  static ThemeData get lightThemeCatppuccin {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: CatppuccinColors.latteMauve,
        secondary: CatppuccinColors.latteGreen,
        surface: CatppuccinColors.latteBase,
        error: CatppuccinColors.latteRed,
        onPrimary: CatppuccinColors.latteBase,
        onSecondary: CatppuccinColors.latteBase,
        onSurface: CatppuccinColors.latteText,
        onError: CatppuccinColors.latteBase,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: CatppuccinColors.latteMantle,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: CatppuccinColors.latteMauve,
        foregroundColor: CatppuccinColors.latteBase,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: CatppuccinColors.latteBase,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: CatppuccinColors.latteBase,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: CatppuccinColors.latteSurface2.withValues(alpha: 0.3),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CatppuccinColors.latteMauve,
          foregroundColor: CatppuccinColors.latteBase,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CatppuccinColors.latteBase,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: CatppuccinColors.latteSurface1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: CatppuccinColors.latteMauve, width: 2),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CatppuccinColors.latteMauve,
        foregroundColor: CatppuccinColors.latteBase,
        elevation: 4,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: CatppuccinColors.surface0,
        contentTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: CatppuccinColors.text,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Font Family
      textTheme: GoogleFonts.poppinsTextTheme(AppTextStyles.textTheme),
    );
  }

  // Catppuccin Theme - Dark (Mocha)
  static ThemeData get darkThemeCatppuccin {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: CatppuccinColors.mauve,
        secondary: CatppuccinColors.green,
        surface: CatppuccinColors.surface0,
        error: CatppuccinColors.red,
        onPrimary: CatppuccinColors.base,
        onSecondary: CatppuccinColors.base,
        onSurface: CatppuccinColors.text,
        onError: CatppuccinColors.base,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: CatppuccinColors.base,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: CatppuccinColors.mauve,
        foregroundColor: CatppuccinColors.base,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: CatppuccinColors.base,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: CatppuccinColors.surface0,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CatppuccinColors.mauve,
          foregroundColor: CatppuccinColors.base,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CatppuccinColors.surface0,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: CatppuccinColors.surface2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: CatppuccinColors.mauve, width: 2),
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CatppuccinColors.mauve,
        foregroundColor: CatppuccinColors.base,
        elevation: 4,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: CatppuccinColors.surface1,
        contentTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: CatppuccinColors.text,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Font Family
      textTheme: GoogleFonts.poppinsTextTheme(
        AppTextStyles.textTheme.apply(
          bodyColor: CatppuccinColors.text,
          displayColor: CatppuccinColors.text,
        ),
      ),

      // Text Selection Theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: CatppuccinColors.mauve,
        selectionColor: CatppuccinColors.mauve,
        selectionHandleColor: CatppuccinColors.mauve,
      ),
    );
  }
}
