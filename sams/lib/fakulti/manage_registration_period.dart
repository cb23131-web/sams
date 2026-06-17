import 'package:flutter/material.dart';
import '../data/database.dart';

enum _RegistrationViewState { list, closing, confirmed }

class ManageRegistrationPeriodPage extends StatefulWidget {
  const ManageRegistrationPeriodPage({super.key});

  @override
  State<ManageRegistrationPeriodPage> createState() =>
      _ManageRegistrationPeriodPageState();
}

class _ManageRegistrationPeriodPageState
    extends State<ManageRegistrationPeriodPage> {
  _RegistrationViewState _viewState = _RegistrationViewState.list;
  CoCurriculum? _selectedCurriculum;
  final TextEditingController _announcementController = TextEditingController();
  String _selectedPeriod = '3 weeks';

  @override
  void dispose() {
    _announcementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B4EA3),
        title: const Text('MANAGE REGISTRATION PERIOD'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_viewState == _RegistrationViewState.list) {
              Navigator.pop(context);
            } else {
              _resetToList();
            }
          },
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_viewState) {
      case _RegistrationViewState.closing:
        return _buildCloseForm(context);
      case _RegistrationViewState.confirmed:
        return _buildConfirmation(context);
      case _RegistrationViewState.list:
        return _buildCurriculumList(context);
    }
  }

  Widget _buildCurriculumList(BuildContext context) {
    return FutureBuilder<List<CoCurriculum>>(
      future: AppDatabase().getCoCurriculums(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? [];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Table(
                      border: TableBorder.all(color: Colors.grey.shade400),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1.6),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(0.9),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
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
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Action',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...items.map((curr) {
                          return TableRow(
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
                                    final status = curr.status == 'Closed'
                                        ? 'Closed'
                                        : (enrolled >= curr.maxSlots
                                              ? 'Full'
                                              : 'Active');
                                    return Text(
                                      '$status ($enrolled/${curr.maxSlots})',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 11),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _showEditDialog(curr),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF7DE08E,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 6,
                                        ),
                                        shape: const StadiumBorder(),
                                      ),
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    OutlinedButton(
                                      onPressed: () => _startClose(curr),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: Color(0xFFFF7B7B),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        shape: const StadiumBorder(),
                                      ),
                                      child: const Text(
                                        'Close',
                                        style: TextStyle(
                                          color: Color(0xFFFF4D4D),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'More',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 56),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseForm(BuildContext context) {
    final code = _selectedCurriculum?.code ?? '';
    final subject = _selectedCurriculum?.name ?? '';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2A93E),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      code,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You\'re going to close the $code - $subject.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please provide the reason for the announcement:',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _announcementController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Reason for closing...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Registration period',
                            style: TextStyle(color: Colors.black87),
                          ),
                          DropdownButton<String>(
                            value: _selectedPeriod,
                            underline: const SizedBox.shrink(),
                            items: const [
                              DropdownMenuItem(
                                value: '1 week',
                                child: Text('1 week'),
                              ),
                              DropdownMenuItem(
                                value: '2 weeks',
                                child: Text('2 weeks'),
                              ),
                              DropdownMenuItem(
                                value: '3 weeks',
                                child: Text('3 weeks'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedPeriod = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _confirmCloseAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmation(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFFF2A93E),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'THE UPDATE HAVE BEEN SAVED SUCCESSFULLY!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'The announcement has been sent',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _resetToList,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startClose(CoCurriculum curr) {
    setState(() {
      _selectedCurriculum = curr;
      _announcementController.text = '';
      _selectedPeriod = '3 weeks';
      _viewState = _RegistrationViewState.closing;
    });
  }

  Future<void> _confirmCloseAction() async {
    if (_announcementController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the announcement reason.')),
      );
      return;
    }

    if (_selectedCurriculum?.id != null) {
      final updated = CoCurriculum(
        id: _selectedCurriculum!.id,
        code: _selectedCurriculum!.code,
        name: _selectedCurriculum!.name,
        description: _selectedCurriculum!.description,
        schedule: _selectedCurriculum!.schedule,
        maxSlots: _selectedCurriculum!.maxSlots,
        enrolled: _selectedCurriculum!.enrolled,
        status: 'Closed',
      );

      try {
        final rows = await AppDatabase().updateCoCurriculum(updated);
        if (!mounted) return;
        if (rows > 0) {
          setState(() => _viewState = _RegistrationViewState.confirmed);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update status')),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } else {
      if (!mounted) return;
      setState(() => _viewState = _RegistrationViewState.confirmed);
    }
  }

  void _resetToList() {
    if (!mounted) return;
    setState(() {
      _viewState = _RegistrationViewState.list;
      _selectedCurriculum = null;
      _announcementController.clear();
      _selectedPeriod = '3 weeks';
    });
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _showEditDialog(CoCurriculum curr) async {
    final existing = <String, DateTime?>{};
    DateTime? start = existing['start'];
    DateTime? end = existing['end'];

    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Registration Period'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Start Date'),
                    subtitle: Text(
                      start != null ? _formatDate(start!) : 'Not set',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime initialStart = start ?? DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: initialStart,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => start = picked);
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('End Date'),
                    subtitle: Text(end != null ? _formatDate(end!) : 'Not set'),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime initialEnd = end ?? DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: initialEnd,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => end = picked);
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (start == null || end == null) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select both dates'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(dialogCtx);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registration period updated'),
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
