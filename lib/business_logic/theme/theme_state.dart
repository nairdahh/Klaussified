import 'package:equatable/equatable.dart';

enum ThemeVariant { classic, catppuccin }

abstract class ThemeState extends Equatable {
  final bool isDark;
  final ThemeVariant variant;

  const ThemeState({
    required this.isDark,
    this.variant = ThemeVariant.classic,
  });

  @override
  List<Object?> get props => [isDark, variant];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(isDark: false, variant: ThemeVariant.classic);
}

class ThemeLight extends ThemeState {
  const ThemeLight({super.variant = ThemeVariant.classic})
      : super(isDark: false);
}

class ThemeDark extends ThemeState {
  const ThemeDark({super.variant = ThemeVariant.classic})
      : super(isDark: true);
}
