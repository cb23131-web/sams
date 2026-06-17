import 'package:flutter/material.dart';
import '../data/database.dart';
import 'curriculum_subject_detail.dart';

class CurriculumSubjectListPage extends StatefulWidget {
  const CurriculumSubjectListPage({super.key});

  @override
  State<CurriculumSubjectListPage> createState() =>
      _CurriculumSubjectListPageState();
}

class _CurriculumSubjectListPageState extends State<CurriculumSubjectListPage> {
  late Future<List<CoCurriculum>> _curriculaFuture;

  @override
  void initState() {
    super.initState();
    _loadCurricula();
  }

  void _loadCurricula() {
    _curriculaFuture = AppDatabase().getCoCurriculums();
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
      body: FutureBuilder<List<CoCurriculum>>(
        future: _curriculaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final curricula = snapshot.data ?? [];
          if (curricula.isEmpty) {
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
                    'No co-curriculum subjects found',
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
                      1: FlexColumnWidth(1.5),
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
                      ...curricula.map((curr) {
                        final isFull = curr.enrolled >= curr.maxSlots;
                        final statusLabel = isFull
                            ? 'Full (${curr.enrolled}/${curr.maxSlots})'
                            : 'Active (${curr.enrolled}/${curr.maxSlots})';
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                curr.code,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                curr.name,
                                textAlign: TextAlign.center,
                              ),
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
                                      final changed =
                                          await Navigator.push<bool>(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CurriculumSubjectDetailPage(
                                                    curriculum: curr,
                                                  ),
                                            ),
                                          );
                                      if (changed == true) {
                                        setState(() {
                                          _loadCurricula();
                                        });
                                      }
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
}
