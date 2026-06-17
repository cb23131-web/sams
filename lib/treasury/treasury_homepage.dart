import 'package:flutter/material.dart';

class TreasuryHomePage extends StatefulWidget {
  const TreasuryHomePage({super.key});

  @override
  State<TreasuryHomePage> createState() => _TreasuryHomePageState();
}

class _TreasuryHomePageState extends State<TreasuryHomePage> {
  int _selectedBottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SAMS'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'HOMEPAGE',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1,
              children: [
                _buildFeatureCard(
                  label: 'Attendance',
                  icon: Icons.event_available,
                  onTap: () => _showComingSoon(context),
                ),
                _buildFeatureCard(
                  label: 'Subject Lists',
                  icon: Icons.menu_book,
                  onTap: () => _showComingSoon(context),
                ),
                _buildFeatureCard(
                  label: 'Curriculum Registration',
                  icon: Icons.assignment_turned_in,
                  onTap: () => _showComingSoon(context),
                ),
                _buildFeatureCard(
                  label: 'Fees',
                  icon: Icons.receipt_long,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TreasuryFeeSummaryPage(),
                      ),
                    );
                  },
                ),
                _buildFeatureCard(
                  label: 'Activities',
                  icon: Icons.local_activity,
                  onTap: () => _showComingSoon(context),
                ),
                _buildFeatureCard(
                  label: 'Credits',
                  icon: Icons.credit_score,
                  onTap: () => _showComingSoon(context),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomIndex,
        onTap: (index) => setState(() => _selectedBottomIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(icon, size: 32, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Coming soon')));
  }
}

class TreasuryStudent {
  String id;
  String name;
  String status;
  String semester;
  String billed;
  String balance;
  String totalPaid;
  String passport;
  String phone;
  List<Map<String, String>> paymentHistory;

  TreasuryStudent({
    required this.id,
    required this.name,
    required this.status,
    required this.semester,
    required this.billed,
    required this.balance,
    required this.totalPaid,
    required this.passport,
    required this.phone,
    required this.paymentHistory,
  });
}

class TreasuryFeeSummaryPage extends StatefulWidget {
  const TreasuryFeeSummaryPage({super.key});

  @override
  State<TreasuryFeeSummaryPage> createState() => _TreasuryFeeSummaryPageState();
}

class _TreasuryFeeSummaryPageState extends State<TreasuryFeeSummaryPage> {
  final TreasuryStudent student = TreasuryStudent(
    id: 'CB23073',
    name: 'MOHD NUR QHUZAIREY BIN RUSLAN',
    status: 'PENDING',
    semester: 'Semester 2 2025/2026',
    billed: 'RM 6,000',
    balance: 'RM 1,500',
    totalPaid: 'RM 4,500',
    passport: '0411112xxxx',
    phone: '011xxxxxxxx',
    paymentHistory: [
      {'date': '04/10/2025', 'amount': 'RM 1,500', 'status': 'PAID'},
      {'date': '01/04/2025', 'amount': 'RM 1,500', 'status': 'PAID'},
      {'date': '25/10/2024', 'amount': 'RM 1,500', 'status': 'PAID'},
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FEES'),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'FEES',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fee Balance: ${student.balance}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Paid ${student.totalPaid}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: student.balance == 'RM 0.00'
                    ? null
                    : () async {
                        final paid = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) =>
                                TreasuryPaymentPage(student: student),
                          ),
                        );
                        if (paid == true) {
                          setState(() {});
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
                child: const Text('Pay'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Payment History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPaymentHistoryTable(student.paymentHistory),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryTable(List<Map<String, String>> items) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          ...items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text(item['date']!)),
                  Expanded(flex: 3, child: Text(item['amount']!)),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item['status']!,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class TreasuryPaymentPage extends StatefulWidget {
  final TreasuryStudent student;
  const TreasuryPaymentPage({super.key, required this.student});

  @override
  State<TreasuryPaymentPage> createState() => _TreasuryPaymentPageState();
}

class _TreasuryPaymentPageState extends State<TreasuryPaymentPage> {
  String _selectedMethod = 'Internet Banking';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FEES')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'FEES',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            'Payment for: Tuition Fee ${widget.student.id}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text('Payment Total: ${widget.student.balance}'),
          const SizedBox(height: 8),
          Text('Student ID: ${widget.student.id}'),
          const SizedBox(height: 8),
          Text('Passport / IC no.: ${widget.student.passport}'),
          const SizedBox(height: 8),
          Text('Name: ${widget.student.name}'),
          const SizedBox(height: 8),
          Text('Phone Number: ${widget.student.phone}'),
          const SizedBox(height: 24),
          const Text(
            'Choose Payment Method:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildPaymentOption('Internet Banking'),
          _buildPaymentOption('Credit Card / Debit Card'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _PaymentLogo(icon: Icons.flash_on, label: 'FPX'),
              _PaymentLogo(icon: Icons.account_balance, label: 'VISA'),
              _PaymentLogo(icon: Icons.credit_card, label: 'MasterCard'),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: widget.student.balance == 'RM 0.00'
                ? null
                : () {
                    setState(() {
                      widget.student.status = 'PAID';
                      widget.student.totalPaid = 'RM 6,000';
                      widget.student.balance = 'RM 0.00';
                      widget.student.paymentHistory.insert(0, {
                        'date': '09/04/2026',
                        'amount': 'RM 1,500',
                        'status': 'PAID',
                      });
                    });
                    Navigator.of(context).pop(true);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String label) {
    return RadioListTile<String>(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: label,
      groupValue: _selectedMethod,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedMethod = value;
          });
        }
      },
    );
  }
}

class _PaymentLogo extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PaymentLogo({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.black87),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
