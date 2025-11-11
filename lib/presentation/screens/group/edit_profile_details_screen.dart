import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/business_logic/group/group_bloc.dart';
import 'package:klaussified/business_logic/group/group_event.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/data/repositories/group_repository.dart';
import 'package:klaussified/data/models/profile_details_model.dart';

class EditProfileDetailsScreen extends StatefulWidget {
  final String groupId;

  const EditProfileDetailsScreen({
    super.key,
    required this.groupId,
  });

  @override
  State<EditProfileDetailsScreen> createState() =>
      _EditProfileDetailsScreenState();
}

class _EditProfileDetailsScreenState extends State<EditProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _realNameController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _wishesController = TextEditingController();

  final GroupRepository _groupRepository = GroupRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentDetails();
  }

  @override
  void dispose() {
    _realNameController.dispose();
    _hobbiesController.dispose();
    _wishesController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentDetails() async {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is! AuthAuthenticated) return;

    final user = (authBloc.state as AuthAuthenticated).user;

    // IMPORTANT: Create local variable to avoid Flutter Web string interpolation bug
    final groupId = widget.groupId;

    try {
      // Get the member document directly from Firestore
      final memberDoc = await _groupRepository.getMemberDoc(groupId, user.uid);

      if (memberDoc != null && mounted) {
        setState(() {
          // IMPORTANT: Only use saved profile details from THIS group
          // Do NOT fall back to user.displayName - keep fields empty if not set
          _realNameController.text = memberDoc.profileDetails.realName;
          _hobbiesController.text = memberDoc.profileDetails.hobbies;
          _wishesController.text = memberDoc.profileDetails.wishes;
        });
      }
      // If member doc doesn't exist, leave all fields empty (don't set defaults)
    } catch (e) {
      // Error loading - leave fields empty
      // User can fill them in if needed
    }
  }

  Future<void> _saveDetails() async {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is! AuthAuthenticated) return;

    final user = (authBloc.state as AuthAuthenticated).user;
    final groupBloc = context.read<GroupBloc>();

    // IMPORTANT: Create local variable to avoid Flutter Web string interpolation bug
    final groupId = widget.groupId;

    setState(() => _isLoading = true);

    try {
      final profileDetails = ProfileDetailsModel(
        realName: _realNameController.text.trim(),
        hobbies: _hobbiesController.text.trim(),
        wishes: _wishesController.text.trim(),
      );

      // Save directly to repository to ensure it's persisted
      await _groupRepository.updateMemberProfileDetails(
        groupId: groupId,
        userId: user.uid,
        profileDetails: profileDetails,
      );

      // Also trigger the bloc event for state management
      groupBloc.add(
        GroupProfileDetailsUpdateRequested(
          groupId: groupId,
          userId: user.uid,
          profileDetails: profileDetails,
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile details saved successfully!'),
            backgroundColor: AppColors.christmasGreen,
          ),
        );
        if (mounted) {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving details: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile Details'),
        backgroundColor: AppColors.christmasGreen,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: AppColors.christmasRed,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Secret Santa Info',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'These details will only be visible to your Secret Santa to help them pick the perfect gift for you!',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Real Name Field
                  TextFormField(
                    controller: _realNameController,
                    decoration: const InputDecoration(
                      labelText: 'Real Name (Optional)',
                      hintText: 'Your full name',
                      prefixIcon: Icon(Icons.person),
                      helperText: 'So your Secret Santa knows who you are',
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 20),

                  // Hobbies Field
                  TextFormField(
                    controller: _hobbiesController,
                    minLines: 1,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      labelText: 'Hobbies & Interests (Optional)',
                      hintText: 'e.g., Reading, Cooking, Gaming, Sports...',
                      prefixIcon: Icon(Icons.favorite),
                      helperText: 'What do you enjoy doing?',
                      alignLabelWithHint: true,
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 20),

                  // Wishes Field
                  TextFormField(
                    controller: _wishesController,
                    minLines: 1,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      labelText: 'Gift Wishes & Hints (Optional)',
                      hintText: 'e.g., I love chocolate, prefer practical gifts, size M...',
                      prefixIcon: Icon(Icons.card_giftcard),
                      helperText: 'Help your Secret Santa with gift ideas',
                      alignLabelWithHint: true,
                    ),
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.christmasGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.snowWhite,
                              ),
                            ),
                          )
                        : const Text(
                            'Save Details',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
