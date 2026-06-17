import 'package:flutter/material.dart';
import '../data/database.dart';
import 'attendance_create.dart';

class LecturerAttendanceHomePage extends StatefulWidget {
  const LecturerAttendanceHomePage({super.key});

  @override
  State<LecturerAttendanceHomePage> createState() =>
      _LecturerAttendanceHomePageState();
}

class _LecturerAttendanceHomePageState
    extends State<LecturerAttendanceHomePage> {
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
      body: FutureBuilder<List<Subject>>(
        future: AppDatabase().getSubjects(),
        builder: (context, snapshot) {
          final subjects = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (subjects.isEmpty) {
            return const Center(child: Text('No subjects available.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subjects',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  subject.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                ),
                                onPressed: () async {
                                  final session = await AppDatabase()
                                      .getLatestAttendanceSessionForSubject(
                                        subject.id!,
                                      );
                                  if (session != null &&
                                      session.status == 'Open') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => AttendanceSessionPage(
                                          subject: subject,
                                          session: session,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => AttendanceCreatePage(
                                          subject: subject,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('View'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AttendanceCreatePage(
                                        subject: subject,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Create'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
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

class AttendanceSessionPage extends StatefulWidget {
  final Subject subject;
  final AttendanceSession session;

  const AttendanceSessionPage({
    super.key,
    required this.subject,
    required this.session,
  });

  @override
  State<AttendanceSessionPage> createState() => _AttendanceSessionPageState();
}

class _AttendanceSessionPageState extends State<AttendanceSessionPage> {
  List<Map<String, dynamic>> studentList = [];
  bool isLoading = true;

  Future<void> _loadStudents() async {
    final records = await AppDatabase().getAttendanceRecordsForSession(
      widget.session.sessionId!,
    );
    setState(() {
      studentList = records;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time: ${widget.session.startTime} - ${widget.session.endTime}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Code: ${widget.session.code}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Student list:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            AttendanceRecordsPage(session: widget.session),
                      ),
                    );
                  },
                  child: const Text('View List'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: studentList.length,
                      itemBuilder: (context, index) {
                        final student = studentList[index];
                        return Card(
                          child: ListTile(
                            title: Text(student['student_name'] as String),
                            subtitle: Text(
                              student['present'] == 1 ? 'Present' : 'Absent',
                            ),
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await AppDatabase().closeAttendanceSession(
                  widget.session.sessionId!,
                );
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Close Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceRecordsPage extends StatelessWidget {
  final AttendanceSession session;

  const AttendanceRecordsPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Records')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: AppDatabase().getAttendanceRecordsForSession(
          session.sessionId!,
        ),
        builder: (context, snapshot) {
          final records = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (records.isEmpty) {
            return const Center(child: Text('No registered students found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final row = records[index];
              return Card(
                child: ListTile(
                  title: Text(row['student_name'] as String),
                  subtitle: Text(row['present'] == 1 ? 'Present' : 'Absent'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
