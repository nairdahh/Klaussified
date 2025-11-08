class AppConstants {
  // App Info
  static const String appName = 'Klaussified';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Secret Santa made easy';

  // Firebase Collection Names
  static const String usersCollection = 'users';
  static const String groupsCollection = 'groups';
  static const String invitesCollection = 'invites';
  static const String secretAssignmentsCollection = 'secretAssignments';

  // Firebase Subcollection Names
  static const String membersSubcollection = 'members';
  static const String invitesSubcollection = 'invites';

  // Group Status
  static const String statusPending = 'pending';
  static const String statusStarted = 'started';
  static const String statusRevealed = 'revealed';
  static const String statusClosed = 'closed';

  // Invite Status
  static const String inviteStatusPending = 'pending';
  static const String inviteStatusAccepted = 'accepted';
  static const String inviteStatusDeclined = 'declined';
  static const String inviteStatusExpired = 'expired';

  // Auth Providers
  static const String authProviderPassword = 'password';
  static const String authProviderGoogle = 'google.com';
  static const String authProviderApple = 'apple.com';

  // Date Constraints
  static const int revealMonth = 12; // December
  static const int revealDay = 27;

  // Reminder Settings
  static const int reminderIntervalDays = 3;

  // Group Constraints
  static const int minGroupMembers = 3;
  static const int maxGroupMembers = 50;
  static const int maxGroupNameLength = 50;

  // Username Constraints
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');

  // Password Constraints
  static const int minPasswordLength = 8;

  // Profile Details Constraints
  static const int maxRealNameLength = 50;
  static const int maxHobbiesLength = 500;
  static const int maxWishesLength = 1000;

  // Animation Durations (milliseconds)
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 400;
  static const int longAnimationDuration = 800;
  static const int slotMachineDuration = 3000;

  // Pagination
  static const int defaultPageSize = 20;

  // Error Messages
  static const String genericErrorMessage = 'An error occurred. Please try again.';
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String authErrorMessage = 'Authentication failed. Please try again.';

  // Success Messages
  static const String groupCreatedMessage = 'Group created successfully!';
  static const String inviteSentMessage = 'Invite sent successfully!';
  static const String groupStartedMessage = 'Secret Santa has started!';
  static const String pickCompletedMessage = 'You have picked your Secret Santa!';

  // Asset Paths
  static const String imagesPath = 'assets/images/';
  static const String animationsPath = 'assets/animations/';
  static const String fontsPath = 'assets/fonts/';

  // Cloud Functions Names
  static const String createGroupFunction = 'createGroup';
  static const String sendInviteFunction = 'sendInvite';
  static const String acceptInviteFunction = 'acceptInvite';
  static const String startGroupFunction = 'startGroup';
  static const String pickSecretSantaFunction = 'pickSecretSanta';
  static const String removeGroupMemberFunction = 'removeGroupMember';
  static const String revealGroupFunction = 'revealGroup';

  // Email Templates
  static const String inviteEmailTemplate = 'inviteEmail';
  static const String startNotificationTemplate = 'startNotification';
  static const String reminderEmailTemplate = 'reminderEmail';
  static const String revealEmailTemplate = 'revealEmail';

  // Local Storage Keys
  static const String userIdKey = 'userId';
  static const String userEmailKey = 'userEmail';
  static const String usernameKey = 'username';

  // Web Domain
  static const String webDomain = 'klaussified.nairdah.me';
  static const String webUrl = 'https://klaussified.nairdah.me';
}
