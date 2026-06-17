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
  final TextEditingController _reasonController = TextEditingController();
  String? _actionMessage;

  @override
  void initState() {
    super.initState();
    _loadClaim();
  }

  void _loadClaim() {
    setState(() {
      _claimFuture = AppDatabase().getClaimDetailById(widget.claimId);
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _approveClaim(Map<String, dynamic> claim) async {
    await AppDatabase().updateClaimStatus(
      claim['claim_id'] as int,
      'Approved',
      verifiedHours: claim['hours'] as int? ?? 0,
      creditEquivalent: claim['credit'] as int? ?? 0,
      rejectionReason: null,
    );

    setState(() {
      _actionMessage =
          'Approving will award ${claim['credit']} credit to ${claim['student_name']}.';
    });
    _loadClaim();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Claim approved')));
  }

  Future<void> _rejectClaim(Map<String, dynamic> claim) async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a rejection reason')),
      );
      return;
    }
    await AppDatabase().updateClaimStatus(
      claim['claim_id'] as int,
      'Rejected',
      verifiedHours: 0,
      creditEquivalent: 0,
      rejectionReason: reason,
    );

    setState(() {
      _actionMessage = 'Rejected: $reason';
    });
    _loadClaim();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Claim rejected')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CLAIM DETAIL'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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

          final studentName = claim['student_name'] as String? ?? '';
          final initials = studentName
              .split(' ')
              .where((part) => part.isNotEmpty)
              .map((part) => part[0])
              .take(2)
              .join()
              .toUpperCase();
          final status = claim['status'] as String? ?? 'Pending';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              claim['student_name'] as String? ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Claim ID ${claim['claim_id']}',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              claim['activity_title'] as String? ?? '',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailRow(
                        label: 'Activity',
                        value: claim['activity_title'] as String? ?? '',
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: 'Verified Hours',
                        value: '${claim['hours'] ?? 0} Hours',
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: 'Credit Equivalent',
                        value: '${claim['credit'] ?? 0} academic credit',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter reason here...',
                    labelText: 'Rejection reason (if rejecting)',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_actionMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _actionMessage!,
                      style: TextStyle(color: Colors.green.shade900),
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: status == 'Approved'
                            ? null
                            : () => _approveClaim(claim),
                        child: const Text('Approve'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: status == 'Rejected'
                            ? null
                            : () => _rejectClaim(claim),
                        child: const Text('Reject'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
