import 'package:flutter/material.dart';

import '../warga/login_warga_screen.dart';

/// Kompatibilitas untuk navigasi lama yang masih membuka LoginScreenPengurus.
/// Login sekarang menggunakan satu tampilan tanpa dropdown role.
class LoginScreenPengurus extends StatelessWidget {
  const LoginScreenPengurus({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreenWarga();
  }
}
