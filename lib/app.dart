import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_event.dart';
import 'package:klaussified/business_logic/group/group_bloc.dart';
import 'package:klaussified/business_logic/theme/theme_bloc.dart';
import 'package:klaussified/business_logic/theme/theme_event.dart';
import 'package:klaussified/business_logic/theme/theme_state.dart';
import 'package:klaussified/core/theme/app_theme.dart';
import 'package:klaussified/core/routes/app_router.dart';

// Custom scroll behavior for smooth scrolling
class SmoothScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class KlaussifiedApp extends StatelessWidget {
  const KlaussifiedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(const AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => GroupBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc()..add(const ThemeLoadRequested()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Klaussified',
            debugShowCheckedModeBanner: false,
            scrollBehavior: SmoothScrollBehavior(),
            theme: AppTheme.getTheme(
              variant: themeState.variant,
              isDark: false,
            ),
            darkTheme: AppTheme.getTheme(
              variant: themeState.variant,
              isDark: true,
            ),
            themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
            routerConfig: AppRouter.router,
            // Localization for calendar to start with Monday
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'GB'), // UK locale starts week with Monday
            ],
            locale: const Locale('en', 'GB'),
            // Performance optimizations
            showPerformanceOverlay: false,
            checkerboardRasterCacheImages: false,
            checkerboardOffscreenLayers: false,
          );
        },
      ),
    );
  }
}
