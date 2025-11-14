import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/core/utils/snackbar_helper.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _populateEmailFromAuthBloc();
  }

  void _populateEmailFromAuthBloc() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _emailController.text = authState.user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('sendContactForm')
          .call({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'message': _messageController.text.trim(),
      });

      if (mounted) {
        SnackBarHelper.showSuccess(
          context,
          message: result.data['message'] ?? 'Message sent successfully!',
        );

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();

        // Also clear email if user is not authenticated
        final authState = context.read<AuthBloc>().state;
        if (authState is! AuthAuthenticated) {
          _emailController.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(
          context,
          message: 'Failed to send message. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    )) {
      if (mounted) {
        SnackBarHelper.showError(
          context,
          message: 'Could not open $url',
        );
      }
    }
  }

  Widget _buildWorkflowStep(
    BuildContext context,
    String number,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.christmasGreen,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: AppColors.snowWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Klaussified'),
        backgroundColor: AppColors.christmasGreen,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App icon and name
                const Icon(
                  Icons.card_giftcard,
                  size: 80,
                  color: AppColors.christmasRed,
                ),
                const SizedBox(height: 16),
                Text(
                  'Klaussified',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.christmasRed,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Secret Santa Made Easy',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Platform Statistics
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
                                padding: const EdgeInsets.all(16),
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
                                      size: 32,
                                      color: AppColors.christmasRed,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '$userCount',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Users',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey.shade300
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
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
                                      size: 32,
                                      color: AppColors.christmasGreen,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '$groupCount',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Groups',
                                      style: TextStyle(
                                        fontSize: 12,
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
                const SizedBox(height: 32),

                // Creator info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: AppColors.christmasGreen,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Created by ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            _HoverableLink(
                              onTap: () =>
                                  _launchUrl('https://github.com/nairdahh'),
                              text: 'nairdah',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Klaussified is developed and maintained by a solo developer. '
                          'Every feature, bug fix, and improvement is crafted with care. '
                          'Your support and feedback help make this app better!',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade300
                                        : AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // How Klaussified Works card
                Card(
                  color: AppColors.christmasGreen.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark
                        ? 0.25
                        : 0.05,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.christmasGreen,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'How Klaussified Works',
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
                        Text(
                          'Klaussified makes organizing Secret Santa gift exchanges simple and stress-free!',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        _buildWorkflowStep(
                          context,
                          '1',
                          'Create a Group',
                          'Set up your Secret Santa group with a name, budget, and exchange date. Customize it to fit your event!',
                        ),
                        _buildWorkflowStep(
                          context,
                          '2',
                          'Invite Participants',
                          'Send email invitations to your friends, family, or colleagues. They\'ll receive a link to join your group.',
                        ),
                        _buildWorkflowStep(
                          context,
                          '3',
                          'Start the Draw',
                          'Once everyone has joined, initiate the draw. Our algorithm ensures fair and random assignments.',
                        ),
                        _buildWorkflowStep(
                          context,
                          '4',
                          'Reveal Your Match',
                          'Each participant can reveal who they\'re buying for. Check their wishlist and gift preferences to find the perfect present!',
                        ),
                        _buildWorkflowStep(
                          context,
                          '5',
                          'Exchange Gifts',
                          'Meet up on the exchange date and enjoy the surprise! Everyone gets a gift, and the joy of giving is shared.',
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          'Key Features',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        ...[
                          '🎁 Random assignment algorithm (nobody gets themselves)',
                          '📧 Email invitations and notifications',
                          '📝 Wishlist and gift preferences for each participant',
                          '💰 Budget setting to keep spending fair',
                          '📅 Deadline reminders so nobody forgets',
                          '🔒 Secure and private - only you can see your match',
                          '🌐 Works on web, mobile, and tablet',
                          '✨ Completely free to use!',
                        ].map((feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                feature,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.grey.shade300
                                          : AppColors.textSecondary,
                                    ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Support card
                Card(
                  color: AppColors.christmasRed.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark
                        ? 0.25
                        : 0.1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.coffee,
                              color: AppColors.christmasRed,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Support Development',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'If you enjoy using Klaussified, consider supporting its development. '
                          'Every donation helps keep the app running and motivates continued improvements!',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade300
                                        : AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _launchUrl('https://ko-fi.com/nairdah'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.christmasRed,
                            foregroundColor: AppColors.snowWhite,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                          ),
                          icon: Icon(Icons.coffee),
                          label: Text('Buy me a coffee'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Contact/Feedback card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.bug_report,
                              color: AppColors.christmasGreen,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Feedback & Bug Reports',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Found a bug or have a feature idea? Your feedback is invaluable! '
                          'Please report issues or share suggestions using the form below.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade300
                                        : AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 20),

                        // Contact form
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Your Name',
                                  prefixIcon: Icon(Icons.person_outline),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                enabled: !_isSending,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Your Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                enabled: !_isSending,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _messageController,
                                minLines: 1,
                                maxLines: 7,
                                decoration: InputDecoration(
                                  labelText: 'Message',
                                  hintText:
                                      'Describe your bug or feature request...',
                                  prefixIcon: Icon(Icons.message_outlined),
                                  alignLabelWithHint: true,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your message';
                                  }
                                  return null;
                                },
                                enabled: !_isSending,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _isSending ? null : _sendEmail,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: _isSending
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Text('Send Message'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Or email directly: hello@klaussified.com',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade300
                                        : AppColors.textSecondary,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Known Bugs card
                Card(
                  color: Colors.orange.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Known Bugs',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade300
                                        : AppColors.textSecondary,
                                  ),
                            ),
                            Expanded(
                              child: Text(
                                'The slot machine wheel sometimes doesn\'t stop exactly on a name visually, but lands between two names. However, the pick selection is correct - this is only a visual bug.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.grey.shade300
                                          : AppColors.textSecondary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Future Updates card
                Card(
                  color: AppColors.christmasGreen.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.upcoming,
                              color: AppColors.christmasGreen,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Future Updates (Planned)',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...[
                          'Email configuration for account creation/group invitations/deadline notifications',
                          'More advanced settings',
                          'Advanced user profile with more details',
                        ].map((feature) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '• ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey.shade300
                                              : AppColors.textSecondary,
                                        ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.grey.shade300
                                                : AppColors.textSecondary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverableLink extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const _HoverableLink({
    required this.onTap,
    required this.text,
  });

  @override
  State<_HoverableLink> createState() => _HoverableLinkState();
}

class _HoverableLinkState extends State<_HoverableLink> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _isHovering
                ? AppColors.christmasGreen.withValues(
                    alpha: Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.1,
                  )
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            widget.text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.christmasGreen,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
