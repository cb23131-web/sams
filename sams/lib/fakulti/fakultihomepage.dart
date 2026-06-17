import 'package:flutter/material.dart';
import 'manage_subjects_offerings.dart';
import 'subject_list.dart';

class FakultihomePage extends StatefulWidget {
  const FakultihomePage({super.key});

  @override
  State<FakultihomePage> createState() => _FakultihomePageState();
}

class _FakultihomePageState extends State<FakultihomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildFeature(IconData icon, String label) {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB38AA8),
        elevation: 0,
        title: const Text('SAMS', style: TextStyle(fontSize: 14)),
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
                  _buildFeature(Icons.manage_accounts, 'Attendance'),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SubjectListPage(),
                        ),
                      );
                    },
                    child: _buildFeature(Icons.menu_book, 'Subject Lists'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ManageSubjectsOfferingsPage(),
                        ),
                      );
                    },
                    child: _buildFeature(Icons.edit, 'Manage co-curriculum'),
                  ),
                  _buildFeature(Icons.receipt, 'Fees'),
                  _buildFeature(Icons.event, 'Activities'),
                  _buildFeature(Icons.article, 'Credits'),
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
