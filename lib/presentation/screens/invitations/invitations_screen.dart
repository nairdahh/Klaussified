import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/business_logic/group/group_bloc.dart';
import 'package:klaussified/business_logic/group/group_event.dart';
import 'package:klaussified/business_logic/group/group_state.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/data/repositories/invite_repository.dart';
import 'package:klaussified/data/models/invite_model.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final currentUserId = (authState as AuthAuthenticated).user.uid;
    final inviteRepo = InviteRepository();

    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is GroupOperationSuccess) {
          // Success message already shown in _acceptInvite/_declineInvite
        } else if (state is GroupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Invitations'),
          backgroundColor: AppColors.christmasGreen,
        ),
        body: StreamBuilder<List<InviteModel>>(
          stream: inviteRepo.streamUserInvites(currentUserId),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Error loading invitations: ${snapshot.error}'),
                ],
              ),
            );
          }

          final invites = snapshot.data ?? [];

          if (invites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 64,
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No pending invitations',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'When someone invites you to a group,\nit will appear here',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: invites.length,
            itemExtent: 180.0, // Approximate height of invitation card for better scrolling performance
            itemBuilder: (context, index) {
              final invite = invites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.christmasGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.card_giftcard,
                              color: AppColors.christmasGreen,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  invite.groupName,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.christmasGreen,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Invited by ${invite.invitedByName}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(invite.createdAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _declineInvite(context, invite.id),
                              icon: const Icon(Icons.close),
                              label: const Text('Decline'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _acceptInvite(
                                context,
                                invite,
                                currentUserId,
                                authState.user.displayName,
                                authState.user.username,
                              ),
                              icon: const Icon(Icons.check),
                              label: const Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.christmasGreen,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _acceptInvite(
    BuildContext context,
    InviteModel invite,
    String userId,
    String displayName,
    String username,
  ) {
    // Capture the navigator before async operations
    final navigator = GoRouter.of(context);
    final messenger = ScaffoldMessenger.of(context);

    context.read<GroupBloc>().add(
          GroupInviteAcceptRequested(
            inviteId: invite.id,
            groupId: invite.groupId,
            userId: userId,
            displayName: displayName,
            username: username,
          ),
        );

    messenger.showSnackBar(
      SnackBar(
        content: Text('Joined ${invite.groupName}!'),
        backgroundColor: AppColors.christmasGreen,
        action: SnackBarAction(
          label: 'VIEW',
          textColor: AppColors.snowWhite,
          onPressed: () => navigator.push('/group/${invite.groupId}'),
        ),
      ),
    );
  }

  void _declineInvite(BuildContext context, String inviteId) {
    context.read<GroupBloc>().add(
          GroupInviteDeclineRequested(inviteId: inviteId),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invitation declined'),
        backgroundColor: AppColors.textSecondary,
      ),
    );
  }
}
