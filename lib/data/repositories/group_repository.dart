import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klaussified/core/constants/constants.dart';
import 'package:klaussified/data/models/group_model.dart';
import 'package:klaussified/data/models/group_member_model.dart';
import 'package:klaussified/data/models/profile_details_model.dart';
import 'package:klaussified/data/services/firestore_service.dart';
import 'package:klaussified/data/repositories/invite_repository.dart';

class GroupRepository {
  final FirestoreService _firestoreService;

  GroupRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  // Create group
  Future<GroupModel> createGroup({
    required String name,
    String description = '',
    String location = '',
    String budget = '',
    required String ownerId,
    required String ownerName,
    String ownerPhotoURL = '',
    DateTime? informationalDeadline,
  }) async {
    final groupRef = _firestoreService.groupsCollection.doc();

    // Calculate reveal date: minimum December 25th of the year group is created
    final now = DateTime.now();
    final christmasThisYear = DateTime(now.year, 12, 25);

    // If created after Dec 25, use next year's Christmas
    final minRevealDate = now.isAfter(christmasThisYear)
        ? DateTime(now.year + 1, 12, 25)
        : christmasThisYear;

    // Use the later date between minRevealDate and informationalDeadline (if provided)
    final calculatedRevealDate = informationalDeadline != null && informationalDeadline.isAfter(minRevealDate)
        ? informationalDeadline
        : minRevealDate;

    final group = GroupModel(
      id: groupRef.id,
      name: name,
      description: description,
      location: location,
      budget: budget,
      ownerId: ownerId,
      ownerName: ownerName,
      createdAt: DateTime.now(),
      status: AppConstants.statusPending,
      informationalDeadline: informationalDeadline,
      revealDate: calculatedRevealDate,
      memberCount: 0, // Will be incremented to 1 when owner is added as member
      pickedCount: 0,
      memberIds: [], // Will be populated when owner is added as member
    );

    await groupRef.set(group.toFirestore());

    // Add owner as first member
    await addMember(
      groupId: group.id,
      userId: ownerId,
      displayName: ownerName,
      username: ownerName,
      photoURL: ownerPhotoURL,
    );

    return group;
  }

  // Get user's groups
  Stream<List<GroupModel>> streamUserGroups(String userId) {
    return _firestoreService.groupsCollection
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          final groups = snapshot.docs
              .map((doc) => GroupModel.fromFirestore(doc))
              .where((group) =>
                  group.status == AppConstants.statusPending ||
                  group.status == AppConstants.statusStarted ||
                  group.status == AppConstants.statusRevealed)
              .toList();

          // Sort in memory instead of using orderBy
          groups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return groups;
        });
  }

  // Get closed groups
  Stream<List<GroupModel>> streamClosedGroups(String userId) {
    return _firestoreService.groupsCollection
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          final groups = snapshot.docs
              .map((doc) => GroupModel.fromFirestore(doc))
              .where((group) => group.status == AppConstants.statusClosed)
              .toList();

          // Sort in memory instead of using orderBy
          groups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return groups;
        });
  }

  // Get group by ID
  Future<GroupModel?> getGroupById(String groupId) async {
    final doc = await _firestoreService.groupDoc(groupId).get();
    if (!doc.exists) return null;
    return GroupModel.fromFirestore(doc);
  }

  // Stream group
  Stream<GroupModel?> streamGroup(String groupId) {
    return _firestoreService.groupDoc(groupId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return GroupModel.fromFirestore(doc);
    });
  }

  // Add member to group
  Future<void> addMember({
    required String groupId,
    required String userId,
    required String displayName,
    required String username,
    String photoURL = '',
  }) async {
    final memberRef = _firestoreService.groupMemberDoc(groupId, userId);

    final member = GroupMemberModel(
      userId: userId,
      displayName: displayName,
      username: username,
      photoURL: photoURL,
      joinedAt: DateTime.now(),
      hasPicked: false,
    );

    await memberRef.set(member.toFirestore());

    // Update group member count
    await _firestoreService.groupDoc(groupId).update({
      'memberCount': FieldValue.increment(1),
      'memberIds': FieldValue.arrayUnion([userId]),
    });
  }

  // Get group members
  Stream<List<GroupMemberModel>> streamGroupMembers(String groupId) {
    return _firestoreService.groupMembersCollection(groupId)
        .orderBy('joinedAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroupMemberModel.fromFirestore(doc))
            .toList());
  }

  // Get single member
  Future<GroupMemberModel?> getMember(String groupId, String userId) async {
    final doc = await _firestoreService.groupMemberDoc(groupId, userId).get();
    if (!doc.exists) return null;
    return GroupMemberModel.fromFirestore(doc);
  }

  // Stream single member
  Stream<GroupMemberModel?> streamMember(String groupId, String userId) {
    return _firestoreService.groupMemberDoc(groupId, userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return GroupMemberModel.fromFirestore(doc);
    });
  }

  // Update member profile details
  Future<void> updateMemberProfileDetails({
    required String groupId,
    required String userId,
    required ProfileDetailsModel profileDetails,
  }) async {
    await _firestoreService.groupMemberDoc(groupId, userId).update({
      'profileDetails': profileDetails.toJson(),
    });
  }

  // Start group (simple version without Cloud Functions)
  Future<void> startGroup(String groupId) async {
    await _firestoreService.groupDoc(groupId).update({
      'status': AppConstants.statusStarted,
      'startedAt': Timestamp.now(),
    });

    // Auto-decline all pending invites when group starts
    final inviteRepo = InviteRepository();
    await inviteRepo.declinePendingGroupInvites(groupId);
  }

  // Pick Secret Santa (simplified - just mark as picked)
  Future<void> markAsPicked(String groupId, String userId) async {
    await _firestoreService.groupMemberDoc(groupId, userId).update({
      'hasPicked': true,
      'pickedAt': Timestamp.now(),
    });

    // Increment picked count
    await _firestoreService.groupDoc(groupId).update({
      'pickedCount': FieldValue.increment(1),
    });
  }

  // Assign Secret Santa (temporary - will be replaced by Cloud Function)
  Future<void> assignSecretSanta({
    required String groupId,
    required String giverId,
    required String receiverId,
  }) async {
    await _firestoreService.groupMemberDoc(groupId, giverId).update({
      'assignedToUserId': receiverId,
    });
  }

  // Reveal group
  Future<void> revealGroup(String groupId) async {
    await _firestoreService.groupDoc(groupId).update({
      'status': AppConstants.statusRevealed,
      'revealedAt': Timestamp.now(),
    });
  }

  // Remove member (owner only, before start)
  Future<void> removeMember(String groupId, String userId) async {
    await _firestoreService.groupMemberDoc(groupId, userId).delete();

    await _firestoreService.groupDoc(groupId).update({
      'memberCount': FieldValue.increment(-1),
      'memberIds': FieldValue.arrayRemove([userId]),
    });
  }

  // Delete group (owner only)
  Future<void> deleteGroup(String groupId) async {
    // Delete all members subcollection
    final membersSnapshot = await _firestoreService.groupMembersCollection(groupId).get();
    final batch = _firestoreService.batch();

    for (var doc in membersSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Delete the group document
    batch.delete(_firestoreService.groupDoc(groupId));

    await batch.commit();

    // Delete all invites for this group
    final inviteRepo = InviteRepository();
    await inviteRepo.deleteGroupInvites(groupId);
  }

  // Update member photo URL across all groups
  Future<void> updateMemberPhotoURLInAllGroups({
    required String userId,
    required String photoURL,
  }) async {
    // Get all groups where user is a member
    final groupsSnapshot = await _firestoreService.groupsCollection
        .where('memberIds', arrayContains: userId)
        .get();

    // Update photo URL in each group's member document
    for (var groupDoc in groupsSnapshot.docs) {
      final memberRef = _firestoreService.groupMemberDoc(groupDoc.id, userId);

      // Check if member document exists before updating
      final memberDoc = await memberRef.get();
      if (memberDoc.exists) {
        await memberRef.update({'photoURL': photoURL});
      }
    }
  }

  // Update group details (owner only)
  Future<void> updateGroupDetails({
    required String groupId,
    required String name,
    String description = '',
    String location = '',
    String budget = '',
    DateTime? informationalDeadline,
  }) async {
    // Recalculate reveal date based on new deadline
    final now = DateTime.now();
    final christmasThisYear = DateTime(now.year, 12, 25);

    // If created after Dec 25, use next year's Christmas
    final minRevealDate = now.isAfter(christmasThisYear)
        ? DateTime(now.year + 1, 12, 25)
        : christmasThisYear;

    // Use the later date between minRevealDate and informationalDeadline (if provided)
    final calculatedRevealDate = informationalDeadline != null && informationalDeadline.isAfter(minRevealDate)
        ? informationalDeadline
        : minRevealDate;

    await _firestoreService.groupDoc(groupId).update({
      'name': name,
      'description': description,
      'location': location,
      'budget': budget,
      'informationalDeadline': informationalDeadline != null
          ? Timestamp.fromDate(informationalDeadline)
          : null,
      'revealDate': Timestamp.fromDate(calculatedRevealDate),
    });
  }
}
