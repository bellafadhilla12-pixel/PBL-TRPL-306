import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'rekap_gabungan_screen.dart';
import 'kelola_gabungan_screen.dart';
import 'login_pengurus_screen.dart';
import 'verifikasi_warga_screen.dart';
import 'kelola_antrian_pengumuman_screen.dart';

class ProfilPengurusScreen extends StatelessWidget {
  const ProfilPengurusScreen({super.key});

  static const Color darkGreen = Color(0xFF0F6E56);
  static const Color mint = Color(0xFF59C8A8);
  static const Color lime = Color(0xFFB7E868);
  static const Color background = Color(0xFFEFEDE3);
  static const Color cardWhite = Color(0xFFFFFCF8);
  static const Color greyTile = Color(0xFFE3E1DA);
  static const Color greyText = Color(0xFF7A7870);
  static const Color merah = Color(0xFFE8412F);
  static const Color orange = Color(0xFFFFCA72);

  static const List<String> _labelNav = [
    'Verifikasi Warga',
    'Kelola',
    'Antrean Warga',
    'Rekap',
    'Pengurus',
  ];

  // Nomor WhatsApp pengurus (disimpan di memori selama aplikasi berjalan)
  static final ValueNotifier<String> _nomorWa = ValueNotifier<String>(
    '0834-0968-5634',
  );

  List<BoxShadow> _shadow([double alpha = 0.12]) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: alpha),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // ====== UBAH NOMOR WHATSAPP ======
  Future<void> _ubahNomor(BuildContext context) async {
    final hasil = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => _UbahNomorDialog(nomorAwal: _nomorWa.value),
    );

    if (hasil == null) return;

    // TODO: Kirim kode OTP ke nomor baru & simpan ke Firebase bila sudah dipakai.
    _nomorWa.value = hasil;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor WhatsApp berhasil diubah')),
      );
    }
  }

  // ====== LOGOUT ======
  void _keluar(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreenPengurus()),
      (route) => false,
    );
  }

  void _konfirmasiLogout(BuildContext context) {
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
              // Ikon logout dalam lingkaran pink
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

              // Teks dengan nama dicetak tebal
              const Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(text: 'Sesi akun pengurus '),
                    TextSpan(
                      text: 'Gunawan Santoso',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          ' akan diakhiri. Anda perlu masuk kembali untuk mengelola bank sampah.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),

              Row(
                children: [
                  // Tombol Tidak
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

                  // Tombol Ya
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(dialogContext);

                        // TODO: Tambahkan proses sign out Firebase di sini bila sudah dipakai.

                        _keluar(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 16),
              _profileCard(),
              const SizedBox(height: 20),
              _judulSection(Icons.history, 'Pemulihan Sandi Pengurus'),
              const SizedBox(height: 10),
              _pemulihanCard(context),
              const SizedBox(height: 20),
              _kinerjaHeader(),
              const SizedBox(height: 10),
              _kinerjaRow(),
              const SizedBox(height: 20),
              _judulSection(Icons.blur_on, 'Posko Penimbangan'),
              const SizedBox(height: 10),
              _poskoCard(),
              const SizedBox(height: 24),
              _logoutButton(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  // ====== TOP BAR ======
  Widget _topBar() => Row(
    children: [
      Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: darkGreen,
          borderRadius: BorderRadius.circular(14),
          boxShadow: _shadow(0.2),
        ),
        child: const Icon(Icons.recycling, color: Colors.white, size: 30),
      ),
      const SizedBox(width: 12),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bank Sampah',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Plamo Garden',
              style: TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: lime,
          borderRadius: BorderRadius.circular(20),
          boxShadow: _shadow(0.15),
        ),
        child: const Text(
          'Pengurus RW 08',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );

  // ====== KARTU PROFIL ======
  Widget _profileCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F8F6E), Color(0xFF0F6E56)],
      ),
      borderRadius: BorderRadius.circular(22),
      boxShadow: _shadow(0.18),
    ),
    child: Row(
      children: [
        Container(
          width: 74,
          height: 74,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFF8FE0C4),
            shape: BoxShape.circle,
          ),
          // Ganti dengan foto: ClipOval(child: Image.asset('assets/images/pengurus.png', fit: BoxFit.cover))
          child: const Text(
            'GS',
            style: TextStyle(
              color: darkGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gunawan Santoso',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Koordinator Unit Posko RW 08',
                style: TextStyle(color: Colors.white, fontSize: 13.5),
              ),
              SizedBox(height: 2),
              Text(
                'Bank Sampah Plamo Garden Batam',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ====== JUDUL SECTION ======
  Widget _judulSection(IconData icon, String teks) => Row(
    children: [
      Icon(icon, color: darkGreen, size: 24),
      const SizedBox(width: 10),
      Text(
        teks,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ],
  );

  // ====== PEMULIHAN SANDI ======
  Widget _pemulihanCard(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: cardWhite,
      borderRadius: BorderRadius.circular(20),
      boxShadow: _shadow(0.10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kotak info
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: greyTile,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _shadow(0.12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chat_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verifikasi NO. WhatsApp Pengurus',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Daftarkan nomor WhatsApp aktif Anda. Jika lupa kata '
                      'sandi login, tautan verifikasi pemulihan (reset '
                      'password) akan otomatis dikirimkan ke WhatsApp resmi.',
                      style: TextStyle(fontSize: 11.5, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Label nomor
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nomor WhatsApp Terdaftar',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              'Aktif & Terverifikasi',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Tile nomor
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: greyTile,
            borderRadius: BorderRadius.circular(14),
            boxShadow: _shadow(0.12),
          ),
          child: Row(
            children: [
              const Icon(Icons.contacts_outlined, color: darkGreen, size: 26),
              const SizedBox(width: 14),
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: _nomorWa,
                  builder: (context, nomor, child) => Text(
                    nomor,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _ubahNomor(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Text(
                    'Ubah',
                    style: TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield_outlined, size: 16, color: greyText),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tautan pemulihan & kode verifikasi dikirim langsung oleh '
                  'bot resmi',
                  style: TextStyle(fontSize: 10, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Divider(color: Colors.black.withValues(alpha: 0.12), height: 1),
        const SizedBox(height: 12),

        const Text(
          'Minta Tautan Reset Sekarang',
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tekan tombol di bawah untuk mecoba pengiriman tautan\n'
          'token keamanan riset sandi ke nomor WhatsApp Anda.',
          style: TextStyle(fontSize: 10.5, color: Colors.black87),
        ),
        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Simulasi: tautan reset dikirim ke WhatsApp'),
                ),
              );
            },
            icon: const Icon(Icons.link, size: 20),
            label: const Text(
              'Kirim Tautan Reset Password Ke WhatsApp',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              foregroundColor: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  // ====== KINERJA POSKO ======
  Widget _kinerjaHeader() => const Row(
    children: [
      Icon(Icons.bar_chart, color: Colors.black87, size: 26),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          'Kinerja Posko Hari Ini',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      Text(
        'Sabtu, 26 Sept 2026',
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: darkGreen,
        ),
      ),
    ],
  );

  Widget _kinerjaRow() => const IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _KinerjaCard(
            icon: Icons.groups,
            iconBg: Colors.transparent,
            iconColor: Colors.black87,
            nilai: '18',
            nilaiColor: Colors.black,
            label: 'Warga Selesai',
            sub: 'Target: 24',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _KinerjaCard(
            icon: Icons.balance,
            iconBg: Color(0xFF59C8A8),
            iconColor: darkGreen,
            nilai: '142.5 kg',
            nilaiColor: darkGreen,
            label: 'Tonase Masuk',
            sub: '3 Jenis Pilah',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _KinerjaCard(
            icon: Icons.payments_outlined,
            iconBg: Color(0xFFFFCA72),
            iconColor: Color(0xFF8B6508),
            nilai: 'Rp486k',
            nilaiColor: Colors.black,
            label: 'Kas Keluar',
            sub: 'Tunai',
          ),
        ),
      ],
    ),
  );

  // ====== POSKO PENIMBANGAN ======
  Widget _poskoCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: cardWhite,
      borderRadius: BorderRadius.circular(18),
      boxShadow: _shadow(0.10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: greyTile,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _shadow(0.12),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: greyText,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lokasi Penimbangan Hari Ini',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Balai Warga RW 08',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Jl. Bougenville No. 1, Plamo Garden',
                    style: TextStyle(fontSize: 10.5, color: greyText),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(Icons.schedule, size: 20, color: darkGreen),
            SizedBox(width: 8),
            Text(
              'Jadwal Operasional:',
              style: TextStyle(fontSize: 11.5, color: Colors.black87),
            ),
            Spacer(),
            Text(
              'Sabtu, 09.00 - 12.00 WIB',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  );

  // ====== TOMBOL KELUAR ======
  Widget _logoutButton(BuildContext context) => Material(
    color: cardWhite,
    elevation: 3,
    shadowColor: Colors.black.withValues(alpha: 0.25),
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _konfirmasiLogout(context),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: merah, size: 28),
            SizedBox(width: 10),
            Text(
              'Keluar Akun Pengurus',
              style: TextStyle(
                color: merah,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // ====== BOTTOM NAV ======
  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 4,
      selectedItemColor: darkGreen,
      unselectedItemColor: Colors.black45,
      selectedFontSize: 9.5,
      unselectedFontSize: 9.5,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      onTap: (index) {
        if (index == 4) return;

        Widget? tujuan;
        switch (index) {
          case 0:
            tujuan = const VerifikasiWargaScreen();
            break;
          case 1:
            tujuan = const KelolaGabunganScreen();
            break;
          case 2:
            tujuan = const KelolaAntrianPengumumanScreen();
            break;
          case 3:
            tujuan = const RekapGabunganScreen();
            break;
        }

        if (tujuan == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Halaman "${_labelNav[index]}" belum tersedia (tahap front-end)',
              ),
            ),
          );
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => tujuan!),
        );
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline),
          label: 'Verifikasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          label: 'Kelola',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.groups_outlined),
          label: 'Antrean Warga',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Rekap'),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Pengurus',
        ),
      ],
    );
  }
}

// ====== KARTU KINERJA ======
class _KinerjaCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String nilai;
  final Color nilaiColor;
  final String label;
  final String sub;

  const _KinerjaCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.nilai,
    required this.nilaiColor,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ProfilPengurusScreen.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              nilai,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: nilaiColor,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            sub,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ====== DIALOG UBAH NOMOR WHATSAPP ======
class _UbahNomorDialog extends StatefulWidget {
  final String nomorAwal;
  const _UbahNomorDialog({required this.nomorAwal});

  @override
  State<_UbahNomorDialog> createState() => _UbahNomorDialogState();
}

class _UbahNomorDialogState extends State<_UbahNomorDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 083409685634 -> 0834-0968-5634
  String _format(String digits) {
    final bagian = <String>[];
    for (var i = 0; i < digits.length; i += 4) {
      final akhir = (i + 4 > digits.length) ? digits.length : i + 4;
      bagian.add(digits.substring(i, akhir));
    }
    return bagian.join('-');
  }

  void _simpan() {
    final digits = _controller.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      setState(() => _error = 'Nomor WhatsApp wajib diisi');
      return;
    }
    if (!digits.startsWith('0')) {
      setState(() => _error = 'Nomor harus diawali angka 0');
      return;
    }
    if (digits.length < 10 || digits.length > 13) {
      setState(() => _error = 'Nomor harus 10–13 digit');
      return;
    }

    final nomorBaru = _format(digits);
    if (nomorBaru == widget.nomorAwal) {
      setState(() => _error = 'Nomor sama dengan nomor saat ini');
      return;
    }

    Navigator.pop(context, nomorBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFFFBFA),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ikon dalam lingkaran mint
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: ProfilPengurusScreen.mint.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_iphone,
                  color: ProfilPengurusScreen.darkGreen,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Ubah Nomor WhatsApp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                  children: [
                    const TextSpan(text: 'Nomor saat ini: '),
                    TextSpan(
                      text: widget.nomorAwal,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text:
                          '\nMasukkan nomor baru untuk pemulihan sandi pengurus.',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),

              TextField(
                controller: _controller,
                autofocus: true,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
                ],
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                onSubmitted: (_) => _simpan(),
                style: const TextStyle(fontSize: 14, letterSpacing: 0.5),
                decoration: InputDecoration(
                  hintText: 'Contoh: 081234567890',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: ProfilPengurusScreen.greyText,
                  ),
                  errorText: _error,
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: ProfilPengurusScreen.darkGreen,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: ProfilPengurusScreen.greyTile,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: ProfilPengurusScreen.darkGreen,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: ProfilPengurusScreen.merah,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: ProfilPengurusScreen.merah,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
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
                        'Batal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _simpan,
                      icon: const Icon(Icons.check, size: 14),
                      label: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ProfilPengurusScreen.darkGreen,
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
}