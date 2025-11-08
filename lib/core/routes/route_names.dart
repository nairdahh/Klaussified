class RouteNames {
  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main Routes
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';

  // Group Routes
  static const String createGroup = '/create-group';
  static const String groupDetails = '/group/:groupId';
  static const String inviteMembers = '/group/:groupId/invite';
  static const String editProfileDetails = '/group/:groupId/edit-details';

  // Secret Santa Routes
  static const String pick = '/group/:groupId/pick';
  static const String reveal = '/group/:groupId/reveal';

  // Invitations
  static const String invitations = '/invitations';

  // Helper method to build group detail route
  static String getGroupDetailsRoute(String groupId) => '/group/$groupId';

  // Helper method to build invite route
  static String getInviteMembersRoute(String groupId) => '/group/$groupId/invite';

  // Helper method to build edit profile details route
  static String getEditProfileDetailsRoute(String groupId) => '/group/$groupId/edit-details';

  // Helper method to build pick route
  static String getPickRoute(String groupId) => '/group/$groupId/pick';

  // Helper method to build reveal route
  static String getRevealRoute(String groupId) => '/group/$groupId/reveal';
}
