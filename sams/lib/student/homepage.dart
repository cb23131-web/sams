import 'package:flutter/material.dart';
import 'registeredsubject.dart';
import 'attendance_student.dart';
import 'co_curriculum_list.dart';
import 'credit_claiming.dart';

// HomePage displays a grid of features and a bottom navigation bar.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Tracks the currently selected bottom navigation index.
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Handles taps on the bottom navigation bar.
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildFeature(IconData icon, String label) {
    // Helper to build each feature icon + label cell.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 48, color: Colors.black87),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Builds the homepage matching the provided mockup: app bar, grid,
    // and bottom navigation.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB38AA8), // muted purple bar
        elevation: 0,
        title: const Text('SAMS', style: TextStyle(fontSize: 14)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'HOMEPAGE',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
                childAspectRatio: 1,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const StudentAttendancePage(),
                        ),
                      );
                    },
                    child: _buildFeature(Icons.person, 'Attendance'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const RegisteredSubjectPage(),
                        ),
                      );
                    },
                    child: _buildFeature(Icons.menu_book, 'Subject Lists'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CoCurriculumListPage(),
                        ),
                      );
                    },
                    child: _buildFeature(
                      Icons.assignment,
                      'Curriculum Registration',
                    ),
                  ),
                  _buildFeature(Icons.receipt, 'Fees'),
                  _buildFeature(Icons.event, 'Activities'),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CreditClaimingPage(),
                        ),
                      );
                    },
                    child: _buildFeature(Icons.article, 'Credits'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
