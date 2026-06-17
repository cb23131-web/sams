import 'package:flutter_test/flutter_test.dart';

import 'package:sams/main.dart';

void main() {
  testWidgets('Login page is shown', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentAcademicApp());

    expect(find.text('Log Masuk'), findsNWidgets(2));
    expect(find.text('Nama Pengguna'), findsOneWidget);
    expect(find.text('Kata Laluan'), findsOneWidget);
    expect(find.text('Daftar sekarang'), findsOneWidget);
  });
}
