import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pengurus/login_pengurus_screen.dart';
import 'rekap_ubs_screen.dart';

class ProfileUbs extends StatefulWidget {
  const ProfileUbs({super.key});

  @override
  State<ProfileUbs> createState() => _ProfileUbsState();
}

class _ProfileUbsState extends State<ProfileUbs> {
  static const Color green = Color(0xFF08785F);
  static const Color background = Color(0xFFF1F0EA);

  String nomorWhatsApp = '0845-7865-0934';

  void bukaWhatsApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulasi: tautan reset password dikirim via WhatsApp'),
      ),
    );
  }

  void salinNomor() {
    Clipboard.setData(ClipboardData(text: nomorWhatsApp));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nomor WhatsApp berhasil disalin')),
    );
  }

  // POP-UP UBAH NOMOR WHATSAPP
  Future<void> ubahNomorWhatsApp() async {
    final hasil = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) {
        return _UbahNomorDialog(nomorAwal: nomorWhatsApp);
      },
    );

    if (hasil == null || !mounted) return;

    setState(() {
      nomorWhatsApp = hasil;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nomor WhatsApp berhasil diubah')),
    );
  }

  // LOGOUT
  void konfirmasiLogout() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFFFFFBFA),
        insetPadding: const EdgeInsets.symmetric(horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9A9A3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFE53935),
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Apakah Anda yakin ingin keluar?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(text: 'Sesi akun UBS '),
                    TextSpan(
                      text: 'Bpk. H. Rahmat Hidayat, S.T',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' akan diakhiri. Anda perlu masuk kembali untuk mengakses rekap bank sampah.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE0E0E0),
                        foregroundColor: Colors.black,
                        elevation: 3,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Tidak',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreenPengurus(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.check, size: 14),
                      label: const Text(
                        'Ya',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF04B42),
                        foregroundColor: Colors.white,
                        elevation: 3,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFA),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerBankSampah(),
              const SizedBox(height: 12),
              profilPetugas(),
              const SizedBox(height: 14),
              judulSection(Icons.history, 'Pemulihan Sandi Akun UBS'),
              const SizedBox(height: 9),
              cardVerifikasi(),
              const SizedBox(height: 10),
              cardCakupan(),
              const SizedBox(height: 32),
              tombolLogout(),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Dinas Lingkungan Hidup & Kebersihan Kota Batam',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: bottomNavigation(),
    );
  }

  Widget headerBankSampah() {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.recycling, color: Colors.white, size: 29),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bank Sampah',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                'Pusat Logistik | Mitra DLH Batam',
                style: TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFB5ED69),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Unit Bank\nSampah',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget profilPetugas() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF006B55), Color(0xFF09BA8D)],
        ),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: ClipOval(
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bpk. H. Rahmat Hidayat, S.T',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Koordinator Utama Unit Bank Sampah (UBS)',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                SizedBox(height: 4),
                Text(
                  'Pusat Pengelolaan & Logistik Batam Kota',
                  style: TextStyle(color: Colors.white70, fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget judulSection(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF57734D), size: 19),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget cardVerifikasi() {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3E2DD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.message_outlined,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 9),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verifikasi No. WhatsApp UBS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Daftarkan nomor WhatsApp penanggung jawab UBS. Jika lupa kata sandi login, tautan verifikasi pemulihan (reset password) akan otomatis dikirimkan ke WhatsApp resmi.',
                        style: TextStyle(fontSize: 10, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nomor WhatsApp Pendaftar',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              Text(
                'Aktif & Terverifikasi',
                style: TextStyle(
                  color: Color(0xFF668A36),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // NOMOR WHATSAPP DAN TOMBOL UBAH
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1E9),
              border: Border.all(color: const Color(0xFFCDD5BD)),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.contact_phone_outlined,
                  color: Color(0xFF648657),
                  size: 19,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: salinNomor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        nomorWhatsApp,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: ubahNomorWhatsApp,
                  style: TextButton.styleFrom(
                    foregroundColor: green,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Ubah',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF668A36),
                size: 18,
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Tautan pemulihan & kode verifikasi dikirim langsung oleh bot resmi.',
                  style: TextStyle(fontSize: 10, height: 1.3),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          const Text(
            'Minta Tautan Reset Sekarang',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            'Tekan tombol di bawah untuk mencoba pengiriman tautan login sementara lewat sandi ke nomor WhatsApp Anda.',
            style: TextStyle(fontSize: 10, height: 1.3),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: bukaWhatsApp,
              icon: const Icon(Icons.link, size: 18, color: Colors.white),
              label: const Text(
                'Kirim Tautan Reset Password via WhatsApp',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardCakupan() {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.settings_outlined, color: Color(0xFF77956A), size: 19),
              SizedBox(width: 7),
              Text(
                'CAKUPAN WILAYAH & MITRA INDUK',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          infoCakupan(
            Icons.storefront,
            const Color(0xFF3FC5A3),
            'UNIT POSKO TERDAFTAR',
            '12 Posko Unit Binaan (Termasuk RW 08 Prima Garden)',
          ),
          const SizedBox(height: 12),
          infoCakupan(
            Icons.account_balance,
            const Color(0xFFFFB83F),
            'GUDANG & TIMBANGAN INDUK',
            'Pusat Daur Ulang (PDU) Baloi Permai',
          ),
        ],
      ),
    );
  }

  Widget infoCakupan(
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(icon, color: Colors.white, size: 17),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tombolLogout() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: konfirmasiLogout,
        icon: const Icon(Icons.logout, color: Colors.red, size: 20),
        label: const Text(
          'Keluar Akun Petugas UBS',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFBFA),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }

 Widget bottomNavigation() {
  return BottomNavigationBar(
    currentIndex: 1,
    type: BottomNavigationBarType.fixed,
    backgroundColor: const Color(0xFFF8FCFA),
    selectedItemColor: const Color(0xFF0F6E56),
    unselectedItemColor: Colors.black45,
    selectedFontSize: 9.5,
    unselectedFontSize: 9.5,
    selectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.w700,
    ),
    elevation: 8,
    onTap: (index) {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RekapUbsScreen(),
          ),
        );
      }
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_outlined),
        activeIcon: Icon(Icons.receipt_long),
        label: 'Rekap',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'UBS',
      ),
    ],
  );
}

  Widget navigationItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: green, size: 27),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: green,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// DIALOG UBAH NOMOR WHATSAPP
// =====================================================

class _UbahNomorDialog extends StatefulWidget {
  final String nomorAwal;

  const _UbahNomorDialog({required this.nomorAwal});

  @override
  State<_UbahNomorDialog> createState() => _UbahNomorDialogState();
}

class _UbahNomorDialogState extends State<_UbahNomorDialog> {
  late final TextEditingController controller;
  String? errorText;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.nomorAwal.replaceAll('-', ''),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String formatNomor(String nomor) {
    final digit = nomor.replaceAll(RegExp(r'\D'), '');
    final hasil = <String>[];

    for (int i = 0; i < digit.length; i += 4) {
      hasil.add(
        digit.substring(i, i + 4 > digit.length ? digit.length : i + 4),
      );
    }

    return hasil.join('-');
  }

  void simpanNomor() {
    final nomor = controller.text.replaceAll(RegExp(r'\D'), '');

    if (!nomor.startsWith('0') || nomor.length < 10 || nomor.length > 13) {
      setState(() {
        errorText = 'Nomor harus diawali 0 dan terdiri dari 10–13 digit.';
      });
      return;
    }

    final nomorLama = widget.nomorAwal.replaceAll('-', '');

    if (nomor == nomorLama) {
      setState(() {
        errorText = 'Masukkan nomor yang berbeda.';
      });
      return;
    }

    Navigator.pop(context, formatNomor(nomor));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFFFBFA),
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.phone_android_rounded,
                color: Color(0xFF08785F),
                size: 38,
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Ubah Nomor WhatsApp',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan nomor WhatsApp baru untuk akun UBS.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 18),
            const Text(
              'Nomor WhatsApp',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(13),
              ],
              onChanged: (_) {
                if (errorText != null) {
                  setState(() {
                    errorText = null;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: '08xxxxxxxxxx',
                prefixIcon: const Icon(Icons.phone, color: Color(0xFF08785F)),
                errorText: errorText,
                filled: true,
                fillColor: const Color(0xFFF0F1E9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFCDD5BD)),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: simpanNomor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF08785F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
