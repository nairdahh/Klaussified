import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_event.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/business_logic/theme/theme_bloc.dart';
import 'package:klaussified/business_logic/theme/theme_event.dart';
import 'package:klaussified/business_logic/theme/theme_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isChangingEmail = false;
  bool _isChangingPassword = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newEmailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changeEmail() async {
    if (!_emailFormKey.currentState!.validate()) return;

    setState(() => _isChangingEmail = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await user.verifyBeforeUpdateEmail(_newEmailController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification email sent to ${_newEmailController.text}. Please check your inbox.',
            ),
            backgroundColor: AppColors.christmasGreen,
            duration: const Duration(seconds: 5),
          ),
        );
        _newEmailController.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'Failed to change email';
        if (e.code == 'requires-recent-login') {
          message = 'Please log out and log back in before changing your email';
        } else if (e.code == 'email-already-in-use') {
          message = 'This email is already in use';
        } else if (e.code == 'invalid-email') {
          message = 'Invalid email address';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isChangingEmail = false);
      }
    }
  }

  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() => _isChangingPassword = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        throw Exception('User not authenticated');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(_newPasswordController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: AppColors.christmasGreen,
          ),
        );
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'Failed to change password';
        if (e.code == 'wrong-password') {
          message = 'Current password is incorrect';
        } else if (e.code == 'weak-password') {
          message = 'New password is too weak';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isChangingPassword = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.christmasRed,
        foregroundColor: AppColors.snowWhite,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(child: Text('Please log in'));
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Information',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text('Email'),
                          subtitle: Text(state.user.email),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Username'),
                          subtitle: Text(state.user.username),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _emailFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email_outlined,
                                  color: AppColors.christmasRed),
                              const SizedBox(width: 12),
                              Text(
                                'Change Email',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _newEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'New Email',
                              hintText: 'Enter your new email address',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              if (value.trim() == state.user.email) {
                                return 'This is your current email';
                              }
                              return null;
                            },
                            enabled: !_isChangingEmail,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isChangingEmail ? null : _changeEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.christmasRed,
                                foregroundColor: AppColors.snowWhite,
                              ),
                              child: _isChangingEmail
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.snowWhite),
                                      ),
                                    )
                                  : const Text('Send Verification Email'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A verification link will be sent to your new email address. '
                            'Your email will be updated after you verify it.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _passwordFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lock_outline,
                                  color: AppColors.christmasRed),
                              const SizedBox(width: 12),
                              Text(
                                'Change Password',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _currentPasswordController,
                            obscureText: _obscureCurrentPassword,
                            decoration: InputDecoration(
                              labelText: 'Current Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureCurrentPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscureCurrentPassword =
                                        !_obscureCurrentPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your current password';
                              }
                              return null;
                            },
                            enabled: !_isChangingPassword,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: _obscureNewPassword,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureNewPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a new password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            enabled: !_isChangingPassword,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm New Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your new password';
                              }
                              if (value != _newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            enabled: !_isChangingPassword,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isChangingPassword
                                  ? null
                                  : _changePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.christmasRed,
                                foregroundColor: AppColors.snowWhite,
                              ),
                              child: _isChangingPassword
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.snowWhite),
                                      ),
                                    )
                                  : const Text('Change Password'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Theme/Appearance Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.palette,
                                color: AppColors.christmasGreen),
                            const SizedBox(width: 12),
                            Text(
                              'Appearance',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, themeState) {
                            return Column(
                              children: [
                                SwitchListTile(
                                  title: const Text('Dark Mode'),
                                  subtitle: Text(
                                      themeState.isDark ? 'Enabled' : 'Disabled'),
                                  value: themeState.isDark,
                                  onChanged: (value) {
                                    context
                                        .read<ThemeBloc>()
                                        .add(const ThemeToggleRequested());
                                  },
                                  activeColor: AppColors.christmasGreen,
                                  secondary: Icon(
                                    themeState.isDark
                                        ? Icons.dark_mode
                                        : Icons.light_mode,
                                    color: AppColors.christmasGreen,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ListTile(
                                  leading: const Icon(Icons.brush,
                                      color: AppColors.christmasGreen,
                                      size: 24),
                                  title: const Text('Theme',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  trailing: DropdownButton<ThemeVariant>(
                                    value: themeState.variant,
                                    onChanged: (ThemeVariant? newValue) {
                                      if (newValue != null) {
                                        context
                                            .read<ThemeBloc>()
                                            .add(ThemeVariantChanged(
                                                variant: newValue));
                                      }
                                    },
                                    items: ThemeVariant.values
                                        .map((variant) {
                                      return DropdownMenuItem(
                                        value: variant,
                                        child: Text(
                                          variant.name[0].toUpperCase() +
                                              variant.name.substring(1),
                                        ),
                                      );
                                    }).toList(),
                                    underline: Container(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Notifications Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.notifications,
                                color: AppColors.christmasGreen),
                            const SizedBox(width: 12),
                            Text(
                              'Notifications',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Email Notifications
                        Text(
                          'Email Notifications',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          title: const Text('All Email Notifications'),
                          subtitle: const Text(
                              'Receive all email notifications from Klaussified'),
                          value: state.user.emailNotificationsEnabled,
                          onChanged: (value) async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(state.user.uid)
                                  .update({
                                'emailNotificationsEnabled': value,
                                'emailInviteNotifications': value,
                                'emailDeadlineNotifications': value,
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Email preferences updated'),
                                    backgroundColor: AppColors.christmasGreen,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                          activeColor: AppColors.christmasGreen,
                        ),
                        SwitchListTile(
                          title: const Text('Invitation Emails'),
                          subtitle: const Text(
                              'Get notified when invited to Secret Santa groups'),
                          value: state.user.emailInviteNotifications,
                          onChanged: (value) async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(state.user.uid)
                                  .update({'emailInviteNotifications': value});
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Email preferences updated'),
                                    backgroundColor: AppColors.christmasGreen,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                          activeColor: AppColors.christmasGreen,
                        ),
                        SwitchListTile(
                          title: const Text('Deadline Reminders'),
                          subtitle: const Text(
                              'Get reminded about upcoming Secret Santa deadlines'),
                          value: state.user.emailDeadlineNotifications,
                          onChanged: (value) async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(state.user.uid)
                                  .update({'emailDeadlineNotifications': value});
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Email preferences updated'),
                                    backgroundColor: AppColors.christmasGreen,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                          activeColor: AppColors.christmasGreen,
                        ),
                        const Divider(height: 32),
                        // Browser Notifications (Placeholder)
                        Text(
                          'Browser Notifications',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          title: const Text('All Browser Notifications'),
                          subtitle: const Text(
                              'Receive in-app notifications (coming soon)'),
                          value: state.user.browserNotificationsEnabled,
                          onChanged: null, // Disabled for now
                          activeColor: AppColors.christmasGreen,
                        ),
                        SwitchListTile(
                          title: const Text('Invitation Notifications'),
                          subtitle: const Text(
                              'In-app alerts for group invitations (coming soon)'),
                          value: state.user.browserInviteNotifications,
                          onChanged: null, // Disabled for now
                          activeColor: AppColors.christmasGreen,
                        ),
                        SwitchListTile(
                          title: const Text('Deadline Notifications'),
                          subtitle: const Text(
                              'In-app reminders for deadlines (coming soon)'),
                          value: state.user.browserDeadlineNotifications,
                          onChanged: null, // Disabled for now
                          activeColor: AppColors.christmasGreen,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.logout,
                                color: AppColors.christmasRed),
                            const SizedBox(width: 12),
                            Text(
                              'Account Actions',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthLogoutRequested());
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.christmasRed,
                              side: const BorderSide(
                                  color: AppColors.christmasRed),
                            ),
                            icon: const Icon(Icons.logout),
                            label: const Text('Log Out'),
                          ),
                        ),
                      ],
                    ),
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
