import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/business_logic/group/group_bloc.dart';
import 'package:klaussified/business_logic/group/group_event.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/data/repositories/group_repository.dart';
import 'package:klaussified/data/repositories/user_repository.dart';
import 'package:klaussified/data/repositories/invite_repository.dart';
import 'package:klaussified/data/models/group_member_model.dart';
import 'package:klaussified/data/models/invite_model.dart';

class GroupDetailsScreen extends StatelessWidget {
  final String groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final groupRepo = GroupRepository();
    final authState = context.read<AuthBloc>().state;
    final currentUserId = (authState as AuthAuthenticated).user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Details'),
        backgroundColor: AppColors.christmasGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          tooltip: 'Back',
        ),
        actions: [
          StreamBuilder(
            stream: groupRepo.streamGroup(groupId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              final group = snapshot.data!;
              final isOwner = group.ownerId == currentUserId;

              return IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () => _showGroupInfoDialog(context, group, isOwner, currentUserId),
                tooltip: 'Group Information',
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: groupRepo.streamGroup(groupId),
        builder: (context, groupSnapshot) {
          if (!groupSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final group = groupSnapshot.data!;
          final isOwner = group.ownerId == currentUserId;

          return StreamBuilder(
            stream: groupRepo.streamGroupMembers(groupId),
            builder: (context, membersSnapshot) {
              if (!membersSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final members = membersSnapshot.data!;

              // Calculate actual counts from members list
              final actualMemberCount = members.length;
              final actualPickedCount = members.where((m) => m.hasPicked).length;

              GroupMemberModel? currentMember;
              try {
                currentMember = members.firstWhere((m) => m.userId == currentUserId);
              } catch (e) {
                // Member not found, currentMember remains null
              }

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: StreamBuilder<List<InviteModel>>(
                    stream: InviteRepository().streamGroupInvites(groupId),
                    builder: (context, invitesSnapshot) {
                      final invites = invitesSnapshot.data ?? [];

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                  // Group Info Card - Full Width
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.card_giftcard, size: 32, color: AppColors.christmasRed),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    group.name,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.christmasGreen,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(Icons.info_outline, 'Status', group.status.toUpperCase()),
                            const SizedBox(height: 8),
                            if (group.description.isNotEmpty) ...[
                              _buildInfoRow(Icons.description, 'Description', group.description),
                              const SizedBox(height: 8),
                            ],
                            if (group.location.isNotEmpty) ...[
                              _buildInfoRow(Icons.location_on, 'Location', group.location),
                              const SizedBox(height: 8),
                            ],
                            if (group.budget.isNotEmpty) ...[
                              _buildInfoRow(Icons.attach_money, 'Budget', group.budget),
                              const SizedBox(height: 8),
                            ],
                            _buildInfoRow(Icons.people, 'Members', '$actualMemberCount'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.check_circle, 'Picked', '$actualPickedCount/$actualMemberCount'),
                            if (group.informationalDeadline != null) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.calendar_today,
                                'Deadline',
                                '${group.informationalDeadline!.day}/${group.informationalDeadline!.month}/${group.informationalDeadline!.year}',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Column(
                      children: [
                        // Start Button (only for owner with 2+ members, disabled until 3+)
                        if (group.isPending && isOwner && actualMemberCount >= 2)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: actualMemberCount < 3
                                  ? null
                                  : () => _showStartConfirmationDialog(context, groupId, actualMemberCount),
                              icon: const Icon(Icons.play_arrow),
                              label: Text(actualMemberCount < 3
                                  ? 'Need ${3 - actualMemberCount} more member(s) to start'
                                  : 'Start Secret Santa'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.christmasRed,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        if (group.isPending && isOwner && actualMemberCount >= 2)
                          const SizedBox(height: 12),

                        // Edit Profile Details Button (always visible)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.push('/group/$groupId/edit-details'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Edit My Profile Details'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pick/Reveal Buttons
                  if (currentMember != null && group.isStarted && !currentMember.hasPicked)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push('/group/$groupId/pick'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Pick Your Secret Santa'),
                        ),
                      ),
                    ),
                  if (currentMember != null && currentMember.hasPicked && currentMember.assignedToUserId != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push('/group/$groupId/reveal'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('View Your Assignment'),
                        ),
                      ),
                    ),

                  // Completion Message when all members have picked
                  if (group.isStarted &&
                      actualPickedCount == actualMemberCount &&
                      actualMemberCount >= 3)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Card(
                        color: AppColors.christmasGreen.withValues(alpha: 0.1),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.christmasGreen, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.celebration,
                                size: 48,
                                color: AppColors.christmasGreen,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '🎉 All Members Have Been Picked! 🎉',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.christmasGreen,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                group.revealDate != null
                                    ? 'The creator will be able to archive the group after ${group.revealDate!.day}/${group.revealDate!.month}/${group.revealDate!.year} and all assignments will be revealed. Until then, Merry Christmas and we hope you enjoy your gifts!'
                                    : 'The group is now complete! All members have their assignments. The creator will be able to archive the group soon. Merry Christmas and we hope you enjoy your gifts!',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textPrimary,
                                      height: 1.5,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Invite Members Button (just before Members section)
                  if (group.isPending)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showInviteDialog(context, groupId),
                          icon: const Icon(Icons.person_add),
                          label: const Text('Invite Members'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.christmasGreen,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),

                  // Members Section Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        const Icon(Icons.people, color: AppColors.christmasGreen),
                        const SizedBox(width: 8),
                        Text(
                          'Members (${members.length})',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.christmasGreen,
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Members List
                  ...members.map((member) {
                              final displayName = member.displayName.isNotEmpty
                                  ? member.displayName
                                  : member.username;
                              final canRemove = isOwner &&
                                               group.isPending &&
                                               member.userId != currentUserId;

                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.christmasGreen,
                                    child: member.photoURL.isNotEmpty
                                        ? ClipOval(
                                            child: Image.network(
                                              member.photoURL,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Text(
                                                  displayName[0].toUpperCase(),
                                                  style: const TextStyle(
                                                    color: AppColors.snowWhite,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Text(
                                            displayName[0].toUpperCase(),
                                            style: const TextStyle(
                                              color: AppColors.snowWhite,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                  title: Text(
                                    displayName,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text('@${member.username}'),
                                  trailing: canRemove
                                      ? IconButton(
                                          icon: const Icon(Icons.person_remove, color: AppColors.error),
                                          onPressed: () => _removeMember(context, groupId, member.userId, displayName),
                                          tooltip: 'Remove member',
                                        )
                                      : SizedBox(
                                          width: 48,
                                          height: 48,
                                          child: Center(
                                            child: member.hasPicked
                                                ? const Icon(Icons.check_circle, color: AppColors.christmasGreen)
                                                : Icon(Icons.pending, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                                          ),
                                        ),
                                ),
                              );
                            }),

                            // Invited Members Section (only show if there are pending invites)
                            if (invites.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.mail_outline, color: AppColors.christmasRed),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Invited Members (${invites.length})',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.christmasRed,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              // Invited Members List
                              ...invites.map((invite) {
                                // Can cancel if owner OR if current user invited this person
                                final canCancelInvite = isOwner || invite.invitedBy == currentUserId;

                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: AppColors.christmasRed.withValues(alpha: 0.2),
                                      child: const Icon(
                                        Icons.mail_outline,
                                        color: AppColors.christmasRed,
                                      ),
                                    ),
                                    title: Text(
                                      invite.inviteeUsername ?? 'Unknown User',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      'Invited by ${invite.invitedByName}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    trailing: canCancelInvite
                                        ? IconButton(
                                            icon: const Icon(Icons.cancel, color: AppColors.error),
                                            onPressed: () => _cancelInvite(context, invite.id, invite.inviteeUsername ?? 'this user'),
                                            tooltip: 'Cancel invitation',
                                          )
                                        : const SizedBox(
                                            width: 48,
                                            height: 48,
                                            child: Center(
                                              child: Icon(
                                                Icons.hourglass_empty,
                                                color: AppColors.christmasRed,
                                              ),
                                            ),
                                          ),
                                  ),
                                );
                              }),
                            ],

                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.christmasGreen),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  void _showInviteDialog(BuildContext context, String groupId) {
    final usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.person_add, color: AppColors.christmasGreen),
            const SizedBox(width: 12),
            const Text('Invite Member'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the username of the person you want to invite:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'e.g., johndoe',
                prefixIcon: Icon(Icons.alternate_email),
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _inviteMember(context, dialogContext, groupId, usernameController.text),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _inviteMember(context, dialogContext, groupId, usernameController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.christmasGreen,
            ),
            child: const Text('Invite'),
          ),
        ],
      ),
    );
  }

  Future<void> _inviteMember(
    BuildContext context,
    BuildContext dialogContext,
    String groupId,
    String username,
  ) async {
    if (username.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a username'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.of(dialogContext).pop();

    try {
      // Get auth state
      final authBloc = context.read<AuthBloc>();
      if (authBloc.state is! AuthAuthenticated) return;

      final currentUser = (authBloc.state as AuthAuthenticated).user;

      // Check if trying to invite self
      if (username.toLowerCase() == currentUser.username.toLowerCase()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You cannot invite yourself!'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Get user repository to find user by username
      final userRepo = UserRepository();
      final invitedUser = await userRepo.getUserByUsername(username.toLowerCase());

      if (!context.mounted) return;

      if (invitedUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User "$username" not found'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Get group data for invite
      final groupRepo = GroupRepository();
      final groupData = await groupRepo.getGroupById(groupId);
      if (groupData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group not found'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (!context.mounted) return;

      // Send invitation using GroupBloc
      context.read<GroupBloc>().add(
            GroupInviteSendRequested(
              groupId: groupId,
              groupName: groupData.name,
              inviteeUserId: invitedUser.uid,
              inviteeUsername: invitedUser.username,
            ),
          );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invitation sent to ${invitedUser.displayName.isNotEmpty ? invitedUser.displayName : invitedUser.username}!'),
          backgroundColor: AppColors.christmasGreen,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inviting member: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showLeaveGroupDialog(BuildContext context, String groupId, String userId, String groupName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            SizedBox(width: 12),
            Text('Leave Group'),
          ],
        ),
        content: Text(
          'Are you sure you want to leave "$groupName"? You can only leave before the Secret Santa starts.',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<GroupBloc>().add(
                    GroupLeaveRequested(
                      groupId: groupId,
                      userId: userId,
                    ),
                  );
              // Navigate back to home after leaving
              context.go('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  void _showStartConfirmationDialog(BuildContext context, String groupId, int memberCount) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.christmasRed),
            SizedBox(width: 12),
            Text('Start Secret Santa?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are about to start the Secret Santa with $memberCount members.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '⚠️ After starting:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text('• No more members can be invited'),
            const Text('• Members can start picking their Secret Santa'),
            const Text('• This action cannot be undone'),
            const SizedBox(height: 16),
            const Text(
              'Make sure all desired members have joined!',
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.christmasRed),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<GroupBloc>().add(GroupStartRequested(groupId: groupId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.christmasRed,
            ),
            child: const Text('Start Now'),
          ),
        ],
      ),
    );
  }

  void _cancelInvite(BuildContext context, String inviteId, String username) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            SizedBox(width: 12),
            Text('Cancel Invitation'),
          ],
        ),
        content: Text(
          'Are you sure you want to cancel the invitation for $username?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Delete the invite using InviteRepository
              InviteRepository().deleteInvite(inviteId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invitation cancelled'),
                  backgroundColor: AppColors.christmasGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _removeMember(BuildContext context, String groupId, String userId, String memberName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            SizedBox(width: 12),
            Text('Remove Member'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove $memberName from this group?',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<GroupBloc>().add(
                    GroupMemberRemoveRequested(
                      groupId: groupId,
                      userId: userId,
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$memberName removed from group'),
                  backgroundColor: AppColors.textSecondary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showGroupInfoDialog(BuildContext context, dynamic group, bool isOwner, String currentUserId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.christmasGreen),
            const SizedBox(width: 12),
            Text(isOwner ? 'Group Information' : 'Group Details'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogInfoRow('Group Name', group.name),
              const Divider(height: 20),
              _buildDialogInfoRow('Creator', group.ownerName),
              const Divider(height: 20),
              _buildDialogInfoRow('Created On', _formatDate(group.createdAt)),
              const Divider(height: 20),
              _buildDialogInfoRow('Status', group.status.toUpperCase()),
              if (group.description.isNotEmpty) ...[
                const Divider(height: 20),
                _buildDialogInfoRow('Description', group.description),
              ],
              if (group.location.isNotEmpty) ...[
                const Divider(height: 20),
                _buildDialogInfoRow('Location', group.location),
              ],
              if (group.budget.isNotEmpty) ...[
                const Divider(height: 20),
                _buildDialogInfoRow('Budget', group.budget),
              ],
              const Divider(height: 20),
              _buildDialogInfoRow(
                'Pick Deadline',
                group.informationalDeadline != null
                    ? _formatDate(group.informationalDeadline!)
                    : 'None',
              ),
              const Divider(height: 20),
              _buildDialogInfoRow('Reveal Date', _formatDate(group.revealDate)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          if (!isOwner && group.isPending) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showLeaveGroupDialog(context, group.id, currentUserId, group.name);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Leave Group'),
            ),
          ],
          if (isOwner) ...[
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.push('/group/${group.id}/edit');
              },
              child: const Text('Modify Details'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showDeleteGroupDialog(context, group.id, group.name);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Delete Group'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDialogInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showDeleteGroupDialog(BuildContext context, String groupId, String groupName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            SizedBox(width: 12),
            Text('Delete Group'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "$groupName"?\n\nThis action cannot be undone. All members will lose access to this group.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              // Delete the group using repository
              try {
                final groupRepo = GroupRepository();
                await groupRepo.deleteGroup(groupId);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$groupName deleted successfully'),
                    backgroundColor: AppColors.christmasGreen,
                  ),
                );

                // Navigate back to home
                context.go('/');
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting group: $e'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
