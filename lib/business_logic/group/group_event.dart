import 'package:equatable/equatable.dart';
import 'package:klaussified/data/models/profile_details_model.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

class GroupLoadRequested extends GroupEvent {
  final String userId;
  const GroupLoadRequested({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class GroupCreateRequested extends GroupEvent {
  final String name;
  final String description;
  final String location;
  final String budget;
  final DateTime? deadline;
  final DateTime? eventDate;
  const GroupCreateRequested({
    required this.name,
    this.description = '',
    this.location = '',
    this.budget = '',
    this.deadline,
    this.eventDate,
  });
  @override
  List<Object?> get props => [name, description, location, budget, deadline, eventDate];
}

class GroupStartRequested extends GroupEvent {
  final String groupId;
  const GroupStartRequested({required this.groupId});
  @override
  List<Object?> get props => [groupId];
}

class GroupJoinRequested extends GroupEvent {
  final String groupId;
  final String userId;
  final String displayName;
  final String username;
  const GroupJoinRequested({
    required this.groupId,
    required this.userId,
    required this.displayName,
    required this.username,
  });
  @override
  List<Object?> get props => [groupId, userId, displayName, username];
}

class GroupProfileDetailsUpdateRequested extends GroupEvent {
  final String groupId;
  final String userId;
  final ProfileDetailsModel profileDetails;
  const GroupProfileDetailsUpdateRequested({
    required this.groupId,
    required this.userId,
    required this.profileDetails,
  });
  @override
  List<Object?> get props => [groupId, userId, profileDetails];
}

class GroupPickRequested extends GroupEvent {
  final String groupId;
  final String userId;
  final String assignedUserId;
  const GroupPickRequested({
    required this.groupId,
    required this.userId,
    required this.assignedUserId,
  });
  @override
  List<Object?> get props => [groupId, userId, assignedUserId];
}

class GroupRevealRequested extends GroupEvent {
  final String groupId;
  const GroupRevealRequested({required this.groupId});
  @override
  List<Object?> get props => [groupId];
}

class GroupInviteSendRequested extends GroupEvent {
  final String groupId;
  final String groupName;
  final String inviteeUserId;
  final String inviteeUsername;
  const GroupInviteSendRequested({
    required this.groupId,
    required this.groupName,
    required this.inviteeUserId,
    required this.inviteeUsername,
  });
  @override
  List<Object?> get props => [groupId, groupName, inviteeUserId, inviteeUsername];
}

class GroupInviteAcceptRequested extends GroupEvent {
  final String inviteId;
  final String groupId;
  final String userId;
  final String displayName;
  final String username;
  const GroupInviteAcceptRequested({
    required this.inviteId,
    required this.groupId,
    required this.userId,
    required this.displayName,
    required this.username,
  });
  @override
  List<Object?> get props => [inviteId, groupId, userId, displayName, username];
}

class GroupInviteDeclineRequested extends GroupEvent {
  final String inviteId;
  const GroupInviteDeclineRequested({required this.inviteId});
  @override
  List<Object?> get props => [inviteId];
}

class GroupMemberRemoveRequested extends GroupEvent {
  final String groupId;
  final String userId;
  const GroupMemberRemoveRequested({
    required this.groupId,
    required this.userId,
  });
  @override
  List<Object?> get props => [groupId, userId];
}

class GroupLeaveRequested extends GroupEvent {
  final String groupId;
  final String userId;
  const GroupLeaveRequested({
    required this.groupId,
    required this.userId,
  });
  @override
  List<Object?> get props => [groupId, userId];
}
