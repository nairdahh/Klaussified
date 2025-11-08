import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'profile_details_model.freezed.dart';
part 'profile_details_model.g.dart';

@freezed
class ProfileDetailsModel with _$ProfileDetailsModel {
  const ProfileDetailsModel._();

  const factory ProfileDetailsModel({
    @Default('') String realName,
    @Default('') String hobbies,
    @Default('') String wishes,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        DateTime? updatedAt,
  }) = _ProfileDetailsModel;

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailsModelFromJson(json);

  // Check if profile details are complete
  bool get isComplete =>
      realName.isNotEmpty && hobbies.isNotEmpty && wishes.isNotEmpty;

  // Check if any field is filled
  bool get hasAnyData =>
      realName.isNotEmpty || hobbies.isNotEmpty || wishes.isNotEmpty;
}

// Helper functions for Timestamp conversion
DateTime? _timestampFromJson(dynamic timestamp) {
  if (timestamp == null) return null;
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  }
  return null;
}

dynamic _timestampToJson(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}
