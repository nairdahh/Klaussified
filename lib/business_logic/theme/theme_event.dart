import 'package:equatable/equatable.dart';
import 'theme_state.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeLoadRequested extends ThemeEvent {
  const ThemeLoadRequested();
}

class ThemeToggleRequested extends ThemeEvent {
  const ThemeToggleRequested();
}

class ThemeSetRequested extends ThemeEvent {
  final bool isDark;

  const ThemeSetRequested({required this.isDark});

  @override
  List<Object?> get props => [isDark];
}

class ThemeVariantChanged extends ThemeEvent {
  final ThemeVariant variant;

  const ThemeVariantChanged({required this.variant});

  @override
  List<Object?> get props => [variant];
}
