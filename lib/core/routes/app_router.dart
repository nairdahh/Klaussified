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
import 'package:klaussified/presentation/screens/group/edit_group_screen.dart';
import 'package:klaussified/presentation/screens/secret_santa/pick_screen.dart';
import 'package:klaussified/presentation/screens/secret_santa/reveal_screen.dart';
import 'package:klaussified/presentation/screens/invitations/invitations_screen.dart';
import 'package:klaussified/presentation/screens/profile/profile_screen.dart';
import 'package:klaussified/presentation/screens/about/about_screen.dart';
import 'package:klaussified/presentation/screens/settings/settings_screen.dart';
import 'package:klaussified/presentation/screens/admin/admin_panel_screen.dart';
import 'package:klaussified/presentation/screens/landing/landing_page_screen.dart';
import 'package:klaussified/presentation/screens/unsubscribe/unsubscribe_screen.dart';
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
      final isGoingToLanding = state.matchedLocation == RouteNames.landing;
      final isGoingToAbout = state.matchedLocation == '/about';
      final isGoingToUnsubscribe = state.matchedLocation == RouteNames.unsubscribe;

      // If not authenticated and trying to access protected routes, redirect to landing
      if (!isAuthenticated &&
          !isGoingToAuth &&
          !isGoingToSplash &&
          !isGoingToLanding &&
          !isGoingToAbout &&
          !isGoingToUnsubscribe) {
        return RouteNames.landing;
      }

      // If authenticated and trying to access auth screens or landing, redirect to home
      if (isAuthenticated && (isGoingToAuth || isGoingToLanding)) {
        return RouteNames.home;
      }

      return null; // No redirect needed
    },
    refreshListenable: GoRouterRefreshStream(_auth.authStateChanges()),
    routes: [
      // Landing Page
      GoRoute(
        path: RouteNames.landing,
        name: 'landing',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LandingPageScreen(),
        ),
      ),

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

      GoRoute(
        path: '/group/:id/edit',
        name: 'editGroup',
        pageBuilder: (context, state) {
          final groupId = state.pathParameters['id']!;
          return MaterialPage(
            key: state.pageKey,
            child: EditGroupScreen(groupId: groupId),
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

      // Profile Route
      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),

      // About Route
      GoRoute(
        path: '/about',
        name: 'about',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const AboutScreen(),
        ),
      ),

      // Settings Route
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),

      // Admin Route
      GoRoute(
        path: '/admin',
        name: 'admin',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const AdminPanelScreen(),
        ),
      ),

      // Unsubscribe Route (no auth required)
      GoRoute(
        path: '/unsubscribe',
        name: 'unsubscribe',
        pageBuilder: (context, state) {
          final token = state.uri.queryParameters['token'];
          final type = state.uri.queryParameters['type'];
          return MaterialPage(
            key: state.pageKey,
            child: UnsubscribeScreen(token: token, type: type),
          );
        },
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
