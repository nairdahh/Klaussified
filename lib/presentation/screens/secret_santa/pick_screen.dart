import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/business_logic/auth/auth_bloc.dart';
import 'package:klaussified/business_logic/auth/auth_state.dart';
import 'package:klaussified/business_logic/group/group_bloc.dart';
import 'package:klaussified/business_logic/group/group_event.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/data/repositories/group_repository.dart';
import 'package:klaussified/data/models/group_member_model.dart';
import 'package:klaussified/presentation/widgets/animations/vertical_slot_machine.dart';

class PickScreen extends StatefulWidget {
  final String groupId;

  const PickScreen({
    super.key,
    required this.groupId,
  });

  @override
  State<PickScreen> createState() => _PickScreenState();
}

class _PickScreenState extends State<PickScreen> {
  final GroupRepository _groupRepository = GroupRepository();
  bool _isLoading = false;
  bool _showAnimation = false;
  String? _selectedUserId;
  List<GroupMemberModel>? _allMembers;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final members = await _groupRepository.streamGroupMembers(widget.groupId).first;
      if (mounted) {
        setState(() {
          _allMembers = members;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading members: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _startPicking() async {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is! AuthAuthenticated) return;

    final user = (authBloc.state as AuthAuthenticated).user;

    setState(() => _isLoading = true);

    try {
      // Get all members
      final members = await _groupRepository.streamGroupMembers(widget.groupId).first;

      // Get list of already assigned user IDs
      final alreadyAssigned = members
          .where((m) => m.assignedToUserId != null)
          .map((m) => m.assignedToUserId!)
          .toSet();

      // Available members are those who:
      // 1. Are not the current user
      // 2. Haven't been assigned to anyone yet
      final available = members
          .where((m) => m.userId != user.uid && !alreadyAssigned.contains(m.userId))
          .toList();

      if (available.isEmpty) {
        throw Exception('No available members to pick!');
      }

      // Random selection
      final random = Random();
      final selected = available[random.nextInt(available.length)];

      if (mounted) {
        setState(() {
          _selectedUserId = selected.userId;
          _showAnimation = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _onAnimationComplete() async {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is! AuthAuthenticated) return;

    final user = (authBloc.state as AuthAuthenticated).user;

    if (_selectedUserId == null) return;

    try {
      // Save the pick
      context.read<GroupBloc>().add(
            GroupPickRequested(
              groupId: widget.groupId,
              userId: user.uid,
              assignedUserId: _selectedUserId!,
            ),
          );

      // Wait a bit then navigate to reveal
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        context.go('/group/${widget.groupId}/reveal');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving pick: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showAnimation && _allMembers != null && _selectedUserId != null) {
      final selectedMember = _allMembers!.firstWhere((m) => m.userId == _selectedUserId);
      final allNames = _allMembers!.map((m) => m.displayName.isNotEmpty ? m.displayName : m.username).toList();

      return Scaffold(
        backgroundColor: AppColors.christmasRed,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: VerticalSlotMachine(
                allNames: allNames,
                selectedName: selectedMember.displayName.isNotEmpty
                    ? selectedMember.displayName
                    : selectedMember.username,
                onComplete: _onAnimationComplete,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Your Secret Santa'),
        backgroundColor: AppColors.christmasRed,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gift icon
              Icon(
                Icons.card_giftcard,
                size: 120,
                color: AppColors.christmasRed.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                'Ready to discover\nyour Secret Santa?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.christmasRed,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                'Click the button below to randomly draw who you\'ll be buying a gift for!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Pick button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _startPicking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.christmasGreen,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.snowWhite,
                            ),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shuffle, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Draw Now!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
  }
}
