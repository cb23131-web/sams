import 'package:flutter/material.dart';

import '../data/database.dart';

const _currentStudent = 'ahmad';

class CreditClaimingPage extends StatefulWidget {
  const CreditClaimingPage({super.key});

  @override
  State<CreditClaimingPage> createState() => _CreditClaimingPageState();
}

class _CreditClaimingPageState extends State<CreditClaimingPage> {
  late Future<List<Map<String, dynamic>>> _claimsFuture;
  late Future<int> _earnedCreditsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _claimsFuture = AppDatabase().getClaimActivitiesForStudent(
        _currentStudent,
      );
      _earnedCreditsFuture = AppDatabase().getApprovedCreditTotalForStudent(
        _currentStudent,
      );
    });
  }

  Future<void> _submitClaim(int activityId, int credit) async {
    final existingClaim = await AppDatabase().db;
    final exists = await existingClaim.query(
      'claims',
      where: 'activity_id = ? AND student_name = ?',
      whereArgs: [activityId, _currentStudent],
    );
    if (exists.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already submitted this claim.')),
      );
      return;
    }

    await AppDatabase().insertClaim(
      Claim(
        activityId: activityId,
        studentName: _currentStudent,
        submissionDate: DateTime.now().toIso8601String(),
        creditEquivalent: credit,
      ),
    );
    _loadData();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Claim submitted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CREDIT CLAIMING')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _claimsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<int>(
                  future: _earnedCreditsFuture,
                  builder: (context, creditSnapshot) {
                    final earned = creditSnapshot.data ?? 0;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Credits Earned',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$earned/8 Credits',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const LinearProgressIndicator(
                            value: 0.25,
                            backgroundColor: Colors.white24,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${8 - earned} more available to claim',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: rows.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      final status = row['status'] as String? ?? 'Not claimed';
                      final buttonText = status == 'Pending'
                          ? 'Pending'
                          : status == 'Approved'
                          ? 'Approved'
                          : status == 'Rejected'
                          ? 'Rejected'
                          : 'Claim';
                      final buttonColor = status == 'Pending'
                          ? Colors.orange.shade100
                          : status == 'Approved'
                          ? Colors.green.shade100
                          : status == 'Rejected'
                          ? Colors.red.shade100
                          : Colors.purple.shade100;
                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      row['title'] as String? ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${row['category'] ?? ''} · ${row['hours'] ?? ''} Hours · ${row['credit'] ?? ''} Credit',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  foregroundColor: Colors.black87,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: status == 'Not claimed'
                                    ? () => _submitClaim(
                                        row['activity_id'] as int,
                                        row['credit'] as int? ?? 0,
                                      )
                                    : null,
                                child: Text(buttonText),
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
    );
  }
}
