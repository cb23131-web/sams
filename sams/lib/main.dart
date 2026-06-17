import 'package:flutter/material.dart';
import 'student/homepage.dart';
import 'fakulti/fakultihomepage.dart';
import 'treasury/treasury_homepage.dart';
import 'adab/adab_homepage.dart';
import 'lecturer/lecturer_homepage.dart';
import 'auth/registration_page.dart';

void main() {
  // Entry point: runs the app. Comment explains purpose of the function.
  runApp(const StudentAcademicApp());
}

class StudentAcademicApp extends StatelessWidget {
  const StudentAcademicApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Builds the top-level MaterialApp for the login UI.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Academic Management System',
      theme: ThemeData(
        // Define a green-based color scheme similar to the provided design.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade800),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/student': (context) => const HomePage(),
        '/fakulti': (context) => const FakultihomePage(),
        '/treasury': (context) => const TreasuryHomePage(),
        '/adab': (context) => const AdabHomePage(),
        '/lecturer': (context) => const LecturerHomePage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for the username and password text fields.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form key to validate inputs before attempting login.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to free resources when the state is removed.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    // Called when the user taps the login button.
    // Validate the form and perform a mock login action.
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      // Simple role-based routing for demo accounts.
      if (username == 'admin' && password == 'admin123') {
        Navigator.of(context).pushReplacementNamed('/fakulti');
        return;
      }

      if (username == 'treasury' && password == 'treasury123') {
        Navigator.of(context).pushReplacementNamed('/treasury');
        return;
      }

      if (username == 'adab' && password == 'adab123') {
        Navigator.of(context).pushReplacementNamed('/adab');
        return;
      }

      if (username == 'lecturer' && password == 'lecturer123') {
        Navigator.of(context).pushReplacementNamed('/lecturer');
        return;
      }

      if (username == 'ahmad' && password == 'pass123') {
        Navigator.of(context).pushReplacementNamed('/student');
        return;
      }

      // Invalid credentials: show a message and stay on login.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama pengguna atau kata laluan tidak sah'),
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
  }) {
    // Helper that constructs a styled TextFormField used for username/password.
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        // Basic validation: ensure the field is not empty.
        if (value == null || value.trim().isEmpty) {
          return 'Sila isi medan ini'; // Malay: please fill this field
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
          vertical: 18,
          horizontal: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Builds the login page UI matching the provided mockup.
    return Scaffold(
      backgroundColor: const Color(0xFF0F5132), // dark green background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top logo and title area.
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

                // The card containing the login form.
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
                          'Log Masuk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // The input form.
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Nama Pengguna',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ),
                              const SizedBox(height: 6),
                              _buildTextField(
                                controller: _usernameController,
                                hint: 'Masukkan nama pengguna',
                                icon: Icons.person,
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Kata Laluan',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ),
                              const SizedBox(height: 6),
                              _buildTextField(
                                controller: _passwordController,
                                hint: 'Masukkan kata laluan',
                                icon: Icons.lock,
                                obscureText: true,
                              ),
                              const SizedBox(height: 18),

                              // Login button.
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _onLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade800,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Log Masuk',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Demo accounts section.
                        Text(
                          'Akaun Demo:',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Admin',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'admin / admin123',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Pelajar',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'ahmad / pass123',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Lecturer',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'lecturer / lecturer123',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Registration link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Tiada akaun? ',
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/register');
                              },
                              child: const Text(
                                'Daftar sekarang',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0F5132),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer stars.
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (index) =>
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
