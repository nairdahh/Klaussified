import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klaussified/core/constants/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Collection References
  CollectionReference get usersCollection =>
      _firestore.collection(AppConstants.usersCollection);

  DocumentReference userDoc(String userId) => usersCollection.doc(userId);

  // Group Collection References
  CollectionReference get groupsCollection =>
      _firestore.collection(AppConstants.groupsCollection);

  DocumentReference groupDoc(String groupId) => groupsCollection.doc(groupId);

  // Group Members Subcollection
  CollectionReference groupMembersCollection(String groupId) =>
      groupDoc(groupId).collection(AppConstants.membersSubcollection);

  DocumentReference groupMemberDoc(String groupId, String memberId) =>
      groupMembersCollection(groupId).doc(memberId);

  // Group Invites Subcollection
  CollectionReference groupInvitesCollection(String groupId) =>
      groupDoc(groupId).collection(AppConstants.invitesSubcollection);

  // Invites Collection
  CollectionReference get invitesCollection =>
      _firestore.collection(AppConstants.invitesCollection);

  DocumentReference inviteDoc(String inviteId) => invitesCollection.doc(inviteId);

  // Secret Assignments Collection (server-only access)
  CollectionReference get secretAssignmentsCollection =>
      _firestore.collection(AppConstants.secretAssignmentsCollection);

  DocumentReference secretAssignmentDoc(String groupId) =>
      secretAssignmentsCollection.doc(groupId);

  // Batch Operations
  WriteBatch batch() => _firestore.batch();

  // Transaction Operations
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
  }) {
    return _firestore.runTransaction(
      transactionHandler,
      timeout: timeout,
    );
  }
}
