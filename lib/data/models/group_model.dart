import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klaussified/core/constants/constants.dart';

part 'group_model.freezed.dart';
part 'group_model.g.dart';

@freezed
class GroupModel with _$GroupModel {
  const GroupModel._();

  const factory GroupModel({
    required String id,
    required String name,
    required String ownerId,
    required String ownerName,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        required DateTime createdAt,
    @Default('') String description, // Event details/description
    @Default('') String location, // Event location
    @Default('') String budget, // Suggested budget
    @Default(AppConstants.statusPending) String status,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        DateTime? startedAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        DateTime? informationalDeadline,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        DateTime? revealDate,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
        DateTime? revealedAt,
    @Default(0) int memberCount,
    @Default(0) int pickedCount,
    @Default([]) List<String> memberIds,
  }) = _GroupModel;

  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);

  // Convert from Firestore DocumentSnapshot
  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel.fromJson({
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

  // Status checks
  bool get isPending => status == AppConstants.statusPending;
  bool get isStarted => status == AppConstants.statusStarted;
  bool get isRevealed => status == AppConstants.statusRevealed;
  bool get isClosed => status == AppConstants.statusClosed;

  // Check if all members have picked
  bool get isAllPicked => pickedCount == memberCount;

  // Check if group can be started
  bool get canStart =>
      isPending && memberCount >= AppConstants.minGroupMembers;

  // Check if reveal is available
  // Groups can only be archived after December 28, 2025
  bool get canReveal {
    if (!isStarted || !isAllPicked) return false;

    // Minimum archive date: December 28, 2025 at 00:00:00
    final minimumArchiveDate = DateTime(2025, 12, 28);
    final now = DateTime.now();

    // Must be after December 28, 2025
    if (now.isBefore(minimumArchiveDate)) return false;

    // If there's a specific reveal date set, respect it as well
    if (revealDate != null && now.isBefore(revealDate!)) return false;

    return true;
  }

  // Get days until deadline
  int? get daysUntilDeadline {
    if (informationalDeadline == null) return null;
    final now = DateTime.now();
    if (now.isAfter(informationalDeadline!)) return 0;
    return informationalDeadline!.difference(now).inDays;
  }

  // Get hours until deadline
  int? get hoursUntilDeadline {
    if (informationalDeadline == null) return null;
    final now = DateTime.now();
    if (now.isAfter(informationalDeadline!)) return 0;
    return informationalDeadline!.difference(now).inHours;
  }

  // Get completion percentage
  double get completionPercentage {
    if (memberCount == 0) return 0;
    return (pickedCount / memberCount) * 100;
  }

  // Check if deadline is approaching (less than 24 hours)
  bool get isDeadlineApproaching {
    if (informationalDeadline == null) return false;
    final hoursLeft = hoursUntilDeadline ?? 0;
    return hoursLeft > 0 && hoursLeft <= 24;
  }

  // Check if deadline has passed
  bool get isDeadlinePassed {
    if (informationalDeadline == null) return false;
    return DateTime.now().isAfter(informationalDeadline!);
  }
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
