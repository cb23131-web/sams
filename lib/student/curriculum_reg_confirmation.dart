import 'package:flutter/material.dart';
import '../data/database.dart';
import 'curriculum_registration_message.dart';

const _currentStudent = 'ahmad';

class CurriculumRegistrationConfirmationPage extends StatefulWidget {
  final CoCurriculum curriculum;

  const CurriculumRegistrationConfirmationPage({
    super.key,
    required this.curriculum,
  });

  @override
  State<CurriculumRegistrationConfirmationPage> createState() =>
      _CurriculumRegistrationConfirmationPageState();
}

class _CurriculumRegistrationConfirmationPageState
    extends State<CurriculumRegistrationConfirmationPage> {
  bool _isSubmitting = false;

  Future<void> _submitRegistration() async {
    if (widget.curriculum.id == null) return;
    setState(() => _isSubmitting = true);

    final result = await AppDatabase().registerCoCurriculum(
      _currentStudent,
      widget.curriculum.id!,
    );
    final success = result > 0;
    final title = success ? 'Registration successful' : 'Registration failed';
    final message = success
        ? 'Registration successful. You are now enrolled.'
        : 'Registration failed. You are already registered.';

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    final messageResult = await Navigator.push<bool>(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => CurriculumRegistrationMessagePage(
          success: success,
          title: title,
          message: message,
        ),
      ),
    );

    if (success && mounted) {
      Navigator.pop(context, true);
    } else if (messageResult == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B4B8A),
        title: const Text('CO-CURRICULUM REGISTRATION'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Text(
                widget.curriculum.code,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.curriculum.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Slot availability (${widget.curriculum.enrolled}/${widget.curriculum.maxSlots})',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Schedule: ${widget.curriculum.schedule.isEmpty ? 'Not available' : widget.curriculum.schedule}",
                    ),
                    const SizedBox(height: 8),
                    const Text('Location: Campus Pekan'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'Confirm',
                            style: TextStyle(color: Colors.black),
                          ),
                  ),
                  OutlinedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 220,
                child: Image.asset(
                  'assets/images/co_curriculum.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
