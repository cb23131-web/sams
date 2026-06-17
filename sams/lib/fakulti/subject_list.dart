import 'package:flutter/material.dart';
import '../data/database.dart';
import '../lecturer/add_subject.dart';

class SubjectListPage extends StatefulWidget {
  const SubjectListPage({super.key});

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
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
        backgroundColor: const Color(0xFFFFA500),
        title: const Text('MANAGE SUBJECTS\nOFFERINGS'),
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
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      BackButton(),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'MANAGE SUBJECTS OFFERINGS',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Icon(
                            Icons.library_books,
                            size: 48,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.grey.shade300,
                            ),
                            columnWidths: const {
                              0: FixedColumnWidth(100),
                              1: FixedColumnWidth(150),
                              2: FixedColumnWidth(150),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      'Subject Code',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      'Subject Name',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      'Status',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...subjects
                                  .take(4)
                                  .map(
                                    (subject) => TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            subject.code,
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            subject.name,
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      subject.status == 'Open'
                                                      ? Colors.green.shade300
                                                      : Colors.red.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  subject.status,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              GestureDetector(
                                                onTap: () {
                                                  _showEditSubjectDialog(
                                                    context,
                                                    subject,
                                                  );
                                                },
                                                child: const Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              GestureDetector(
                                                onTap: () {
                                                  _toggleSubjectStatus(subject);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        subject.status == 'Open'
                                                        ? Colors.red.shade300
                                                        : Colors.green.shade300,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    subject.status == 'Open'
                                                        ? 'Deactivate'
                                                        : 'Activate',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Load more subjects
                      },
                      child: const Text(
                        'More',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFFA500),
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddSubjectPage()));
          setState(() {
            _subjectsFuture = AppDatabase().getSubjects();
          });
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _showEditSubjectDialog(BuildContext context, Subject subject) {
    final codeController = TextEditingController(text: subject.code);
    final nameController = TextEditingController(text: subject.name);
    final descriptionController = TextEditingController(
      text: subject.description,
    );
    final scheduleController = TextEditingController(text: subject.schedule);
    final creditsController = TextEditingController(
      text: subject.credits.toString(),
    );
    final maxSlotsController = TextEditingController(
      text: subject.maxSlots.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Subject'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: 'Subject Code'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Subject Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: scheduleController,
                decoration: const InputDecoration(labelText: 'Schedule'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: creditsController,
                decoration: const InputDecoration(labelText: 'Credit Hours'),
                keyboardType: TextInputType.number,
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
              subject.code = codeController.text;
              subject.name = nameController.text;
              subject.description = descriptionController.text;
              subject.schedule = scheduleController.text;
              subject.credits = int.tryParse(creditsController.text) ?? 3;
              subject.maxSlots = int.tryParse(maxSlotsController.text) ?? 30;

              await AppDatabase().updateSubject(subject);

              Navigator.pop(context);
              setState(() {
                _subjectsFuture = AppDatabase().getSubjects();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Subject updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _toggleSubjectStatus(Subject subject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Action'),
        content: Text(
          'Are you sure you want to ${subject.status == 'Open' ? 'deactivate' : 'activate'} this subject?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              subject.status = subject.status == 'Open' ? 'Closed' : 'Open';
              await AppDatabase().updateSubject(subject);

              Navigator.pop(context);

              _showSuccessDialog(
                context,
                subject.status == 'Open' ? 'ACTIVATES' : 'DEACTIVATES',
              );

              await Future.delayed(const Duration(seconds: 2));
              setState(() {
                _subjectsFuture = AppDatabase().getSubjects();
              });
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.cyan.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                action,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                'SUBJECT OFFERING',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                'SUCCESSFULLY!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade700, width: 3),
                ),
                child: Icon(Icons.check, size: 48, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
