import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/business_logic/group/group_bloc.dart';
import 'package:klaussified/business_logic/group/group_event.dart';
import 'package:klaussified/core/routes/route_names.dart';
import 'package:klaussified/core/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for splash animation and auth check to complete
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check auth state and load groups if authenticated
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      // Load groups before navigating to home
      context.read<GroupBloc>().add(GroupLoadRequested(userId: authState.user.uid));
      context.go(RouteNames.home);
    } else {
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.christmasRed,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Icon(
              Icons.card_giftcard,
              size: 100,
              color: AppColors.snowWhite,
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 24),

            // App Name
            Text(
              'Klaussified',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.snowWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                  ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms)
                .slideY(
                  begin: 0.3,
                  end: 0,
                  delay: 300.ms,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: 12),

            // App Tagline
            Text(
              'Secret Santa Made Easy',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.snowWhite.withOpacity(0.9),
                    fontSize: 16,
                  ),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(
                  begin: 0.3,
                  end: 0,
                  delay: 600.ms,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: 60),

            // Loading Indicator
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.snowWhite.withOpacity(0.8),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 900.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
