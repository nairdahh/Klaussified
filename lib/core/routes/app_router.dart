import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/core/routes/route_names.dart';
import 'package:klaussified/presentation/screens/splash/splash_screen.dart';
import 'package:klaussified/presentation/screens/auth/login_screen.dart';
import 'package:klaussified/presentation/screens/auth/register_screen.dart';
import 'package:klaussified/presentation/screens/home/home_screen.dart';
import 'package:klaussified/presentation/screens/group/create_group_screen.dart';
import 'package:klaussified/presentation/screens/group/group_details_screen.dart';
import 'package:klaussified/presentation/screens/group/edit_profile_details_screen.dart';
import 'package:klaussified/presentation/screens/secret_santa/pick_screen.dart';
import 'package:klaussified/presentation/screens/secret_santa/reveal_screen.dart';
import 'package:klaussified/presentation/screens/invitations/invitations_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final _auth = FirebaseAuth.instance;

  static GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final isAuthenticated = _auth.currentUser != null;
      final isGoingToSplash = state.matchedLocation == RouteNames.splash;
      final isGoingToAuth = state.matchedLocation == RouteNames.login ||
                           state.matchedLocation == RouteNames.register;

      // If not authenticated and trying to access protected routes, redirect to login
      if (!isAuthenticated && !isGoingToAuth && !isGoingToSplash) {
        return RouteNames.login;
      }

      // If authenticated and trying to access auth screens, redirect to home
      if (isAuthenticated && isGoingToAuth) {
        return RouteNames.home;
      }

      return null; // No redirect needed
    },
    refreshListenable: GoRouterRefreshStream(_auth.authStateChanges()),
    routes: [
      // Splash Screen
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),

      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),

      // Home Routes
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),

      // Group Routes
      GoRoute(
        path: RouteNames.createGroup,
        name: 'createGroup',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const CreateGroupScreen(),
        ),
      ),

      GoRoute(
        path: '/group/:id',
        name: 'groupDetails',
        pageBuilder: (context, state) {
          final groupId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: GroupDetailsScreen(groupId: groupId),
          );
        },
      ),

      GoRoute(
        path: '/group/:id/edit-details',
        name: 'editProfileDetails',
        pageBuilder: (context, state) {
          final groupId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: EditProfileDetailsScreen(groupId: groupId),
          );
        },
      ),

      // Secret Santa Routes
      GoRoute(
        path: '/group/:id/pick',
        name: 'pick',
        pageBuilder: (context, state) {
          final groupId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: PickScreen(groupId: groupId),
          );
        },
      ),

      GoRoute(
        path: '/group/:id/reveal',
        name: 'reveal',
        pageBuilder: (context, state) {
          final groupId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: RevealScreen(groupId: groupId),
          );
        },
      ),

      // Invitations Route
      GoRoute(
        path: '/invitations',
        name: 'invitations',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const InvitationsScreen(),
        ),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.splash),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
