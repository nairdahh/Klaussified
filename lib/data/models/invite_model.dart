import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klaussified/core/constants/constants.dart';

part 'invite_model.freezed.dart';
part 'invite_model.g.dart';

@freezed
class InviteModel with _$InviteModel {
  const InviteModel._();

  const factory InviteModel({
    required String id,
    required String groupId,
    required String groupName,
    required String invitedBy, // userId
    required String invitedByName,
    String? inviteeEmail,
    String? inviteeUsername,
    String? inviteeUserId, // If existing user
    @Default(AppConstants.inviteStatusPending) String status,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        DateTime? respondedAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        DateTime? expiresAt,
  }) = _InviteModel;

  factory InviteModel.fromJson(Map<String, dynamic> json) =>
      _$InviteModelFromJson(json);

  // Convert from Firestore DocumentSnapshot
  factory InviteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InviteModel.fromJson({
      ...data,
      'id': doc.id,
    });
  }

  // Convert to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store id in document data
    return json;
  }

  // Check if invite is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  // Check if invite is pending
  bool get isPending => status == AppConstants.inviteStatusPending;

  // Check if invite is accepted
  bool get isAccepted => status == AppConstants.inviteStatusAccepted;

  // Check if invite is declined
  bool get isDeclined => status == AppConstants.inviteStatusDeclined;

  // Get invitee identifier (email or username)
  String get inviteeIdentifier => inviteeEmail ?? inviteeUsername ?? 'Unknown';
}

// Helper functions for Timestamp conversion
DateTime _timestampFromJson(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  }
  return DateTime.now();
}

dynamic _timestampToJson(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}
