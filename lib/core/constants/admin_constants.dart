class AdminConstants {
  // Admin user credentials
  static const String adminUserId = 'LblZXIFcQ2fpZWo6mJxVGYkP1Um2';
  static const String adminEmail = 'adrian28awesome@gmail.com';

  // Check if a user is admin
  static bool isAdmin(String userId, String? email) {
    return userId == adminUserId && email == adminEmail;
  }
}
