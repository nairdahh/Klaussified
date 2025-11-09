import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// Utility class for converting technical errors to user-friendly messages
class ErrorMessages {
  /// Convert any exception to a user-friendly message
  static String getUserFriendlyMessage(dynamic error) {
    if (error is FirebaseException) {
      return _getFirebaseErrorMessage(error);
    } else if (error is FirebaseAuthException) {
      return _getAuthErrorMessage(error);
    } else if (error is FirebaseFunctionsException) {
      return _getFunctionsErrorMessage(error);
    } else if (error is Exception) {
      // Extract message from Exception
      final errorString = error.toString();
      if (errorString.startsWith('Exception: ')) {
        return errorString.substring(11); // Remove 'Exception: ' prefix
      }
      return 'An unexpected error occurred. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Convert Firebase errors to user-friendly messages
  static String _getFirebaseErrorMessage(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'You don\'t have permission to perform this action.';
      case 'not-found':
        return 'The requested item was not found.';
      case 'already-exists':
        return 'This item already exists.';
      case 'resource-exhausted':
        return 'Too many requests. Please try again later.';
      case 'failed-precondition':
        return 'This action cannot be performed at this time.';
      case 'aborted':
        return 'The operation was aborted. Please try again.';
      case 'out-of-range':
        return 'Invalid value provided.';
      case 'unimplemented':
        return 'This feature is not yet available.';
      case 'internal':
        return 'A server error occurred. Please try again later.';
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again.';
      case 'data-loss':
        return 'Data may have been lost. Please contact support.';
      case 'unauthenticated':
        return 'Please sign in to continue.';
      case 'deadline-exceeded':
        return 'Request timed out. Please try again.';
      case 'cancelled':
        return 'The operation was cancelled.';
      default:
        return 'An error occurred: ${e.message ?? 'Please try again.'}';
    }
  }

  /// Convert Firebase Auth errors to user-friendly messages
  static String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'invalid-credential':
        return 'The credentials provided are invalid.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different account.';
      case 'requires-recent-login':
        return 'Please sign in again to complete this action.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication error: ${e.message ?? 'Please try again.'}';
    }
  }

  /// Convert Cloud Functions errors to user-friendly messages
  static String _getFunctionsErrorMessage(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'ok':
        return 'Success';
      case 'cancelled':
        return 'The operation was cancelled.';
      case 'unknown':
        return 'An unknown error occurred.';
      case 'invalid-argument':
        return 'Invalid information provided.';
      case 'deadline-exceeded':
        return 'Request timed out. Please try again.';
      case 'not-found':
        return 'The requested item was not found.';
      case 'already-exists':
        return 'This item already exists.';
      case 'permission-denied':
        return 'You don\'t have permission to perform this action.';
      case 'resource-exhausted':
        return 'Too many requests. Please try again later.';
      case 'failed-precondition':
        return e.message ?? 'This action cannot be performed at this time.';
      case 'aborted':
        return 'The operation was aborted. Please try again.';
      case 'out-of-range':
        return 'Invalid value provided.';
      case 'unimplemented':
        return 'This feature is not yet available.';
      case 'internal':
        return 'A server error occurred. Please try again later.';
      case 'unavailable':
        return 'Service temporarily unavailable. Please try again.';
      case 'data-loss':
        return 'Data may have been lost. Please contact support.';
      case 'unauthenticated':
        return 'Please sign in to continue.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
