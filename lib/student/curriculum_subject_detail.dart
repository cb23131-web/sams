import 'package:flutter/material.dart';
import '../data/database.dart';
import 'curriculum_reg_confirmation.dart';

class CurriculumSubjectDetailPage extends StatelessWidget {
  final CoCurriculum curriculum;

  const CurriculumSubjectDetailPage({super.key, required this.curriculum});

  @override
  Widget build(BuildContext context) {
    final isFull = curriculum.enrolled >= curriculum.maxSlots;
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
                curriculum.code,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      curriculum.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Slot availability (${curriculum.enrolled}/${curriculum.maxSlots})',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Schedule: ${curriculum.schedule.isEmpty ? 'Not available' : curriculum.schedule}',
                    ),
                    const SizedBox(height: 8),
                    const Text('Location: Campus Pekan'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isFull
                    ? null
                    : () async {
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CurriculumRegistrationConfirmationPage(
                                  curriculum: curriculum,
                                ),
                          ),
                        );
                        if (result == true) {
                          Navigator.pop(context, true);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isFull ? 'Full' : 'Register',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 220,
                child: Image.asset(
                  'assets/images/co_curriculum.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
