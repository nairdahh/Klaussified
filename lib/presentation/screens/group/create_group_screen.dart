import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/business_logic/group/group_bloc.dart';
import 'package:klaussified/business_logic/group/group_event.dart';
import 'package:klaussified/business_logic/group/group_state.dart';
import 'package:klaussified/core/theme/colors.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetController = TextEditingController();
  DateTime? _selectedDeadline;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year, 12, 27),
    );

    if (picked != null) {
      setState(() => _selectedDeadline = picked);
    }
  }

  void _createGroup() {
    if (_formKey.currentState!.validate()) {
      context.read<GroupBloc>().add(
            GroupCreateRequested(
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim(),
              location: _locationController.text.trim(),
              budget: _budgetController.text.trim(),
              deadline: _selectedDeadline,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: BlocConsumer<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success),
            );
            context.pop();
          } else if (state is GroupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is GroupLoading;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(Icons.card_giftcard,
                              size: 64, color: AppColors.christmasGreen),
                          const SizedBox(height: 24),
                          Text(
                            'Create Secret Santa Group',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Group Name',
                              prefixIcon: Icon(Icons.group),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a group name';
                              }
                              return null;
                            },
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description (Optional)',
                              prefixIcon: Icon(Icons.description),
                              hintText: 'e.g., Office Christmas party exchange',
                            ),
                            maxLines: 2,
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _locationController,
                            decoration: InputDecoration(
                              labelText: 'Location (Optional)',
                              prefixIcon: Icon(Icons.location_on),
                              hintText: 'e.g., Office lobby or online',
                            ),
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _budgetController,
                            decoration: InputDecoration(
                              labelText: 'Budget (Optional)',
                              prefixIcon: Icon(Icons.attach_money),
                              hintText: 'e.g., \$20-30',
                            ),
                            enabled: !isLoading,
                          ),
                          const SizedBox(height: 24),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Pick Deadline (Optional)'),
                            subtitle: Text(
                              _selectedDeadline == null
                                  ? 'No deadline set'
                                  : 'Deadline: ${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}',
                            ),
                            trailing: _selectedDeadline != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => setState(
                                        () => _selectedDeadline = null),
                                  )
                                : null,
                            onTap: isLoading ? null : _selectDeadline,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: isLoading ? null : _createGroup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.christmasGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.snowWhite)),
                                  )
                                : const Text('Create Group'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
