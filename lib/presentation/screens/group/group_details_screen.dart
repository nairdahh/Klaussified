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
import 'package:klaussified/data/models/group_member_model.dart';

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
              GroupMemberModel? currentMember;
              try {
                currentMember = members.firstWhere((m) => m.userId == currentUserId);
              } catch (e) {
                // Member not found, currentMember remains null
              }

              return Column(
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
                            _buildInfoRow(Icons.people, 'Members', '${group.memberCount}'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.check_circle, 'Picked', '${group.pickedCount}/${group.memberCount}'),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Invite Members Button (always visible for pending groups)
                        if (group.isPending)
                          SizedBox(
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
                        const SizedBox(height: 12),

                        // Start Button (only for owner with 3+ members)
                        if (group.isPending && isOwner && group.memberCount >= 3)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<GroupBloc>().add(GroupStartRequested(groupId: groupId));
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Secret Santa'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.christmasRed,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Pick/Reveal/Edit Buttons
                  if (currentMember != null && group.isStarted && !currentMember.hasPicked)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () => context.push('/group/$groupId/pick'),
                        child: const Text('Pick Your Secret Santa'),
                      ),
                    ),
                  if (currentMember != null && currentMember.hasPicked && currentMember.assignedToUserId != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () => context.push('/group/$groupId/reveal'),
                        child: const Text('View Your Assignment'),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () => context.push('/group/$groupId/edit-details'),
                      child: const Text('Edit My Profile Details'),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
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
                              child: Text(
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
                                : (member.hasPicked
                                    ? const Icon(Icons.check_circle, color: AppColors.christmasGreen)
                                    : Icon(Icons.pending, color: AppColors.textSecondary.withValues(alpha: 0.5))),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
}
