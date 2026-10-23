import 'package:flutter/material.dart';

import '../pengurus/verifikasi_warga_screen.dart';
import '../ubs/profil_ubs.dart';
import 'registrasi_warga_screen.dart';
import 'whatsapp_gate_page.dart';

class LoginScreenWarga extends StatefulWidget {
  const LoginScreenWarga({super.key});

  @override
  State<LoginScreenWarga> createState() => _LoginScreenWargaState();
}

class _LoginScreenWargaState extends State<LoginScreenWarga> {
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  static const Color darkGreen = Color(0xFF0F6E56);
  static const Color lightMint = Color(0xFFB8E0D2);
  static const Color creamBg = Color(0xFFF3F1E9);

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final identity = _identityController.text.trim();
    final password = _passwordController.text.trim();

    if (identity.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor WhatsApp/username dan kata sandi wajib diisi'),
        ),
      );
      return;
    }

    // DEMO FRONT-END SEMENTARA:
    // Kredensial role Pengurus/UBS mengikuti dummy dari implementasi lama.
    // Identitas lain diarahkan ke alur Warga seperti implementasi sebelumnya.
    // Saat API tersedia, ganti blok ini dengan respons login dari backend:
    // backend memvalidasi akun dan mengembalikan role, lalu Flutter
    // mengarahkan pengguna sesuai role tersebut.
    final normalizedIdentity = identity.toLowerCase();

    if (normalizedIdentity == 'pengurus') {
      if (password == '123') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VerifikasiWargaScreen()),
        );
      } else {
        _showInvalidCredentials();
      }
      return;
    }

    if (normalizedIdentity == 'ubs') {
      if (password == '555') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileUbs()),
        );
      } else {
        _showInvalidCredentials();
      }
      return;
    }

    // Simulasi login Warga. Belum melakukan autentikasi ke database/API.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WhatsAppGatePage()),
    );
  }

  void _showInvalidCredentials() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username atau kata sandi salah')),
    );
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegistrasiWargaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightMint, creamBg],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Welcome\nBack!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: darkGreen,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 190,
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo_trim_fix.png',
                      height: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.recycling_rounded,
                        size: 120,
                        color: darkGreen,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 45),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: darkGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  controller: _identityController,
                  hint: 'Nomor WhatsApp / Username',
                  icon: Icons.smartphone_outlined,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 12),
                _buildInputField(
                  controller: _passwordController,
                  hint: 'Masukkan kata sandi',
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: darkGreen,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Fitur lupa kata sandi akan dihubungkan ke API.',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Lupa kata sandi?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _goToRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Daftar Akun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
