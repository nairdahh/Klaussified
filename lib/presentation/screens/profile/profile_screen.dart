import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_event.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/core/constants/constants.dart';
import 'package:klaussified/data/repositories/user_repository.dart';
import 'package:klaussified/data/services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();

  final UserRepository _userRepository = UserRepository();
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isLoading = false;
  bool _isUploadingImage = false;
  String _currentPhotoURL = '';
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthAuthenticated) {
      final user = (authBloc.state as AuthAuthenticated).user;
      setState(() {
        _usernameController.text = user.username;
        _displayNameController.text = user.displayName;
        _currentPhotoURL = user.photoURL;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _uploadImage(String userId) async {
    if (_selectedImageBytes == null) return;

    setState(() => _isUploadingImage = true);

    try {
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final photoURL = await _storageService.uploadUserAvatar(
        userId: userId,
        fileBytes: _selectedImageBytes!,
        fileName: fileName,
      );

      // Delete old avatar if exists
      if (_currentPhotoURL.isNotEmpty) {
        await _storageService.deleteUserAvatar(_currentPhotoURL);
      }

      setState(() {
        _currentPhotoURL = photoURL;
        _selectedImageBytes = null;
        _isUploadingImage = false;
      });

      return;
    } catch (e) {
      setState(() => _isUploadingImage = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      rethrow;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is! AuthAuthenticated) return;

    final user = (authBloc.state as AuthAuthenticated).user;

    setState(() => _isLoading = true);

    try {
      // Upload image first if selected
      if (_selectedImageBytes != null) {
        await _uploadImage(user.uid);
      }

      // Check if username is being changed and if it's available
      final newUsername = _usernameController.text.trim().toLowerCase();
      if (newUsername != user.username) {
        final usernameExists =
            await _userRepository.usernameExists(newUsername);
        if (usernameExists) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Username already taken'),
                backgroundColor: AppColors.error,
              ),
            );
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      // Update profile
      await _userRepository.updateProfile(
        userId: user.uid,
        username: newUsername != user.username ? newUsername : null,
        displayName: _displayNameController.text.trim() != user.displayName
            ? _displayNameController.text.trim()
            : null,
        photoURL: _currentPhotoURL != user.photoURL ? _currentPhotoURL : null,
      );

      if (mounted) {
        // Refresh auth state
        context.read<AuthBloc>().add(const AuthCheckRequested());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppColors.christmasGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
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
    final authBloc = context.watch<AuthBloc>();
    final user = authBloc.state is AuthAuthenticated
        ? (authBloc.state as AuthAuthenticated).user
        : null;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.christmasGreen,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Avatar Section
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundColor:
                              AppColors.christmasGreen.withValues(alpha: 0.2),
                          backgroundImage: _selectedImageBytes != null
                              ? MemoryImage(_selectedImageBytes!)
                              : (_currentPhotoURL.isNotEmpty
                                  ? NetworkImage(_currentPhotoURL)
                                  : null) as ImageProvider?,
                          child: _selectedImageBytes == null &&
                                  _currentPhotoURL.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 64,
                                  color: AppColors.christmasGreen,
                                )
                              : null,
                        ),
                        if (_isUploadingImage)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.snowWhite,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: AppColors.christmasGreen,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: AppColors.snowWhite,
                              ),
                              onPressed: _isLoading || _isUploadingImage
                                  ? null
                                  : _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Tap camera to change avatar',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Username Field
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      helperText:
                          'Letters, numbers, dots, and underscores',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      if (value.length < AppConstants.minUsernameLength) {
                        return 'Username must be at least ${AppConstants.minUsernameLength} characters';
                      }
                      if (value.length > AppConstants.maxUsernameLength) {
                        return 'Username must be less than ${AppConstants.maxUsernameLength} characters';
                      }
                      if (!AppConstants.usernameRegex.hasMatch(value)) {
                        return 'It can only contain letters, numbers, dots, and underscores';
                      }
                      return null;
                    },
                    enabled: !_isLoading && !_isUploadingImage,
                    onChanged: (value) {
                      // Auto-convert to lowercase
                      final lowercase = value.toLowerCase();
                      if (value != lowercase) {
                        _usernameController.value =
                            _usernameController.value.copyWith(
                          text: lowercase,
                          selection:
                              TextSelection.collapsed(offset: lowercase.length),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Real Name Field
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'Real Name (Optional)',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    enabled: !_isLoading && !_isUploadingImage,
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton(
                    onPressed:
                        _isLoading || _isUploadingImage ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.christmasGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading || _isUploadingImage
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
                            'Save Changes',
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
