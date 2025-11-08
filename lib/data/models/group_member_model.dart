import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klaussified/data/models/profile_details_model.dart';

part 'group_member_model.freezed.dart';
part 'group_member_model.g.dart';

@freezed
class GroupMemberModel with _$GroupMemberModel {
  const GroupMemberModel._();

  const factory GroupMemberModel({
    required String userId,
    required String displayName,
    required String username,
    @Default('') String photoURL,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        required DateTime joinedAt,
    @Default(false) bool hasPicked,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        DateTime? pickedAt,
    String? assignedToUserId, // Only visible to the user (their Secret Santa assignment)
    @Default(ProfileDetailsModel())
        ProfileDetailsModel profileDetails,
  }) = _GroupMemberModel;

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);

  // Convert from Firestore DocumentSnapshot
  factory GroupMemberModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupMemberModel.fromJson({
      ...data,
      'userId': doc.id,
    });
  }

  // Convert to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('userId'); // Don't store userId in document data (it's the doc ID)

    // Manually convert profileDetails to ensure it's a Map
    json['profileDetails'] = profileDetails.toJson();

    return json;
  }

  // Check if profile details are filled
  bool get hasCompletedProfile => profileDetails.isComplete;
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
