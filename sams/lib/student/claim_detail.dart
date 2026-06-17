import 'package:flutter/material.dart';

import '../data/database.dart';

class ClaimDetailPage extends StatefulWidget {
  const ClaimDetailPage({super.key, required this.claimId});

  final int claimId;

  @override
  State<ClaimDetailPage> createState() => _ClaimDetailPageState();
}

class _ClaimDetailPageState extends State<ClaimDetailPage> {
  late Future<Map<String, dynamic>?> _claimFuture;

  @override
  void initState() {
    super.initState();
    _claimFuture = AppDatabase().getClaimDetailById(widget.claimId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CLAIM DETAIL')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _claimFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final claim = snapshot.data;
          if (claim == null) {
            return const Center(child: Text('Claim not found.'));
          }

          final status = claim['status'] as String? ?? 'Pending';
          final activity = claim['activity_title'] as String? ?? '';
          final category = claim['category'] as String? ?? '';
          final hours = claim['hours'] as int? ?? 0;
          final credit = claim['credit'] as int? ?? 0;
          final submittedAt = claim['submission_date'] as String? ?? '';
          final rejectionReason = claim['rejection_reason'] as String?;

          Color chipColor;
          if (status == 'Approved') {
            chipColor = Colors.green.shade100;
          } else if (status == 'Rejected') {
            chipColor = Colors.red.shade100;
          } else {
            chipColor = Colors.orange.shade100;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        claim['student_name'] as String? ?? 'Student',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Claim ID ${claim['claim_id'] ?? ''}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: chipColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Submitted on ${submittedAt.split('T').first}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _ClaimInfoRow(label: 'Activity', value: activity),
                const SizedBox(height: 10),
                _ClaimInfoRow(label: 'Category', value: category),
                const SizedBox(height: 10),
                _ClaimInfoRow(label: 'Hours Submitted', value: '$hours Hours'),
                const SizedBox(height: 10),
                _ClaimInfoRow(
                  label: 'Credit Equivalent',
                  value: '$credit Credit',
                ),
                if (status == 'Rejected' &&
                    rejectionReason != null &&
                    rejectionReason.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Rejection reason',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rejectionReason,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
                const SizedBox(height: 24),
                const Text(
                  'How to proceed',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  status == 'Approved'
                      ? 'This claim is approved and your credit has been added.'
                      : status == 'Rejected'
                      ? 'If this claim was rejected, please review the reason and resubmit a correct claim from the Credits page.'
                      : 'Your claim is pending review. Please wait for approval or rejection.',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ClaimInfoRow extends StatelessWidget {
  const _ClaimInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
