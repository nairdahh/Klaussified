import 'package:firebase_auth/firebase_auth.dart';
import 'package:klaussified/core/constants/constants.dart';
import 'package:klaussified/data/models/user_model.dart';
import 'package:klaussified/data/repositories/user_repository.dart';
import 'package:klaussified/data/services/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _authService;
  final UserRepository _userRepository;

  AuthRepository({
    FirebaseAuthService? authService,
    UserRepository? userRepository,
  })  : _authService = authService ?? FirebaseAuthService(),
        _userRepository = userRepository ?? UserRepository();

  // Get current user
  User? get currentUser => _authService.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // Register with email and password
  Future<UserModel> registerWithEmailPassword({
    required String email,
    required String password,
    required String username,
    String? displayName,
  }) async {
    try {
      // Register user in Firebase Auth FIRST
      // This creates the authentication and gives us an authenticated user
      final userCredential = await _authService.registerWithEmailPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      // NOW check if username already exists (we're authenticated now!)
      final usernameExists = await _userRepository.usernameExists(username);
      if (usernameExists) {
        // Delete the auth user we just created since username is taken
        await user.delete();
        throw Exception('Username already exists');
      }

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty) {
        await _authService.updateDisplayName(displayName);
      }

      // Create user document in Firestore
      final userModel = UserModel(
        uid: user.uid,
        email: email.toLowerCase(),
        username: username.toLowerCase(),
        displayName: displayName ?? username,
        photoURL: user.photoURL ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        authProviders: [AppConstants.authProviderPassword],
      );

      await _userRepository.createUser(userModel);

      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final userCredential = await _authService.signInWithEmailPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user!;

    // Get user document
    final userModel = await _userRepository.getUserById(user.uid);

    if (userModel == null) {
      // Create user document if it doesn't exist (shouldn't happen normally)
      final newUserModel = UserModel(
        uid: user.uid,
        email: user.email!.toLowerCase(),
        username: user.email!.split('@').first.toLowerCase(),
        displayName: user.displayName ?? user.email!.split('@').first,
        photoURL: user.photoURL ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        authProviders: [AppConstants.authProviderPassword],
      );

      await _userRepository.createUser(newUserModel);
      return newUserModel;
    }

    return userModel;
  }

  // Sign in with Google (for future implementation)
  Future<UserModel> signInWithGoogle() async {
    final userCredential = await _authService.signInWithGoogle();
    final user = userCredential.user!;

    // Check if user document exists
    UserModel? userModel = await _userRepository.getUserById(user.uid);

    if (userModel == null) {
      // Create new user document
      final username =
          user.email!.split('@').first.toLowerCase().replaceAll('.', '_');

      userModel = UserModel(
        uid: user.uid,
        email: user.email!.toLowerCase(),
        username: username,
        displayName: user.displayName ?? username,
        photoURL: user.photoURL ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        authProviders: [AppConstants.authProviderGoogle],
      );

      await _userRepository.createUser(userModel);
    } else {
      // Add Google to auth providers if not already there
      if (!userModel.authProviders.contains(AppConstants.authProviderGoogle)) {
        final updatedUser = userModel.copyWith(
          authProviders: [
            ...userModel.authProviders,
            AppConstants.authProviderGoogle
          ],
          updatedAt: DateTime.now(),
        );
        await _userRepository.updateUser(updatedUser);
        userModel = updatedUser;
      }
    }

    return userModel;
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  // Get current user model
  Future<UserModel?> getCurrentUserModel() async {
    final user = currentUser;
    if (user == null) return null;
    return await _userRepository.getUserById(user.uid);
  }

  // Stream current user model
  Stream<UserModel?> streamCurrentUserModel() {
    return authStateChanges.asyncMap((user) async {
      if (user == null) return null;
      return await _userRepository.getUserById(user.uid);
    });
  }
}
