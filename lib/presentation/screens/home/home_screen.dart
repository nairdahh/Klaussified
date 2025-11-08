import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_event.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/business_logic/group/group_bloc.dart';
import 'package:klaussified/business_logic/group/group_event.dart';
import 'package:klaussified/business_logic/group/group_state.dart' as group_states;
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/core/routes/route_names.dart';
import 'package:klaussified/data/models/group_model.dart';
import 'package:klaussified/data/repositories/invite_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load groups when screen initializes
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthAuthenticated) {
      final user = (authBloc.state as AuthAuthenticated).user;
      context.read<GroupBloc>().add(GroupLoadRequested(userId: user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = authState.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Klaussified'),
            actions: [
              StreamBuilder<List>(
                stream: InviteRepository().streamUserInvites(user.uid),
                builder: (context, snapshot) {
                  final inviteCount = snapshot.data?.length ?? 0;
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.mail_outline),
                        onPressed: () => context.push(RouteNames.invitations),
                        tooltip: 'Invitations',
                      ),
                      if (inviteCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.christmasRed,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              inviteCount > 9 ? '9+' : '$inviteCount',
                              style: const TextStyle(
                                color: AppColors.snowWhite,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                },
                tooltip: 'Logout',
              ),
            ],
          ),
          body: BlocBuilder<GroupBloc, group_states.GroupState>(
            builder: (context, groupState) {
              if (groupState is group_states.GroupLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (groupState is group_states.GroupError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                      const SizedBox(height: 16),
                      Text(groupState.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<GroupBloc>().add(GroupLoadRequested(userId: user.uid));
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (groupState is group_states.GroupsLoaded) {
                return DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        color: AppColors.backgroundWhite,
                        child: const TabBar(
                          tabs: [
                            Tab(text: 'Active Groups'),
                            Tab(text: 'Closed Groups'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Active Groups Tab
                            _buildGroupsList(groupState.activeGroups, isActive: true),

                            // Closed Groups Tab
                            _buildGroupsList(groupState.closedGroups, isActive: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.push(RouteNames.createGroup);
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Group'),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: AppColors.christmasRed,
                  ),
                  accountName: Text(
                    user.displayName.isNotEmpty
                        ? user.displayName
                        : user.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  accountEmail: Text(user.email),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: AppColors.snowWhite,
                    child: Text(
                      (user.displayName.isNotEmpty
                              ? user.displayName
                              : user.username)
                          .substring(0, 1)
                          .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.christmasRed,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile feature coming soon!'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings feature coming soon!'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupsList(List<GroupModel> groups, {required bool isActive}) {
    if (groups.isEmpty) {
      return _buildEmptyState(
        context,
        icon: isActive ? Icons.card_giftcard : Icons.inventory_2,
        title: isActive ? 'No Active Groups' : 'No Closed Groups',
        message: isActive
            ? 'Create or join a Secret Santa group to get started!'
            : 'Completed groups will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return _buildGroupCard(group);
      },
    );
  }

  Widget _buildGroupCard(GroupModel group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: group.isPending
              ? AppColors.christmasGreen
              : group.status == 'started'
                  ? AppColors.christmasRed
                  : AppColors.textSecondary,
          child: Icon(
            Icons.card_giftcard,
            color: AppColors.snowWhite,
          ),
        ),
        title: Text(
          group.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${group.pickedCount}/${group.memberCount} picked'),
            if (group.informationalDeadline != null)
              Text(
                'Deadline: ${_formatDate(group.informationalDeadline!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
        trailing: _buildStatusChip(group.status),
        onTap: () {
          context.push('/group/${group.id}');
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = AppColors.christmasGreen;
        label = 'Pending';
        break;
      case 'started':
        color = AppColors.christmasRed;
        label = 'Active';
        break;
      case 'closed':
        color = AppColors.textSecondary;
        label = 'Closed';
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.snowWhite,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
