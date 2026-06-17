import 'package:flutter/material.dart';
import '../data/database.dart';

class AddSubjectPage extends StatefulWidget {
  const AddSubjectPage({super.key});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _schedule = TextEditingController();
  final _credits = TextEditingController(text: '3');
  final _max = TextEditingController(text: '30');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _desc.dispose();
    _schedule.dispose();
    _credits.dispose();
    _max.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subject'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/', (r) => false),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Subject',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _code,
                decoration: _buildInputDecoration('Subject Code', Icons.code),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a code' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                decoration: _buildInputDecoration(
                  'Subject Name',
                  Icons.subject,
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _desc,
                decoration: _buildInputDecoration(
                  'Description',
                  Icons.description,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _schedule,
                decoration: _buildInputDecoration(
                  'Schedule (e.g., Mon/Wed 10AM)',
                  Icons.event,
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a schedule' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _credits,
                      decoration: _buildInputDecoration('Credits', Icons.star),
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter credits'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _max,
                      decoration: _buildInputDecoration(
                        'Max Slots',
                        Icons.people,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter max slots'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Add Subject',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final s = Subject(
          code: _code.text.trim(),
          name: _name.text.trim(),
          description: _desc.text.trim(),
          schedule: _schedule.text.trim(),
          credits: int.tryParse(_credits.text) ?? 3,
          maxSlots: int.tryParse(_max.text) ?? 30,
        );
        await AppDatabase().insertSubject(s);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subject added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
