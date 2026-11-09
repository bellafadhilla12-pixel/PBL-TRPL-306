import 'package:flutter/material.dart';

import '../../services/api_client.dart';
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
  bool _isLoading = false;

  static const Color darkGreen = Color(0xFF0F6E56);
  static const Color lightMint = Color(0xFFB8E0D2);
  static const Color creamBg = Color(0xFFF3F1E9);

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final identity = _identityController.text.trim();
    final password = _passwordController.text.trim();

    if (identity.isEmpty || password.isEmpty) {
      _showMessage('Nomor WhatsApp dan kata sandi wajib diisi');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Backend memvalidasi akun dan mengembalikan role.
      final res = await ApiClient.login(whatsapp: identity, password: password);

      if (!mounted) return;

      if (!res.isSuccess) {
        _showMessage(res.firstError);
        return;
      }

      final role = res.body['role']?.toString() ?? 'warga';

      switch (role) {
        case 'pengurus':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const VerifikasiWargaScreen(),
            ),
          );
        case 'ubs':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfileUbs()),
          );
        default:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WhatsAppGatePage()),
          );
      }
    } catch (_) {
      if (mounted) {
        _showMessage(
          'Tidak bisa terhubung ke server. Pastikan backend Laravel berjalan.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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
                  hint: 'Nomor WhatsApp',
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
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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
