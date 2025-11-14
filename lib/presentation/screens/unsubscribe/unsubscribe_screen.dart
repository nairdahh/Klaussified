import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:klaussified/core/theme/colors.dart';

class UnsubscribeScreen extends StatefulWidget {
  final String? token;
  final String? type;

  const UnsubscribeScreen({
    super.key,
    this.token,
    this.type,
  });

  @override
  State<UnsubscribeScreen> createState() => _UnsubscribeScreenState();
}

class _UnsubscribeScreenState extends State<UnsubscribeScreen> {
  String? _selectedOption;
  bool _isProcessing = false;
  bool _isSuccess = false;
  String? _resultMessage;

  @override
  void initState() {
    super.initState();
    // Pre-select option from URL parameter if provided
    if (widget.type != null) {
      _selectedOption = widget.type;
    }
  }

  Future<void> _processUnsubscribe() async {
    if (_selectedOption == null) {
      setState(() {
        _resultMessage = 'Please select an unsubscribe option';
        _isSuccess = false;
      });
      return;
    }

    if (widget.token == null || widget.token!.isEmpty) {
      setState(() {
        _resultMessage = 'Invalid unsubscribe link';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _resultMessage = null;
    });

    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('processUnsubscribe')
          .call({
        'token': widget.token,
        'unsubscribeType': _selectedOption,
      });

      if (mounted) {
        setState(() {
          _isProcessing = false;
          _isSuccess = result.data['success'] ?? false;
          _resultMessage = result.data['message'] ?? 'Successfully unsubscribed';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _isSuccess = false;
          _resultMessage = 'Error: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 24 : 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const Icon(
                      Icons.unsubscribe,
                      size: 64,
                      color: AppColors.christmasRed,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Email Unsubscribe',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Choose which emails you\'d like to stop receiving:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Unsubscribe options
                    _buildOption(
                      'all',
                      'Unsubscribe from All Emails',
                      'You will no longer receive any email notifications from Klaussified',
                      Icons.mail_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildOption(
                      'invites',
                      'Unsubscribe from Invitation Emails',
                      'Stop receiving emails when you\'re invited to Secret Santa groups',
                      Icons.group_add,
                    ),
                    const SizedBox(height: 16),
                    _buildOption(
                      'deadlines',
                      'Unsubscribe from Deadline Reminders',
                      'Stop receiving emails about upcoming Secret Santa deadlines',
                      Icons.alarm,
                    ),

                    const SizedBox(height: 32),

                    // Unsubscribe button
                    ElevatedButton(
                      onPressed: _isProcessing || _isSuccess
                          ? null
                          : _processUnsubscribe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.christmasRed,
                        foregroundColor: AppColors.snowWhite,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              _isSuccess
                                  ? 'Unsubscribed Successfully'
                                  : 'Confirm Unsubscribe',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),

                    // Result message
                    if (_resultMessage != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _isSuccess
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.1),
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
                              size: 24,
                            ),
                            const SizedBox(width: 12),
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

                    const SizedBox(height: 24),

                    // Note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.christmasGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.christmasGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.christmasGreen,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'You can update your email preferences anytime from your account settings if you\'re logged in.',
                              style: TextStyle(
                                color: AppColors.christmasGreen.withValues(alpha: 0.9),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
    String value,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedOption == value;

    return InkWell(
      onTap: _isSuccess
          ? null
          : () {
              setState(() {
                _selectedOption = value;
              });
            },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.christmasRed.withValues(alpha: 0.1)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.christmasRed
                : AppColors.textSecondary.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedOption,
              onChanged: _isSuccess
                  ? null
                  : (String? newValue) {
                      setState(() {
                        _selectedOption = newValue;
                      });
                    },
              activeColor: AppColors.christmasRed,
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              color: isSelected
                  ? AppColors.christmasRed
                  : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.christmasRed
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
