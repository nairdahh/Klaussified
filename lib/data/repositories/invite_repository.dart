import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klaussified/core/constants/constants.dart';
import 'package:klaussified/data/models/invite_model.dart';
import 'package:klaussified/data/services/firestore_service.dart';

class InviteRepository {
  final FirestoreService _firestoreService;

  InviteRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  // Create an invite
  Future<String> createInvite({
    required String groupId,
    required String groupName,
    required String invitedBy,
    required String invitedByName,
    required String inviteeUserId,
    required String inviteeUsername,
  }) async {
    final invite = InviteModel(
      id: '', // Will be set by Firestore
      groupId: groupId,
      groupName: groupName,
      invitedBy: invitedBy,
      invitedByName: invitedByName,
      inviteeUserId: inviteeUserId,
      inviteeUsername: inviteeUsername,
      status: AppConstants.inviteStatusPending,
      createdAt: DateTime.now(),
      expiresAt: null, // Invitations never expire
    );

    final docRef = await _firestoreService.invitesCollection.add(invite.toFirestore());
    return docRef.id;
  }

  // Get invites for a user (received invitations)
  Stream<List<InviteModel>> streamUserInvites(String userId) {
    return _firestoreService.invitesCollection
        .where('inviteeUserId', isEqualTo: userId)
        .where('status', isEqualTo: AppConstants.inviteStatusPending)
        .snapshots()
        .map((snapshot) {
          final invites = snapshot.docs
              .map((doc) => InviteModel.fromFirestore(doc))
              .toList();
          // Sort in memory to avoid composite index requirement
          invites.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return invites;
        });
  }

  // Get all pending invites for a group
  Stream<List<InviteModel>> streamGroupInvites(String groupId) {
    return _firestoreService.invitesCollection
        .where('groupId', isEqualTo: groupId)
        .where('status', isEqualTo: AppConstants.inviteStatusPending)
        .snapshots()
        .map((snapshot) {
          final invites = snapshot.docs
              .map((doc) => InviteModel.fromFirestore(doc))
              .toList();
          // Sort in memory to avoid composite index requirement
          invites.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return invites;
        });
  }

  // Accept an invite
  Future<void> acceptInvite(String inviteId) async {
    await _firestoreService.invitesCollection.doc(inviteId).update({
      'status': AppConstants.inviteStatusAccepted,
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }

  // Decline an invite
  Future<void> declineInvite(String inviteId) async {
    await _firestoreService.invitesCollection.doc(inviteId).update({
      'status': AppConstants.inviteStatusDeclined,
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete an invite
  Future<void> deleteInvite(String inviteId) async {
    await _firestoreService.invitesCollection.doc(inviteId).delete();
  }

  // Get a single invite
  Future<InviteModel?> getInvite(String inviteId) async {
    final doc = await _firestoreService.invitesCollection.doc(inviteId).get();
    if (!doc.exists) return null;
    return InviteModel.fromFirestore(doc);
  }

  // Check if user already has a pending invite for a group
  Future<bool> hasPendingInvite({
    required String groupId,
    required String userId,
  }) async {
    final snapshot = await _firestoreService.invitesCollection
        .where('groupId', isEqualTo: groupId)
        .where('inviteeUserId', isEqualTo: userId)
        .where('status', isEqualTo: AppConstants.inviteStatusPending)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // Delete all invites for a group
  Future<void> deleteGroupInvites(String groupId) async {
    final snapshot = await _firestoreService.invitesCollection
        .where('groupId', isEqualTo: groupId)
        .get();

    final batch = _firestoreService.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // Auto-decline all pending invites when group starts
  Future<void> declinePendingGroupInvites(String groupId) async {
    final snapshot = await _firestoreService.invitesCollection
        .where('groupId', isEqualTo: groupId)
        .where('status', isEqualTo: AppConstants.inviteStatusPending)
        .get();

    final batch = _firestoreService.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {
        'status': AppConstants.inviteStatusDeclined,
        'respondedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
