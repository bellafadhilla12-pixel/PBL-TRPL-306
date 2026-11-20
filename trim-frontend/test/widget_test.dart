import 'package:flutter_test/flutter_test.dart';

import 'package:trim_pbl306/main.dart';

void main() {
  testWidgets('halaman login tampil saat aplikasi dibuka', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Log In'), findsOneWidget);
    expect(find.text('Daftar Akun'), findsOneWidget);
  });
}
