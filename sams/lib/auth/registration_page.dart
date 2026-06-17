import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedRole = 'student';
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator:
              validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Sila isi medan ini';
                }
                return null;
              },
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.green.shade900),
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kata laluan tidak sepadan')),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final username = _usernameController.text.trim();

        // For now, we'll just show a success message and navigate back to login
        // In a real app, this would call a backend API or save to database
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pendaftaran berjaya untuk $username. Sila log masuk dengan akaun anda.',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Wait a moment then navigate back to login
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ralat: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F5132),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(height: 12),

                // Logo and title
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.green.shade700,
                  child: const Icon(
                    Icons.menu_book,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Student Academic Management System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sistem Pengurusan Akademik Pelajar',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green.shade200, fontSize: 13),
                ),
                const SizedBox(height: 24),

                // Registration card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Pendaftaran Akaun Baru',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Registration form
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Full Name
                              _buildTextField(
                                controller: _fullNameController,
                                hint: 'Masukkan nama penuh',
                                label: 'Nama Penuh',
                                icon: Icons.person,
                              ),
                              const SizedBox(height: 12),

                              // Student ID (optional)
                              _buildTextField(
                                controller: _studentIdController,
                                hint: 'Cth: BCS22001',
                                label: 'ID Pelajar (Opsional)',
                                icon: Icons.badge,
                              ),
                              const SizedBox(height: 12),

                              // Username
                              _buildTextField(
                                controller: _usernameController,
                                hint: 'Masukkan nama pengguna',
                                label: 'Nama Pengguna',
                                icon: Icons.account_circle,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Sila isi medan ini';
                                  }
                                  if (value.length < 4) {
                                    return 'Nama pengguna mesti sekurang-kurangnya 4 aksara';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Email
                              _buildTextField(
                                controller: _emailController,
                                hint: 'Masukkan e-mel',
                                label: 'E-mel',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Sila isi medan ini';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Sila masukkan e-mel yang sah';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Role selection
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Peranan',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedRole,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'student',
                                        child: Row(
                                          children: const [
                                            Icon(Icons.school, size: 18),
                                            SizedBox(width: 8),
                                            Text('Pelajar'),
                                          ],
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'lecturer',
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.person_outline,
                                              size: 18,
                                            ),
                                            SizedBox(width: 8),
                                            Text('Pensyarah'),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() => _selectedRole = value!);
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 16,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Password
                              _buildTextField(
                                controller: _passwordController,
                                hint: 'Masukkan kata laluan',
                                label: 'Kata Laluan',
                                icon: Icons.lock,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Sila isi medan ini';
                                  }
                                  if (value.length < 6) {
                                    return 'Kata laluan mesti sekurang-kurangnya 6 aksara';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Confirm Password
                              _buildTextField(
                                controller: _confirmPasswordController,
                                hint: 'Sahkan kata laluan',
                                label: 'Sahkan Kata Laluan',
                                icon: Icons.lock,
                                obscureText: true,
                              ),
                              const SizedBox(height: 18),

                              // Register button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _onRegister,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade800,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text(
                                          'Daftar Akaun',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
