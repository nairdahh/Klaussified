import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klaussified/business_logic/theme/theme_event.dart';
import 'package:klaussified/business_logic/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'isDarkMode';
  static const String _themeVariantKey = 'themeVariant';
  static const String _versionKey = 'themeSystemVersion';
  static const String _currentVersion = '2.0'; // Increment when making breaking changes

  ThemeBloc() : super(const ThemeInitial()) {
    on<ThemeLoadRequested>(_onThemeLoadRequested);
    on<ThemeToggleRequested>(_onThemeToggleRequested);
    on<ThemeSetRequested>(_onThemeSetRequested);
    on<ThemeVariantChanged>(_onThemeVariantChanged);
  }

  Future<void> _onThemeLoadRequested(
    ThemeLoadRequested event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check version to detect app updates and clear stale data
      final storedVersion = prefs.getString(_versionKey);
      if (storedVersion != _currentVersion) {
        // Clear old theme data if version doesn't match
        await prefs.remove(_themeKey);
        await prefs.remove(_themeVariantKey);
        await prefs.setString(_versionKey, _currentVersion);
      }

      final isDark = prefs.getBool(_themeKey) ?? false;
      final variantStr =
          prefs.getString(_themeVariantKey) ?? 'classic';
      final variant = ThemeVariant.values
          .firstWhere((e) => e.toString() == 'ThemeVariant.$variantStr',
              orElse: () => ThemeVariant.classic);

      emit(isDark
          ? ThemeDark(variant: variant)
          : ThemeLight(variant: variant));
    } catch (e) {
      emit(const ThemeLight()); // Default to light theme on error
    }
  }

  Future<void> _onThemeToggleRequested(
    ThemeToggleRequested event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final newIsDark = !state.isDark;

      // Optimistic update: emit immediately for instant UI feedback
      emit(newIsDark
          ? ThemeDark(variant: state.variant)
          : ThemeLight(variant: state.variant));

      // Then save to persistence in background (non-blocking)
      _saveThemeAsync(newIsDark, state.variant);
    } catch (e) {
      // Keep current state on error
    }
  }

  Future<void> _onThemeSetRequested(
    ThemeSetRequested event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      // Optimistic update: emit immediately for instant UI feedback
      emit(event.isDark
          ? ThemeDark(variant: state.variant)
          : ThemeLight(variant: state.variant));

      // Then save to persistence in background (non-blocking)
      _saveThemeAsync(event.isDark, state.variant);
    } catch (e) {
      // Keep current state on error
    }
  }

  Future<void> _onThemeVariantChanged(
    ThemeVariantChanged event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final newVariant = event.variant;

      // Optimistic update: emit immediately for instant UI feedback
      emit(state.isDark
          ? ThemeDark(variant: newVariant)
          : ThemeLight(variant: newVariant));

      // Then save to persistence in background (non-blocking)
      _saveThemeVariantAsync(newVariant);
    } catch (e) {
      // Keep current state on error
    }
  }

  /// Save theme preference asynchronously in the background
  Future<void> _saveThemeAsync(bool isDark, ThemeVariant variant) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
    } catch (e) {
      // Silently fail - UI is already updated
    }
  }

  /// Save theme variant asynchronously in the background
  Future<void> _saveThemeVariantAsync(ThemeVariant variant) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _themeVariantKey, variant.toString().split('.').last);
    } catch (e) {
      // Silently fail - UI is already updated
    }
  }
}
