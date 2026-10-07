import 'package:flutter/material.dart';
import 'login_warga_screen.dart';

class LoginScreenPengurus extends StatefulWidget {
  const LoginScreenPengurus({super.key});

  @override
  State<LoginScreenPengurus> createState() =>
      _LoginScreenPengurusState();
}

class _LoginScreenPengurusState
    extends State<LoginScreenPengurus> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  static const Color darkGreen =
      Color(0xFF0F6E56);

  static const Color lightMint =
      Color(0xFFB8E0D2);

  static const Color creamBg =
      Color(0xFFF3F1E9);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =====================================================
  // LOGIN
  // =====================================================

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password =
        _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username dan kata sandi wajib diisi',
          ),
        ),
      );
      return;
    }

    // TODO:
    // Hubungkan ke Firebase Authentication
    // (username + password untuk Pengurus / UBS)

    debugPrint('Login pengurus/UBS attempt: $username');
  }

  // =====================================================
  // KE LOGIN WARGA
  // =====================================================

  void _goToLoginWarga() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const LoginScreenWarga(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lightMint,
              creamBg,
            ],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,

              children: [
                const SizedBox(height: 8),

                // =================================================
                // WELCOME
                // =================================================

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

                const SizedBox(height: 30),

                // =================================================
                // ICON
                // =================================================

                const SizedBox(
                  height: 180,
                  child: Center(
                    child: Icon(
                      Icons.security_rounded,
                      size: 180,
                      color: darkGreen,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // LOGIN HEADER
                // =================================================

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),

                  decoration:
                      BoxDecoration(
                    color: darkGreen,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),

                  child: const Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),

                      SizedBox(width: 8),

                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // USERNAME
                // =================================================

                _buildInputField(
                  controller: _usernameController,
                  hint: 'Username',
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 12),

                // =================================================
                // PASSWORD
                // =================================================

                _buildInputField(
                  controller:
                      _passwordController,
                  hint: 'Masukkan kata sandi',
                  icon: Icons.lock_outline,
                  obscureText:
                      _obscurePassword,

                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons
                              .visibility_off_outlined
                          : Icons
                              .visibility_outlined,
                      color: darkGreen,
                    ),

                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // LUPA PASSWORD
                // =================================================

                Align(
                  alignment:
                      Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      // TODO:
                      // Navigasi lupa password
                    },

                    child: const Text(
                      'Lupa kata sandi?',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // =================================================
                // LOGIN BUTTON
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 56,

                  child: ElevatedButton(
                    onPressed: _handleLogin,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      foregroundColor:
                          Colors.white,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),

                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // KE LOGIN WARGA
                // =================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    const Text(
                      'Apakah Anda Warga? ',
                    ),

                    GestureDetector(
                      onTap: _goToLoginWarga,

                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // INPUT FIELD
  // =====================================================

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,

    TextInputType keyboardType =
        TextInputType.text,

    bool obscureText = false,

    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: TextField(
        controller: controller,

        keyboardType: keyboardType,

        obscureText: obscureText,

        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),

            padding:
                const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),

          suffixIcon: suffixIcon,

          hintText: hint,

          hintStyle:
              const TextStyle(
            color: Colors.grey,
          ),

          border: InputBorder.none,

          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 12,
          ),
        ),
      ),
    );
  }
}