import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/data/repositories/group_repository.dart';
import 'package:klaussified/data/models/group_member_model.dart';

class RevealScreen extends StatefulWidget {
  final String groupId;

  const RevealScreen({
    super.key,
    required this.groupId,
  });

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  final GroupRepository _groupRepository = GroupRepository();

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is! AuthAuthenticated) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final user = (authBloc.state as AuthAuthenticated).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Secret Santa'),
        backgroundColor: AppColors.christmasGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/home'),
            tooltip: 'Go Home',
          ),
        ],
      ),
      body: StreamBuilder<List<GroupMemberModel>>(
        stream: _groupRepository.streamGroupMembers(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No members found'),
            );
          }

          // Find current user's member data
          final members = snapshot.data!;
          final currentMember = members.firstWhere(
            (m) => m.userId == user.uid,
            orElse: () => throw Exception('You are not a member of this group'),
          );

          if (currentMember.assignedToUserId == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No assignment yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'You haven\'t picked your Secret Santa yet!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/group/${widget.groupId}/pick');
                      },
                      child: const Text('Go to Pick'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Find assigned member
          final assignedMember = members.firstWhere(
            (m) => m.userId == currentMember.assignedToUserId,
            orElse: () => throw Exception('Assigned member not found'),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Celebration header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.christmasRed,
                        AppColors.christmasGreen,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.celebration,
                        size: 64,
                        color: AppColors.snowWhite,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'You\'re buying a gift for:',
                        style: TextStyle(
                          color: AppColors.snowWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        assignedMember.displayName.isNotEmpty
                            ? assignedMember.displayName
                            : assignedMember.username,
                        style: const TextStyle(
                          color: AppColors.snowWhite,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Profile Details Card
                if (assignedMember.profileDetails.isComplete) ...[
                  const Text(
                    'Gift Hints:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.christmasGreen,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Real Name
                  _buildDetailCard(
                    icon: Icons.person,
                    title: 'Name',
                    content: assignedMember.profileDetails.realName,
                  ),
                  const SizedBox(height: 16),

                  // Hobbies
                  _buildDetailCard(
                    icon: Icons.favorite,
                    title: 'Hobbies & Interests',
                    content: assignedMember.profileDetails.hobbies,
                  ),
                  const SizedBox(height: 16),

                  // Wishes
                  _buildDetailCard(
                    icon: Icons.card_giftcard,
                    title: 'Gift Wishes & Hints',
                    content: assignedMember.profileDetails.wishes,
                  ),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 48,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${assignedMember.displayName.isNotEmpty ? assignedMember.displayName : assignedMember.username} hasn\'t filled out their profile details yet.',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),

                // Reminder card
                Card(
                  color: AppColors.christmasRed.withValues(alpha: 0.1),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock,
                          color: AppColors.christmasRed,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Remember: Keep this a secret! Don\'t tell anyone who you\'re buying for.',
                            style: TextStyle(
                              color: AppColors.christmasRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.christmasGreen,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.christmasGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
