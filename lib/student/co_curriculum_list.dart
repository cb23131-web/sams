import 'package:flutter/material.dart';
import '../data/database.dart';
import 'subject_registration_details.dart';

class CoCurriculumListPage extends StatefulWidget {
  const CoCurriculumListPage({super.key});

  @override
  State<CoCurriculumListPage> createState() => _CoCurriculumListPageState();
}

class _CoCurriculumListPageState extends State<CoCurriculumListPage> {
  late Future<List<Subject>> _subjectsFuture;

  @override
  void initState() {
    super.initState();
    _subjectsFuture = AppDatabase().getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4EA3),
        title: const Text('CO-CURRICULUM SUBJECT LIST'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: FutureBuilder<List<Subject>>(
        future: _subjectsFuture,
        builder: (context, snapshot) {
          final subjects = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (subjects.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.library_books,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No subjects found',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
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
                              'Co-Curriculum\ncode',
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
                              'Status',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...subjects.map((s) {
                        final isFull = s.enrolled >= s.maxSlots;
                        final statusLabel = isFull
                            ? 'Full (${s.maxSlots}/${s.maxSlots})'
                            : 'Active (${s.enrolled}/${s.maxSlots})';
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(s.code, textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(s.name, textAlign: TextAlign.center),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    statusLabel,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () async {
                                      final changed = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              SubjectRegistrationDetailsPage(
                                                subject: s,
                                              ),
                                        ),
                                      );
                                      if (changed == true)
                                        setState(
                                          () => _subjectsFuture = AppDatabase()
                                              .getSubjects(),
                                        );
                                    },
                                    child: const Text(
                                      'View',
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
                        );
                      }).toList(),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade400,
        onPressed: () {
          _showAddCurriculumDialog();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.red.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: const [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Attention: PKN12 co-curriculum course has been closed due to...',
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddCurriculumDialog() {
    final codeController = TextEditingController();
    final nameController = TextEditingController();
    final scheduleController = TextEditingController();
    final maxSlotsController = TextEditingController(text: '30');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Curriculum'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Curriculum Code (e.g., PKN11)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Curriculum Name (e.g., Kayak)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: scheduleController,
                decoration: const InputDecoration(
                  labelText: 'Schedule (e.g., 15 Mar 15:00 am until 3 p.m.)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: maxSlotsController,
                decoration: const InputDecoration(labelText: 'Max Slots'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (codeController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                final subject = Subject(
                  code: codeController.text.trim(),
                  name: nameController.text.trim(),
                  schedule: scheduleController.text.trim(),
                  maxSlots: int.tryParse(maxSlotsController.text) ?? 30,
                );
                await AppDatabase().insertSubject(subject);
                Navigator.pop(context);
                setState(() {
                  _subjectsFuture = AppDatabase().getSubjects();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Curriculum added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
