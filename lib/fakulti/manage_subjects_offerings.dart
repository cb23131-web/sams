import 'package:flutter/material.dart';
import '../data/database.dart';
import 'manage_registration_period.dart';

class ManageSubjectsOfferingsPage extends StatefulWidget {
  const ManageSubjectsOfferingsPage({super.key});

  @override
  State<ManageSubjectsOfferingsPage> createState() =>
      _ManageSubjectsOfferingsPageState();
}

class _ManageSubjectsOfferingsPageState
    extends State<ManageSubjectsOfferingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4EA3),
        title: const Text('CO-CURRICULUM\nSUBJECT LIST'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: FutureBuilder<List<CoCurriculum>>(
        future: AppDatabase().getCoCurriculums(),
        builder: (context, snapshot) {
          final curriculums = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.description,
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
                      ...curriculums.map(
                        (curr) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                curr.code,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                curr.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: FutureBuilder<int>(
                                future: AppDatabase()
                                    .getCoCurriculumEnrolledCount(curr.id!),
                                builder: (context, enrolledSnapshot) {
                                  final enrolled = enrolledSnapshot.data ?? 0;
                                  final status = enrolled >= curr.maxSlots
                                      ? 'Full'
                                      : 'Active';
                                  return Text(
                                    '$status ($enrolled/${curr.maxSlots})',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 11),
                                  );
                                },
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
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ManageRegistrationPeriodPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B4B8A),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Manage Registration Period',
                      style: TextStyle(color: Colors.white, fontSize: 14),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
      builder: (dialogContext) {
        bool isSaving = false;
        String? errorMsg;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Co-Curriculum'),
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
                      decoration: const InputDecoration(labelText: 'Schedule'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: maxSlotsController,
                      decoration: const InputDecoration(labelText: 'Max Slots'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    if (errorMsg != null)
                      Text(
                        errorMsg!,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final code = codeController.text.trim();
                          final name = nameController.text.trim();
                          final schedule = scheduleController.text.trim();
                          final maxSlots =
                              int.tryParse(maxSlotsController.text) ?? 30;

                          if (code.isEmpty || name.isEmpty) {
                            setState(() {
                              errorMsg =
                                  'Please provide curriculum code and name.';
                            });
                            return;
                          }

                          setState(() {
                            isSaving = true;
                            errorMsg = null;
                          });

                          try {
                            final curr = CoCurriculum(
                              code: code,
                              name: name,
                              schedule: schedule,
                              maxSlots: maxSlots,
                            );
                            final res = await AppDatabase().insertCoCurriculum(
                              curr,
                            );
                            if (res > 0) {
                              Navigator.pop(dialogContext);
                              // refresh parent list
                              if (mounted) this.setState(() {});
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Co-Curriculum added successfully',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              setState(() {
                                isSaving = false;
                                errorMsg = 'Failed to add co-curriculum.';
                              });
                            }
                          } catch (e) {
                            setState(() {
                              isSaving = false;
                              errorMsg = 'Error: ${e.toString()}';
                            });
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
