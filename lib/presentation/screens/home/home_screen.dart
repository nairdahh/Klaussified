import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_event.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/core/routes/route_names.dart';
import 'package:klaussified/core/constants/admin_constants.dart';
import 'package:klaussified/core/utils/snackbar_helper.dart';
import 'package:klaussified/data/models/group_model.dart';
import 'package:klaussified/data/repositories/invite_repository.dart';
import 'package:klaussified/data/repositories/group_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GroupRepository _groupRepository;
  late final InviteRepository _inviteRepository;

  @override
  void initState() {
    super.initState();
    _groupRepository = GroupRepository();
    _inviteRepository = InviteRepository();
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
            title: const _AnimatedLogo(),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: StreamBuilder<List>(
                  stream: _inviteRepository.streamUserInvites(user.uid),
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
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppColors.christmasGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          body: StreamBuilder<List<GroupModel>>(
            stream: _groupRepository.streamUserGroups(user.uid),
            builder: (context, activeSnapshot) {
              return StreamBuilder<List<GroupModel>>(
                stream: _groupRepository.streamClosedGroups(user.uid),
                builder: (context, closedSnapshot) {
                  if (activeSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      closedSnapshot.connectionState ==
                          ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (activeSnapshot.hasError || closedSnapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 64, color: AppColors.error),
                          const SizedBox(height: 16),
                          Text(
                              'Error loading groups: ${activeSnapshot.error ?? closedSnapshot.error}'),
                        ],
                      ),
                    );
                  }

                  final activeGroups = activeSnapshot.data ?? [];
                  final closedGroups = closedSnapshot.data ?? [];

                  return DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(4),
                              child: TabBar(
                                indicator: BoxDecoration(
                                  color: AppColors.christmasGreen,
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                indicatorPadding: EdgeInsets.zero,
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                labelColor: AppColors.snowWhite,
                                unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                tabs: const [
                                  Tab(text: 'Active Groups'),
                                  Tab(text: 'Closed Groups'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Active Groups Tab
                              _buildGroupsList(activeGroups, isActive: true),

                              // Closed Groups Tab
                              _buildGroupsList(closedGroups, isActive: false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
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
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: AppColors.christmasRed,
                  ),
                  accountName: user.displayName.isNotEmpty
                      ? Text(
                          user.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      : Text(
                          user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                  accountEmail: user.displayName.isNotEmpty
                      ? Text(
                          '@${user.username}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        )
                      : null,
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: AppColors.snowWhite,
                    child: user.photoURL.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: user.photoURL,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const SizedBox(
                                width: 24,
                                height: 24,
                                child: Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (context, url, error) {
                                return Text(
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
                                );
                              },
                            ),
                          )
                        : Text(
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
                    context.push('/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/settings');
                  },
                ),
                if (AdminConstants.isAdmin(user.uid, user.email))
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: const Text('Admin Panel'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push(RouteNames.admin);
                    },
                  ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      context.read<AuthBloc>().add(const AuthLogoutRequested());
                    },
                  ),
                ),
                const Divider(height: 1),

                // Spacer to push buttons to bottom
                const Spacer(),

                // About Klaussified Button
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/about');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.christmasGreen,
                        foregroundColor: AppColors.snowWhite,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.info_outline),
                      label: const Text('About Klaussified'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final Uri url = Uri.parse('https://ko-fi.com/nairdah');
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                          webOnlyWindowName: '_blank',
                        )) {
                          if (context.mounted) {
                            SnackBarHelper.showError(
                              context,
                              message: 'Could not open link',
                            );
                          }
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.christmasRed,
                        foregroundColor: AppColors.snowWhite,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 2,
                      ),
                      icon: Icon(Icons.coffee),
                      label: Text('Buy me a coffee'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];
            return _buildGroupCard(group);
          },
        ),
      ),
    );
  }

  Widget _buildGroupCard(GroupModel group) {
    return StreamBuilder<List>(
      stream: GroupRepository().streamGroupMembers(group.id),
      builder: (context, membersSnapshot) {
        final members = membersSnapshot.data ?? [];
        final memberCount = members.length;
        final pickedCount = members.where((m) => m.hasPicked).length;

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
                Text(
                  group.isPending
                      ? '$memberCount ${memberCount == 1 ? 'member' : 'members'}'
                      : '$pickedCount/$memberCount picked',
                ),
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
      },
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
      side: BorderSide.none,
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

// Animated Logo Widget with hover effect
class _AnimatedLogo extends StatefulWidget {
  const _AnimatedLogo();

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.snowWhite,
              fontWeight: FontWeight.bold,
              letterSpacing: _isHovering ? 3.0 : 0.0,
            ),
        child: const Text('Klaussified'),
      ),
    );
  }
}
