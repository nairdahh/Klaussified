import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klaussified/business_logic/group/group_event.dart';
import 'package:klaussified/business_logic/group/group_state.dart';
import 'package:klaussified/data/repositories/group_repository.dart';
import 'package:klaussified/data/repositories/auth_repository.dart';
import 'package:klaussified/data/repositories/invite_repository.dart';
import 'package:klaussified/core/utils/error_messages.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository _groupRepository;
  final AuthRepository _authRepository;
  final InviteRepository _inviteRepository;
  StreamSubscription? _activeGroupsSubscription;
  StreamSubscription? _closedGroupsSubscription;

  GroupBloc({
    GroupRepository? groupRepository,
    AuthRepository? authRepository,
    InviteRepository? inviteRepository,
  })  : _groupRepository = groupRepository ?? GroupRepository(),
        _authRepository = authRepository ?? AuthRepository(),
        _inviteRepository = inviteRepository ?? InviteRepository(),
        super(const GroupInitial()) {
    on<GroupLoadRequested>(_onGroupLoadRequested);
    on<GroupCreateRequested>(_onGroupCreateRequested);
    on<GroupStartRequested>(_onGroupStartRequested);
    on<GroupJoinRequested>(_onGroupJoinRequested);
    on<GroupProfileDetailsUpdateRequested>(
        _onGroupProfileDetailsUpdateRequested);
    on<GroupPickRequested>(_onGroupPickRequested);
    on<GroupRevealRequested>(_onGroupRevealRequested);
    on<GroupInviteSendRequested>(_onGroupInviteSendRequested);
    on<GroupInviteAcceptRequested>(_onGroupInviteAcceptRequested);
    on<GroupInviteDeclineRequested>(_onGroupInviteDeclineRequested);
    on<GroupMemberRemoveRequested>(_onGroupMemberRemoveRequested);
    on<GroupLeaveRequested>(_onGroupLeaveRequested);
    on<_GroupsLoadedEvent>(_onGroupsLoadedEvent);
  }

  Future<void> _onGroupLoadRequested(
    GroupLoadRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupLoading());

    // Cancel both subscriptions before creating new ones
    await _activeGroupsSubscription?.cancel();
    await _closedGroupsSubscription?.cancel();

    try {
      // Use combineLatest to avoid nested subscriptions
      _activeGroupsSubscription = _groupRepository
          .streamUserGroups(event.userId)
          .listen((activeGroups) {
        // Cancel previous closed groups subscription before creating new one
        _closedGroupsSubscription?.cancel();
        _closedGroupsSubscription = _groupRepository
            .streamClosedGroups(event.userId)
            .listen((closedGroups) {
          add(_GroupsLoadedEvent(
            activeGroups: activeGroups,
            closedGroups: closedGroups,
          ));
        });
      });
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  Future<void> _onGroupsLoadedEvent(
    _GroupsLoadedEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupsLoaded(
      activeGroups: event.activeGroups.cast(),
      closedGroups: event.closedGroups.cast(),
    ));
  }

  Future<void> _onGroupCreateRequested(
    GroupCreateRequested event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupLoading());

    try {
      final user = await _authRepository.getCurrentUserModel();
      if (user == null) throw Exception('User not found');

      await _groupRepository.createGroup(
        name: event.name,
        description: event.description,
        location: event.location,
        budget: event.budget,
        ownerId: user.uid,
        ownerName:
            user.displayName.isNotEmpty ? user.displayName : user.username,
        ownerPhotoURL: user.photoURL,
        informationalDeadline: event.deadline,
      );

      emit(const GroupOperationSuccess(message: 'Group created successfully!'));
      add(GroupLoadRequested(userId: user.uid));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
      final user = await _authRepository.getCurrentUserModel();
      if (user != null) {
        add(GroupLoadRequested(userId: user.uid));
      }
    }
  }

  Future<void> _onGroupStartRequested(
    GroupStartRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await _groupRepository.startGroup(event.groupId);
      emit(const GroupOperationSuccess(
          message: 'Group started! Members can now pick.'));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  Future<void> _onGroupJoinRequested(
    GroupJoinRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await _groupRepository.addMember(
        groupId: event.groupId,
        userId: event.userId,
        displayName: event.displayName,
        username: event.username,
      );
      emit(const GroupOperationSuccess(message: 'Joined group successfully!'));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  Future<void> _onGroupProfileDetailsUpdateRequested(
    GroupProfileDetailsUpdateRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await _groupRepository.updateMemberProfileDetails(
        groupId: event.groupId,
        userId: event.userId,
        profileDetails: event.profileDetails,
      );
      emit(const GroupOperationSuccess(message: 'Profile details updated!'));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  Future<void> _onGroupPickRequested(
    GroupPickRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await _groupRepository.assignSecretSanta(
        groupId: event.groupId,
        giverId: event.userId,
        receiverId: event.assignedUserId,
      );
      await _groupRepository.markAsPicked(event.groupId, event.userId);
      emit(const GroupOperationSuccess(message: 'Secret Santa picked!'));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  Future<void> _onGroupRevealRequested(
    GroupRevealRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await _groupRepository.revealGroup(event.groupId);
      emit(const GroupOperationSuccess(message: 'Group revealed!'));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  Future<void> _onGroupInviteSendRequested(
    GroupInviteSendRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      final user = await _authRepository.getCurrentUserModel();
      if (user == null) throw Exception('User not found');

      // Check if user already has a pending invite
      final hasPending = await _inviteRepository.hasPendingInvite(
        groupId: event.groupId,
        userId: event.inviteeUserId,
      );

      if (hasPending) {
        emit(const GroupError(
            message: 'User already has a pending invite for this group'));
        return;
      }

      // Check if user is already a member
      final member =
          await _groupRepository.getMember(event.groupId, event.inviteeUserId);
      if (member != null) {
        emit(const GroupError(
            message: 'User is already a member of this group'));
        return;
      }

      final inviteId = await _inviteRepository.createInvite(
        groupId: event.groupId,
        groupName: event.groupName,
        invitedBy: user.uid,
        invitedByName:
            user.displayName.isNotEmpty ? user.displayName : user.username,
        inviteeUserId: event.inviteeUserId,
        inviteeUsername: event.inviteeUsername,
      );

      emit(const GroupOperationSuccess(message: 'Invitation sent!'));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  Future<void> _onGroupInviteAcceptRequested(
    GroupInviteAcceptRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      // Get user to fetch photoURL
      final user = await _authRepository.getCurrentUserModel();

      // Add user as member FIRST (this updates memberIds in the group document)
      await _groupRepository.addMember(
        groupId: event.groupId,
        userId: event.userId,
        displayName: event.displayName,
        username: event.username,
        photoURL: user?.photoURL ?? '',
      );

      // Mark invite as accepted AFTER (so member is added before invite disappears from UI)
      await _inviteRepository.acceptInvite(event.inviteId);

      // Verify member was added successfully with retry logic
      await _verifyMemberAdded(event.groupId, event.userId);

      emit(const GroupOperationSuccess(
          message: 'Invitation accepted! You joined the group.'));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  // Helper method to verify member was added with retry logic
  Future<void> _verifyMemberAdded(String groupId, String userId,
      {int maxRetries = 5}) async {
    for (int i = 0; i < maxRetries; i++) {
      final group = await _groupRepository.getGroupById(groupId);
      if (group?.memberIds.contains(userId) ?? false) {
        return; // Success!
      }

      // Wait before retrying (exponential backoff: 100ms, 200ms, 400ms, 800ms, 1600ms)
      await Future.delayed(Duration(milliseconds: 100 * (1 << i)));
    }

    // If we get here, verification failed after all retries
    throw Exception(
        'Failed to verify member was added to group after $maxRetries attempts');
  }

  Future<void> _onGroupInviteDeclineRequested(
    GroupInviteDeclineRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      await _inviteRepository.declineInvite(event.inviteId);
      emit(const GroupOperationSuccess(message: 'Invitation declined'));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  Future<void> _onGroupMemberRemoveRequested(
    GroupMemberRemoveRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      // Get group to verify ownership
      final group = await _groupRepository.getGroupById(event.groupId);
      if (group == null) throw Exception('Group not found');

      final user = await _authRepository.getCurrentUserModel();
      if (user == null) throw Exception('User not found');

      // Only owner can remove members
      if (group.ownerId != user.uid) {
        throw Exception('Only the group owner can remove members');
      }

      // Cannot remove yourself
      if (event.userId == user.uid) {
        throw Exception('Cannot remove yourself from the group');
      }

      // Can only remove members before group starts
      if (!group.isPending) {
        throw Exception('Cannot remove members after group has started');
      }

      await _groupRepository.removeMember(event.groupId, event.userId);
      emit(const GroupOperationSuccess(message: 'Member removed from group'));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  Future<void> _onGroupLeaveRequested(
    GroupLeaveRequested event,
    Emitter<GroupState> emit,
  ) async {
    try {
      // Get group to verify user can leave
      final group = await _groupRepository.getGroupById(event.groupId);
      if (group == null) throw Exception('Group not found');

      // Owner cannot leave, must delete the group instead
      if (group.ownerId == event.userId) {
        throw Exception('Group owner cannot leave. Delete the group instead.');
      }

      // Can only leave before group starts
      if (!group.isPending) {
        throw Exception('Cannot leave after group has started');
      }

      await _groupRepository.removeMember(event.groupId, event.userId);
      emit(const GroupOperationSuccess(message: 'You have left the group'));
    } catch (e) {
      emit(GroupError(message: ErrorMessages.getUserFriendlyMessage(e)));
    }
  }

  @override
  Future<void> close() {
    _activeGroupsSubscription?.cancel();
    _closedGroupsSubscription?.cancel();
    return super.close();
  }
}

// Helper event for internal use (private)
class _GroupsLoadedEvent extends GroupEvent {
  final List<dynamic> activeGroups;
  final List<dynamic> closedGroups;
  const _GroupsLoadedEvent(
      {required this.activeGroups, required this.closedGroups});

  @override
  List<Object?> get props => [activeGroups, closedGroups];
}
