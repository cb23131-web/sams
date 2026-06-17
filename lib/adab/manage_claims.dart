import 'package:flutter/material.dart';

import '../data/database.dart';
import 'claim_detail.dart';

class ManageClaimsPage extends StatefulWidget {
  const ManageClaimsPage({super.key});

  @override
  State<ManageClaimsPage> createState() => _ManageClaimsPageState();
}

class _ManageClaimsPageState extends State<ManageClaimsPage> {
  late Future<List<Map<String, dynamic>>> _claimsFuture;

  @override
  void initState() {
    super.initState();
    _loadClaims();
  }

  void _loadClaims() {
    setState(() {
      _claimsFuture = AppDatabase().getClaimsForReview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MANAGE CLAIMS')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _claimsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final claims = snapshot.data ?? [];
            final pendingCount = claims
                .where((c) => c['status'] == 'Pending')
                .length;
            final approvedCount = claims
                .where((c) => c['status'] == 'Approved')
                .length;
            final rejectedCount = claims
                .where((c) => c['status'] == 'Rejected')
                .length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatusChip(
                      label: 'Pending',
                      value: pendingCount,
                      color: Colors.amber.shade200,
                    ),
                    _StatusChip(
                      label: 'Approved',
                      value: approvedCount,
                      color: Colors.green.shade200,
                    ),
                    _StatusChip(
                      label: 'Rejected',
                      value: rejectedCount,
                      color: Colors.red.shade100,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: claims.isEmpty
                      ? const Center(child: Text('No claims found.'))
                      : ListView.separated(
                          itemCount: claims.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final claim = claims[index];
                            return _ClaimCard(
                              claimData: claim,
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ClaimDetailPage(
                                      claimId: claim['claim_id'] as int,
                                    ),
                                  ),
                                );
                                _loadClaims();
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  const _ClaimCard({required this.claimData, required this.onTap});

  final Map<String, dynamic> claimData;
  final VoidCallback onTap;

  String get _status => claimData['status'] as String? ?? 'Pending';

  @override
  Widget build(BuildContext context) {
    final studentName = claimData['student_name'] as String? ?? 'Unknown';
    final initials = studentName
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .take(2)
        .join()
        .toUpperCase();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${claimData['activity_title'] ?? ''} · ${claimData['credit'] ?? claimData['credit_equivalent'] ?? ''} cr',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: _status),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = status == 'Pending'
        ? Colors.orange.shade100
        : status == 'Approved'
        ? Colors.green.shade100
        : Colors.red.shade100;
    final label = status[0].toUpperCase() + status.substring(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: status == 'Rejected' ? Colors.red.shade800 : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
