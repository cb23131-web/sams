import 'package:flutter/material.dart';
import '../data/database.dart';
import 'registersubject.dart';
import 'subject_attendance_code.dart';

const _currentStudent = 'ahmad';

class RegisteredSubjectPage extends StatefulWidget {
  const RegisteredSubjectPage({super.key});

  @override
  State<RegisteredSubjectPage> createState() => _RegisteredSubjectPageState();
}

class _RegisteredSubjectPageState extends State<RegisteredSubjectPage> {
  late Future<List<Map<String, dynamic>>> _registeredSubjectsFuture;

  @override
  void initState() {
    super.initState();
    _loadRegisteredSubjects();
  }

  void _loadRegisteredSubjects() {
    setState(() {
      _registeredSubjectsFuture = AppDatabase().getRegistrationsFor(
        _currentStudent,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB38AA8),
        title: const Text('SUBJECT LIST'),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.app_registration),
            tooltip: 'Register Subject',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RegisterSubjectPage()),
              );
              _loadRegisteredSubjects();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: AppDatabase().getRegistrationsFor(_currentStudent),
        builder: (context, snapshot) {
          final regs = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (regs.isEmpty) {
            return const Center(child: Text('No registered subjects.'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.library_books,
                      size: 48,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Table(
                    border: TableBorder.all(color: Colors.grey.shade400),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1.2),
                      2: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Subject\ncode',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Subject\nname',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Credit\nHours',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...regs.map(
                        (s) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                s['code'] ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                s['name'] ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${s['credits']}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              SubjectAttendanceCodePage(
                                                subjectId: s['id'] as int,
                                                subjectName: s['name'] ?? '',
                                              ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'View',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 11,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'More',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
