import 'package:flutter/material.dart';

/// Utility class for showing snackbars with responsive width constraints
class SnackBarHelper {
  /// Maximum width for snackbars on desktop screens
  static const double maxSnackbarWidth = 600;

  /// Show a snackbar with responsive width for desktop screens
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxSnackbarWidth),
          child: Text(message),
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      action: action,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Show a success snackbar
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      context,
      message: message,
      backgroundColor: const Color(0xFF4CAF50), // Green
      duration: duration,
    );
  }

  /// Show an error snackbar
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      context,
      message: message,
      backgroundColor: const Color(0xFFF44336), // Red
      duration: duration,
    );
  }

  /// Show an info snackbar
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      context,
      message: message,
      backgroundColor: const Color(0xFF2196F3), // Blue
      duration: duration,
    );
  }
}
