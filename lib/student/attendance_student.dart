import 'package:flutter/material.dart';
import '../data/database.dart';

const _currentStudent = 'ahmad';

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({super.key});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  final TextEditingController _codeController = TextEditingController();
  int? _selectedSessionId;
  List<Map<String, dynamic>> _openSessions = [];
  String _statusMessage = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadSessions() async {
    final sessions = await AppDatabase().getOpenAttendanceSessionsForStudent(
      _currentStudent,
    );
    setState(() {
      _openSessions = sessions;
      _loading = false;
    });
  }

  Future<void> _markPresent() async {
    if (_selectedSessionId == null || _codeController.text.isEmpty) {
      setState(() {
        _statusMessage = 'Select a session and enter the code.';
      });
      return;
    }

    final session = _openSessions.firstWhere(
      (item) => item['session_id'] == _selectedSessionId,
      orElse: () => {},
    );
    if ((session['is_registered'] as int? ?? 0) == 0) {
      setState(() {
        _statusMessage = 'You are not registered for this subject.';
      });
      return;
    }

    final result = await AppDatabase().markAttendance(
      _selectedSessionId!,
      _currentStudent,
      _codeController.text.trim(),
    );

    setState(() {
      if (result == 0) {
        _statusMessage = 'Attendance could not be recorded.';
      } else if (result == -1) {
        _statusMessage = 'Invalid attendance code.';
      } else {
        _statusMessage = 'Attendance recorded successfully.';
      }
    });
    await _loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATTENDANCE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Open Sessions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (_openSessions.isEmpty)
                    const Text('No open attendance sessions available.')
                  else ...[
                    DropdownButtonFormField<int>(
                      value: _selectedSessionId,
                      items: _openSessions
                          .map(
                            (session) => DropdownMenuItem(
                              value: session['session_id'] as int,
                              child: Text(
                                '${session['subject_name']} (${session['start_time']} - ${session['end_time']}) ${session['is_registered'] == 1 ? '' : '(Not registered)'}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        _selectedSessionId = value;
                        _statusMessage = '';
                      }),
                      decoration: InputDecoration(
                        labelText: 'Choose Session',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Attendance Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _markPresent,
                      child: const Text('Mark Attendance'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _statusMessage,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: AppDatabase().getAttendanceHistoryForStudent(
                        _currentStudent,
                      ),
                      builder: (context, snapshot) {
                        final history = snapshot.data ?? [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (history.isEmpty) {
                          return const Text('Attendance history is empty.');
                        }
                        return ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final row = history[index];
                            final present = row['present'] == 1;
                            return Card(
                              child: ListTile(
                                title: Text(row['subject_name'] as String),
                                subtitle: Text(
                                  '${row['start_time']} - ${row['end_time']} • ${row['status']}',
                                ),
                                trailing: Text(present ? 'Present' : 'Absent'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
