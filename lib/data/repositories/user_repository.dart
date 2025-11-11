import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klaussified/data/models/user_model.dart';
import 'package:klaussified/data/services/firestore_service.dart';
import 'package:klaussified/data/repositories/group_repository.dart';

class UserRepository {
  final FirestoreService _firestoreService;

  UserRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  // Create user document
  Future<void> createUser(UserModel user) async {
    await _firestoreService.userDoc(user.uid).set(user.toFirestore());
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    final doc = await _firestoreService.userDoc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  // Get user by username
  Future<UserModel?> getUserByUsername(String username) async {
    final querySnapshot = await _firestoreService.usersCollection
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final user = UserModel.fromFirestore(querySnapshot.docs.first);
    return user;
  }

  // Get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    final querySnapshot = await _firestoreService.usersCollection
        .where('email', isEqualTo: email.toLowerCase())
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;
    return UserModel.fromFirestore(querySnapshot.docs.first);
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    final user = await getUserByUsername(username);
    return user != null;
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    await _firestoreService.userDoc(user.uid).update(user.toFirestore());
  }

  // Update username
  Future<void> updateUsername(String userId, String username) async {
    await _firestoreService.userDoc(userId).update({
      'username': username.toLowerCase(),
      'updatedAt': Timestamp.now(),
    });
  }

  // Update display name
  Future<void> updateDisplayName(String userId, String displayName) async {
    await _firestoreService.userDoc(userId).update({
      'displayName': displayName,
      'updatedAt': Timestamp.now(),
    });
  }

  // Update photo URL
  Future<void> updatePhotoURL(String userId, String photoURL) async {
    await _firestoreService.userDoc(userId).update({
      'photoURL': photoURL,
      'updatedAt': Timestamp.now(),
    });
  }

  // Update profile (username, displayName, photoURL)
  Future<void> updateProfile({
    required String userId,
    String? username,
    String? displayName,
    String? photoURL,
  }) async {
    final Map<String, dynamic> updates = {
      'updatedAt': Timestamp.now(),
    };

    if (username != null) updates['username'] = username.toLowerCase();
    if (displayName != null) updates['displayName'] = displayName;
    if (photoURL != null) updates['photoURL'] = photoURL;

    await _firestoreService.userDoc(userId).update(updates);

    // Update profile fields in all group memberships
    final groupRepo = GroupRepository();

    // Update photoURL in all groups if changed
    if (photoURL != null) {
      await groupRepo.updateMemberPhotoURLInAllGroups(
        userId: userId,
        photoURL: photoURL,
      );
    }

    // Update username and displayName in all groups if changed
    if (username != null || displayName != null) {
      await groupRepo.updateMemberProfileInAllGroups(
        userId: userId,
        username: username?.toLowerCase(),
        displayName: displayName,
      );
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    await _firestoreService.userDoc(userId).delete();
  }

  // Stream user data
  Stream<UserModel?> streamUser(String userId) {
    return _firestoreService.userDoc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }
}
