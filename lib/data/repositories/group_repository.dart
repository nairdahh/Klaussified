import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klaussified/core/constants/constants.dart';
import 'package:klaussified/data/models/group_model.dart';
import 'package:klaussified/data/models/group_member_model.dart';
import 'package:klaussified/data/models/profile_details_model.dart';
import 'package:klaussified/data/services/firestore_service.dart';

class GroupRepository {
  final FirestoreService _firestoreService;

  GroupRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  // Create group
  Future<GroupModel> createGroup({
    required String name,
    required String ownerId,
    required String ownerName,
    DateTime? informationalDeadline,
  }) async {
    final groupRef = _firestoreService.groupsCollection.doc();

    final group = GroupModel(
      id: groupRef.id,
      name: name,
      ownerId: ownerId,
      ownerName: ownerName,
      createdAt: DateTime.now(),
      status: AppConstants.statusPending,
      informationalDeadline: informationalDeadline,
      revealDate: DateTime(DateTime.now().year, AppConstants.revealMonth, AppConstants.revealDay),
      memberCount: 1,
      pickedCount: 0,
      memberIds: [ownerId],
    );

    await groupRef.set(group.toFirestore());

    // Add owner as first member
    await addMember(
      groupId: group.id,
      userId: ownerId,
      displayName: ownerName,
      username: ownerName,
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
  }) async {
    final memberRef = _firestoreService.groupMemberDoc(groupId, userId);

    final member = GroupMemberModel(
      userId: userId,
      displayName: displayName,
      username: username,
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
}
