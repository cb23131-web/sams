import 'package:flutter/material.dart';

import '../data/database.dart';
import 'claim_detail.dart';

const _currentStudent = 'ahmad';

class CreditClaimingPage extends StatefulWidget {
  const CreditClaimingPage({super.key});

  @override
  State<CreditClaimingPage> createState() => _CreditClaimingPageState();
}

class _CreditClaimingPageState extends State<CreditClaimingPage> {
  late Future<List<Map<String, dynamic>>> _activitiesFuture;
  late Future<List<Map<String, dynamic>>> _historyFuture;
  late Future<int> _earnedCreditsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _activitiesFuture = AppDatabase().getClaimActivitiesForStudent(
        _currentStudent,
      );
      _historyFuture = AppDatabase().getClaimHistoryForStudent(
        _currentStudent,
      );
      _earnedCreditsFuture = AppDatabase().getApprovedCreditTotalForStudent(
        _currentStudent,
      );
    });
  }

  Future<void> _submitClaim(int activityId, int credit) async {
    final database = await AppDatabase().db;
    final exists = await database.query(
      'claims',
      where: 'activity_id = ? AND student_name = ?',
      whereArgs: [activityId, _currentStudent],
    );

    if (exists.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(
        content: Text('You already submitted this claim.'),
      ));
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Claim submitted successfully.')),
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CREDIT CLAIMING')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<int>(
              future: _earnedCreditsFuture,
              builder: (context, snapshot) {
                final earned = snapshot.data ?? 0;
                final progress = (earned / 8).clamp(0.0, 1.0);
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
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
                        '$earned / 8 Credits',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white24,
                        color: Colors.white,
                        minHeight: 10,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(8 - earned).clamp(0, 8)} more credit(s) available',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _activitiesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final activities = snapshot.data ?? [];
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Activities',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (activities.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Text('No activities available.'),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: activities.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final row = activities[index];
                              final status = row['status'] as String? ?? 'Not claimed';
                              final buttonLabel = status == 'Pending'
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
                                          : Colors.blue.shade100;

                              return Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                              '${row['category'] ?? ''} · ${row['hours'] ?? 0} Hours · ${row['credit'] ?? 0} Credit',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            if (status != 'Not claimed')
                                              Text(
                                                'Status: $status',
                                                style: TextStyle(
                                                  color: status == 'Approved'
                                                      ? Colors.green.shade700
                                                      : status == 'Rejected'
                                                          ? Colors.red.shade700
                                                          : Colors.orange.shade700,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonColor,
                                          foregroundColor: Colors.black87,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                        ),
                                        onPressed: status == 'Not claimed'
                                            ? () => _submitClaim(
                                                  row['activity_id'] as int,
                                                  row['credit'] as int? ?? 0,
                                                )
                                            : null,
                                        child: Text(buttonLabel),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 24),
                        const Text(
                          'My Claim History',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _historyFuture,
                          builder: (context, historySnapshot) {
                            if (historySnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final history = historySnapshot.data ?? [];
                            if (history.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text('No claims submitted yet.'),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: history.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final row = history[index];
                                final status = row['status'] as String? ?? 'Pending';
                                final statusColor = status == 'Approved'
                                    ? Colors.green.shade100
                                    : status == 'Rejected'
                                        ? Colors.red.shade100
                                        : Colors.orange.shade100;

                                return Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  elevation: 2,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ClaimDetailPage(
                                            claimId: row['claim_id'] as int,
                                          ),
                                        ),
                                      );
                                      _loadData();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  row['activity_title'] as String? ?? '',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  'Submitted: ${row['submission_date'] ?? ''}',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                if (status == 'Rejected' &&
                                                    (row['rejection_reason'] as String?)?.isNotEmpty == true)
                                                  Text(
                                                    'Reason: ${row['rejection_reason']}',
                                                    style: TextStyle(
                                                      color: Colors.red.shade700,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              status,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
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
