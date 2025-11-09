import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_event.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authSubscription;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthGoogleLoginRequested>(_onAuthGoogleLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);

    // Listen to auth state changes
    _authSubscription =
        _authRepository.streamCurrentUserModel().listen((user) {
      if (user != null) {
        add(const AuthCheckRequested());
      }
    });
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authRepository.getCurrentUserModel();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithEmailPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: _getErrorMessage(e)));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.registerWithEmailPassword(
        email: event.email,
        password: event.password,
        username: event.username,
        displayName: event.displayName,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: _getErrorMessage(e)));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthGoogleLoginRequested(
    AuthGoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: _getErrorMessage(e)));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: _getErrorMessage(e)));
    }
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authRepository.sendPasswordResetEmail(event.email);
      emit(const AuthPasswordResetSent());
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: _getErrorMessage(e)));
      emit(const AuthUnauthenticated());
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('user-not-found')) {
      return 'No user found with this email';
    } else if (error.toString().contains('wrong-password')) {
      return 'Wrong password';
    } else if (error.toString().contains('email-already-in-use')) {
      return 'Email already in use';
    } else if (error.toString().contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.toString().contains('invalid-email')) {
      return 'Invalid email address';
    } else if (error.toString().contains('Username already exists')) {
      return 'Username already taken';
    } else if (error.toString().contains('permission-denied') ||
               error.toString().contains('PERMISSION_DENIED')) {
      return 'Permission denied. Please check your account permissions.';
    } else {
      return 'An error occurred. Please try again.';
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
