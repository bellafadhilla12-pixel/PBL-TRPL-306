import 'package:flutter/material.dart';
import 'login_warga_screen.dart';

class RegistrasiWargaScreen extends StatefulWidget {
  const RegistrasiWargaScreen({super.key});

  @override
  State<RegistrasiWargaScreen> createState() =>
      _RegistrasiWargaScreenState();
}

class _RegistrasiWargaScreenState
    extends State<RegistrasiWargaScreen> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final whatsappController = TextEditingController();
  final passwordController = TextEditingController();
  final blokController = TextEditingController();
  final nomorRumahController = TextEditingController();
  final rtController = TextEditingController();
  final rwController = TextEditingController();

  bool _obscurePassword = true;

  static const Color darkGreen =
      Color(0xFF087A63);

  static const Color mint =
      Color(0xFF59C8A8);

  static const Color orange =
      Color(0xFFFFCA72);

  static const Color background =
      Color(0xFFF5F3EA);

  @override
  void dispose() {
    namaController.dispose();
    whatsappController.dispose();
    passwordController.dispose();
    blokController.dispose();
    nomorRumahController.dispose();
    rtController.dispose();
    rwController.dispose();

    super.dispose();
  }

  // =====================================================
  // REGISTRASI
  // =====================================================

  void _registrasi() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nama = namaController.text.trim();
    final whatsapp =
        whatsappController.text.trim();
    final password =
        passwordController.text.trim();
    final blok = blokController.text.trim();
    final nomorRumah =
        nomorRumahController.text.trim();
    final rt = rtController.text.trim();
    final rw = rwController.text.trim();

    debugPrint('Nama: $nama');
    debugPrint('WhatsApp: $whatsapp');
    debugPrint('Password: $password');
    debugPrint('Blok: $blok');
    debugPrint('Nomor Rumah: $nomorRumah');
    debugPrint('RT: $rt');
    debugPrint('RW: $rw');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Data registrasi berhasil diisi',
        ),
      ),
    );

    // TODO:
    // Hubungkan data registrasi ke Firebase
  }

  // =====================================================
  // INPUT DECORATION
  // =====================================================

  InputDecoration _inputDecoration({
  required String hint,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Color(0xFF0B4A3C),
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    prefixIcon: Icon(
      icon,
      color: const Color(0xFF0B4A3C),
    ),
    filled: true,
    fillColor: mint,
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );
}
  // =====================================================
  // CARD
  // =====================================================

  Widget _sectionCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // =====================================================
  // SMALL ADDRESS INPUT
  // =====================================================

  Widget _smallInput({
    required String label,
    required TextEditingController controller,
  }) {
    String hint = '';

    if (label == 'Blok Rumah') {
      hint = 'Masukkan blok rumah';
    } else if (label == 'Nomor Rumah') {
      hint = 'Masukkan nomor rumah';
    } else if (label == 'Rukun Tetangga (RT)') {
      hint = 'Masukkan RT';
    } else if (label == 'Rukun Warga (RW)') {
      hint = 'Masukkan RW';
    }

    return Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Wajib diisi';
              }

              return null;
            },
            decoration: InputDecoration(
              hintText: hint,

              // OPACITY TULISAN PLACEHOLDER
              hintStyle: TextStyle(
                color: const Color(0xFF555555)
                    .withValues(alpha: 0.5),
                fontSize: 13,
              ),

              filled: true,
              fillColor: orange,

              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(13),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            39,
            25,
            39,
            35,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // =================================================
                // HEADER
                // =================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment:
                          Alignment.center,
                      decoration:
                          const BoxDecoration(
                        color: Color(0xFFE6E4DD),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'Logo',
                        style:
                            TextStyle(fontSize: 11),
                      ),
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons
                              .account_circle_outlined,
                          size: 35,
                          color: darkGreen,
                        ),

                        const SizedBox(
                          width: 15,
                        ),

                        const Icon(
                          Icons.logout,
                          size: 25,
                          color: darkGreen,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // =================================================
                // BANNER
                // =================================================

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    13,
                    20,
                    18,
                  ),
                  decoration:
                      BoxDecoration(
                    color: darkGreen,
                    borderRadius:
                        BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.20),
                        blurRadius: 7,
                        offset:
                            const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration:
                            BoxDecoration(
                          color: mint,
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: const Text(
                          'Komunitas Mandiri RT/RW',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      const Text(
                        'Daftar Akun Bank Sampah\n'
                        'Plamo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      const Text(
                        'Ubah sampah rumah tangga jadi saldo\n'
                        'tabungan bernilai & lingkungan lebih asri.',
                        style: TextStyle(
                          color:
                              Color(0xFF62BCA5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // =================================================
                // REGISTRASI WARGA HEADER
                // =================================================

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 18,
                  ),
                  decoration:
                      BoxDecoration(
                    color: darkGreen,
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.app_registration,
                        color: Colors.white,
                        size: 20,
                      ),

                      SizedBox(width: 10),

                      Text(
                        'Registrasi Warga',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // =================================================
                // DATA DIRI
                // =================================================

                _sectionCard(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Row(
                        children: [
                          Icon(
                            Icons
                                .document_scanner_outlined,
                            size: 25,
                          ),

                          SizedBox(width: 8),

                          Text(
                            'Data Diri',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // NAMA

                      const Text(
                        'Nama Lengkap Warga',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(
                        height: 7,
                      ),

                      TextFormField(
                        controller:
                            namaController,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Nama wajib diisi';
                          }

                          return null;
                        },
                        decoration:
                            _inputDecoration(
                          hint:
                              'Contoh: Bpk. Bambang Sutrisno',
                          icon:
                              Icons.person_outline,
                        ),
                      ),

                      const SizedBox(
                        height: 13,
                      ),

                      // WHATSAPP

                      const Text(
                        'Nomor WhatsApp Aktif',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(
                        height: 7,
                      ),

                      TextFormField(
                        controller:
                            whatsappController,
                        keyboardType:
                            TextInputType.phone,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Nomor WhatsApp wajib diisi';
                          }

                          return null;
                        },
                        decoration:
                            _inputDecoration(
                          hint:
                              'Masukkan Nomor WhatsApp aktif',
                          icon:
                              Icons.chat_outlined,
                        ),
                      ),

                      const SizedBox(
                        height: 7,
                      ),

                      // KETERANGAN WHATSAPP

                      Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(
                        12,
                      ),
                      decoration:
                          BoxDecoration(
                        color: mint,
                        borderRadius:
                            BorderRadius.circular(
                          13,
                        ),
                      ),
                      child: const Text(
                        'Masukkan nomor WhatsApp aktif agar '
                        'mempermudah pengelolaan akun',
                        style: TextStyle(
                          color: Color(0xFF0B4A3C),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                      const SizedBox(
                        height: 13,
                      ),

                      // PASSWORD

                      const Text(
                        'Kata Sandi',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(
                        height: 7,
                      ),

                      TextFormField(
                        controller:
                            passwordController,
                        obscureText:
                            _obscurePassword,
                        validator: (value) {
                          if (value == null ||
                              value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }

                          return null;
                        },
                        decoration:
                            _inputDecoration(
                          hint:
                              'Buat kata sandi',
                          icon:
                              Icons.lock_outline,
                        ).copyWith(
                          suffixIcon:
                              IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons
                                      .visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                    !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // =================================================
                // ALAMAT RUMAH
                // =================================================

                _sectionCard(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        'Alamat Rumah',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Row(
                        children: [
                          _smallInput(
                            label: 'Blok Rumah',
                            controller:
                                blokController,
                          ),

                          const SizedBox(
                            width: 28,
                          ),

                          _smallInput(
                            label: 'Nomor Rumah',
                            controller:
                                nomorRumahController,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      Row(
                        children: [
                          _smallInput(
                            label:
                                'Rukun Tetangga (RT)',
                            controller:
                                rtController,
                          ),

                          const SizedBox(
                            width: 28,
                          ),

                          _smallInput(
                            label:
                                'Rukun Warga (RW)',
                            controller:
                                rwController,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =================================================
                // DAFTAR AKUN
                // =================================================

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: _registrasi,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          'Daftar Akun Sekarang',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        SizedBox(width: 7),

                        Icon(
                          Icons
                              .arrow_circle_right,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // =================================================
                // KEMBALI KE LOGIN
                // =================================================

                const Center(
                  child: Text(
                    'Sudah terdaftar sebagai nasabah?',
                    style:
                        TextStyle(fontSize: 12),
                  ),
                ),

                const SizedBox(height: 7),

                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LoginScreenWarga(),
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Masuk dengan Nomor WhatsApp ➜',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
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