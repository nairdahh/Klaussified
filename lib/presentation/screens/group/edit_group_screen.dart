import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klaussified/core/theme/colors.dart';
import 'package:klaussified/data/repositories/group_repository.dart';

class EditGroupScreen extends StatefulWidget {
  final String groupId;

  const EditGroupScreen({
    super.key,
    required this.groupId,
  });

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetController = TextEditingController();

  final GroupRepository _groupRepository = GroupRepository();
  bool _isLoading = false;
  DateTime? _selectedDeadline;
  DateTime? _selectedEventDate;

  @override
  void initState() {
    super.initState();
    _loadGroupDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _loadGroupDetails() async {
    setState(() => _isLoading = true);

    try {
      final group = await _groupRepository.streamGroup(widget.groupId).first;

      if (group != null && mounted) {
        setState(() {
          _nameController.text = group.name;
          _descriptionController.text = group.description;
          _locationController.text = group.location;
          _budgetController.text = group.budget;
          _selectedDeadline = group.informationalDeadline;
          _selectedEventDate = group.eventDate;
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading group: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _selectDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() => _selectedDeadline = picked);
    }
  }

  Future<void> _selectEventDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedEventDate ?? now.add(const Duration(days: 14)),
      firstDate: now,
      lastDate: DateTime(now.year + 1, 12, 31),
    );

    if (picked != null) {
      setState(() => _selectedEventDate = picked);
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _groupRepository.updateGroupDetails(
        groupId: widget.groupId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        budget: _budgetController.text.trim(),
        informationalDeadline: _selectedDeadline,
        eventDate: _selectedEventDate,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group details updated successfully!'),
            backgroundColor: AppColors.christmasGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating group: $e'),
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
        title: const Text('Edit Group Details'),
        backgroundColor: AppColors.christmasGreen,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Group Name
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
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description (Optional)',
                        prefixIcon: Icon(Icons.description),
                        hintText: 'e.g., Office Christmas party exchange',
                      ),
                      maxLines: 2,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location (Optional)',
                        prefixIcon: Icon(Icons.location_on),
                        hintText: 'e.g., Office lobby or online',
                      ),
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _budgetController,
                      decoration: InputDecoration(
                        labelText: 'Budget (Optional)',
                        prefixIcon: Icon(Icons.attach_money),
                        hintText: 'e.g., \$20-30',
                      ),
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 24),

                    // Deadline
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Pick Deadline (Optional)'),
                      subtitle: Text(
                        _selectedDeadline == null
                            ? 'No deadline set - When picks must be completed'
                            : '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_selectedDeadline != null)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () =>
                                  setState(() => _selectedDeadline = null),
                              tooltip: 'Clear deadline',
                            ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: _selectDeadline,
                            tooltip: 'Select deadline',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Event Date
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.event),
                      title: const Text('Event Date (Optional)'),
                      subtitle: Text(
                        _selectedEventDate == null
                            ? 'No event date set - When gift exchange happens'
                            : '${_selectedEventDate!.day}/${_selectedEventDate!.month}/${_selectedEventDate!.year}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_selectedEventDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () =>
                                  setState(() => _selectedEventDate = null),
                              tooltip: 'Clear event date',
                            ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: _selectEventDate,
                            tooltip: 'Select event date',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveChanges,
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
                              'Save Changes',
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
