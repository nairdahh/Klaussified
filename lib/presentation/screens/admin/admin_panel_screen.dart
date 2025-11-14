import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/core/constants/admin_constants.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/data/models/user_model.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  bool _isSendingEmail = false;
  String? _resultMessage;
  bool _isSuccess = false;

  // For manual email sending
  final TextEditingController _searchController = TextEditingController();
  String? _selectedUserId;
  UserModel? _selectedUser;
  List<UserModel> _searchResults = [];
  bool _isSearching = false;

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final queryLower = query.toLowerCase();
      final db = FirebaseFirestore.instance;

      // Search by username
      final usernameQuery = await db
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: queryLower)
          .where('username', isLessThan: '${queryLower}z')
          .limit(10)
          .get();

      final results = usernameQuery.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();

      // Also search by email if no results
      if (results.isEmpty) {
        final emailQuery = await db
            .collection('users')
            .where('email', isGreaterThanOrEqualTo: queryLower)
            .where('email', isLessThan: '${queryLower}z')
            .limit(10)
            .get();

        results.addAll(emailQuery.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList());
      }

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = [];
        });
      }
    }
  }

  Future<void> _enableNotificationsForAll() async {
    setState(() {
      _isSendingEmail = true;
      _resultMessage = null;
    });

    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('enableNotificationsForAllUsers')
          .call();

      if (mounted) {
        setState(() {
          _isSendingEmail = false;
          _isSuccess = true;
          _resultMessage = result.data['message'] ?? 'Migration completed successfully';
        });

        // Show success snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_resultMessage ?? 'Migration completed'),
              backgroundColor: AppColors.christmasGreen,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSendingEmail = false;
          _isSuccess = false;
          _resultMessage = 'Error: ${e.toString()}';
        });

        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_resultMessage ?? 'Migration failed'),
            backgroundColor: AppColors.christmasRed,
          ),
        );
      }
    }
  }

  Future<void> _sendWelcomeEmailToUser(String userId) async {
    if (_selectedUser == null) return;

    setState(() {
      _isSendingEmail = true;
      _resultMessage = null;
    });

    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('sendWelcomeEmailToUser')
          .call({'targetUserId': userId});

      if (mounted) {
        setState(() {
          _isSendingEmail = false;
          _isSuccess = true;
          _resultMessage = result.data['message'] ?? 'Email sent successfully!';
          // Reset selection after successful send
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _searchController.clear();
                _selectedUserId = null;
                _selectedUser = null;
                _searchResults = [];
              });
            }
          });
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSendingEmail = false;
          _isSuccess = false;
          _resultMessage = 'Error: ${e.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade900
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppColors.textPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : AppColors.backgroundWhite,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : AppColors.textPrimary,
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Verify admin access
          if (state is! AuthAuthenticated) {
            return const Center(
              child: Text(
                'Unauthorized access',
                style: TextStyle(color: AppColors.error),
              ),
            );
          }

          final isAdmin = AdminConstants.isAdmin(
            state.user.uid,
            state.user.email,
          );

          if (!isAdmin) {
            return const Center(
              child: Text(
                'Unauthorized access',
                style: TextStyle(color: AppColors.error),
              ),
            );
          }

          // Admin panel content
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Welcome section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Admin!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'User ID: ${state.user.uid}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade300
                              : AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Email: ${state.user.email}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade300
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Statistics section
                Text(
                  'Platform Statistics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, usersSnapshot) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('groups').snapshots(),
                      builder: (context, groupsSnapshot) {
                        final userCount = usersSnapshot.hasData ? usersSnapshot.data!.docs.length : 0;
                        final groupCount = groupsSnapshot.hasData ? groupsSnapshot.data!.docs.length : 0;

                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade800
                                      : AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.people,
                                      size: 40,
                                      color: AppColors.christmasRed,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '$userCount',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Registered Users',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey.shade300
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade800
                                      : AppColors.cardBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.groups,
                                      size: 40,
                                      color: AppColors.christmasGreen,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '$groupCount',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Groups Created',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey.shade300
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Email management section
                Text(
                  'Email Management',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),

                // Enable notifications for all users migration
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Enable Notifications for All Users',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'One-time migration to enable email notifications for all existing users.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade300
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isSendingEmail ? null : _enableNotificationsForAll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.christmasGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: _isSendingEmail
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Enable Notifications for All',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Send email to user section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Send Welcome Email to User',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Search for a user and send them a welcome email manually.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade300
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Search field
                      TextField(
                        controller: _searchController,
                        enabled: _selectedUser == null || _resultMessage == null,
                        onChanged: _searchUsers,
                        decoration: InputDecoration(
                          hintText: 'Search by username or email...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),

                      // Search results dropdown
                      if (_searchResults.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.christmasRed,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final user = _searchResults[index];
                              return ListTile(
                                title: Text(user.displayName ?? user.username),
                                subtitle: Text(user.email),
                                selected: _selectedUserId == user.uid,
                                onTap: () {
                                  setState(() {
                                    _selectedUserId = user.uid;
                                    _selectedUser = user;
                                    _searchResults = [];
                                    _searchController.clear();
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],

                      // Selected user info
                      if (_selectedUser != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.christmasGreen.withValues(
                              alpha: Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.christmasGreen,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected User:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade300
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedUser!.displayName ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedUser!.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade300
                                      : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '@${_selectedUser!.username}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade300
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isSendingEmail
                                    ? null
                                    : () =>
                                        _sendWelcomeEmailToUser(_selectedUser!.uid),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.christmasRed,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isSendingEmail
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Send Email',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _isSendingEmail
                                  ? null
                                  : () {
                                      setState(() {
                                        _selectedUserId = null;
                                        _selectedUser = null;
                                        _searchResults = [];
                                        _searchController.clear();
                                        _resultMessage = null;
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.textSecondary.withValues(
                                      alpha: 0.2,
                                    ),
                                foregroundColor: AppColors.textPrimary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Result message for user email
                      if (_resultMessage != null && _selectedUser != null) ...[
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (_isSuccess
                                ? AppColors.success
                                : AppColors.error).withValues(
                              alpha: Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isSuccess
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _isSuccess ? Icons.check_circle : Icons.error,
                                color: _isSuccess
                                    ? AppColors.success
                                    : AppColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _resultMessage!,
                                  style: TextStyle(
                                    color: _isSuccess
                                        ? AppColors.success
                                        : AppColors.error,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
