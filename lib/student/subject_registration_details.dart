import 'package:flutter/material.dart';
import '../data/database.dart';

const _currentStudent = 'ahmad';

class SubjectRegistrationDetailsPage extends StatefulWidget {
  final Subject subject;

  const SubjectRegistrationDetailsPage({super.key, required this.subject});

  @override
  State<SubjectRegistrationDetailsPage> createState() =>
      _SubjectRegistrationDetailsPageState();
}

class _SubjectRegistrationDetailsPageState
    extends State<SubjectRegistrationDetailsPage> {
  bool _isRegistering = false;

  Future<void> _register() async {
    setState(() => _isRegistering = true);
    try {
      final res = await AppDatabase().registerSubject(
        _currentStudent,
        widget.subject.id!,
      );
      if (!mounted) return;

      if (res > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully registered for ${widget.subject.name}'),
            backgroundColor: Colors.green,
          ),
        );
        // update local subject info by reloading from DB if needed
        Navigator.of(context).pop(true);
      } else if (res == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Already registered for ${widget.subject.name}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isRegistering = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.subject;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B4B8A),
        title: const Text('SUBJECT REGISTRATION'),
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
                s.code,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      s.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Slot availability (${s.enrolled}/${s.maxSlots})'),
                    const SizedBox(height: 6),
                    Text('Schedule: ${s.schedule}'),
                    const SizedBox(height: 6),
                    const Text('Location: Campus'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: s.status == 'Full' || _isRegistering
                    ? null
                    : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade200,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isRegistering
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Register',
                        style: TextStyle(color: Colors.black),
                      ),
              ),
              const SizedBox(height: 24),
              // Illustration placeholder
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
