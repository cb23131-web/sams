import 'package:flutter/material.dart';

class AdabHomePage extends StatelessWidget {
  const AdabHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADAB HOME'),
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.book, size: 96, color: Colors.blueGrey),
            SizedBox(height: 20),
            Text(
              'Adab Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Welcome to the Adab faculty portal.'),
          ],
        ),
      ),
    );
  }
}
