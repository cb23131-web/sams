import 'dart:math';

import 'package:flutter/material.dart';
import '../data/database.dart';
import 'attendance_home.dart';

class AttendanceCreatePage extends StatefulWidget {
  final Subject subject;

  const AttendanceCreatePage({super.key, required this.subject});

  @override
  State<AttendanceCreatePage> createState() => _AttendanceCreatePageState();
}

class _AttendanceCreatePageState extends State<AttendanceCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> _createSession() async {
    if (!_formKey.currentState!.validate()) return;

    final code = _generateCode();
    final session = AttendanceSession(
      subjectId: widget.subject.id!,
      date: _dateController.text.trim(),
      startTime: _startController.text.trim(),
      endTime: _endController.text.trim(),
      code: code,
      createdAt: DateTime.now().toIso8601String(),
    );

    final id = await AppDatabase().insertAttendanceSession(session);
    if (id > 0) {
      final createdSession = await AppDatabase().getAttendanceSessionById(id);
      if (createdSession != null) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => AttendanceSessionPage(
                subject: widget.subject,
                session: createdSession,
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ATTENDANCE')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subject.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'e.g. 2026-06-16',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter attendance date'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _startController,
                    decoration: InputDecoration(
                      labelText: 'Start Time',
                      hintText: 'e.g. 8:00 am',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter start time'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _endController,
                    decoration: InputDecoration(
                      labelText: 'End Time',
                      hintText: 'e.g. 10:00 am',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter end time'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _createSession,
                      child: const Text('Create'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
