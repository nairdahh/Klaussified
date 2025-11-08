import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Check auth status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

// Login with email/password
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

// Register with email/password
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String? displayName;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.username,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, username, displayName];
}

// Login with Google
class AuthGoogleLoginRequested extends AuthEvent {
  const AuthGoogleLoginRequested();
}

// Logout
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

// Password reset
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}
