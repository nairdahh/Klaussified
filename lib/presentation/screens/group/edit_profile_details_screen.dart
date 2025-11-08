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
  State<EditProfileDetailsScreen> createState() => _EditProfileDetailsScreenState();
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

    try {
      final member = await _groupRepository
          .streamGroupMembers(widget.groupId)
          .firstWhere((members) => members.any((m) => m.userId == user.uid))
          .then((members) => members.firstWhere((m) => m.userId == user.uid));

      if (mounted) {
        setState(() {
          _realNameController.text = member.profileDetails.realName;
          _hobbiesController.text = member.profileDetails.hobbies;
          _wishesController.text = member.profileDetails.wishes;
        });
      }
    } catch (e) {
      // Member not found or error loading
    }
  }

  Future<void> _saveDetails() async {
    if (!_formKey.currentState!.validate()) return;

    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is! AuthAuthenticated) return;

    final user = (authBloc.state as AuthAuthenticated).user;

    setState(() => _isLoading = true);

    try {
      final profileDetails = ProfileDetailsModel(
        realName: _realNameController.text.trim(),
        hobbies: _hobbiesController.text.trim(),
        wishes: _wishesController.text.trim(),
      );

      context.read<GroupBloc>().add(
            GroupProfileDetailsUpdateRequested(
              groupId: widget.groupId,
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
        context.pop();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
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
                          Text(
                            'Secret Santa Info',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
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
                  labelText: 'Real Name *',
                  hintText: 'Your full name',
                  prefixIcon: Icon(Icons.person),
                  helperText: 'So your Secret Santa knows who you are',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your real name';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 20),

              // Hobbies Field
              TextFormField(
                controller: _hobbiesController,
                decoration: const InputDecoration(
                  labelText: 'Hobbies & Interests *',
                  hintText: 'e.g., Reading, Cooking, Gaming, Sports...',
                  prefixIcon: Icon(Icons.favorite),
                  helperText: 'What do you enjoy doing?',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please share your hobbies and interests';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 20),

              // Wishes Field
              TextFormField(
                controller: _wishesController,
                decoration: const InputDecoration(
                  labelText: 'Gift Wishes & Hints *',
                  hintText: 'e.g., I love chocolate, prefer practical gifts, size M...',
                  prefixIcon: Icon(Icons.card_giftcard),
                  helperText: 'Help your Secret Santa with gift ideas',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please provide some gift hints';
                  }
                  return null;
                },
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
    );
  }
}
