import 'package:flutter/material.dart';

import 'kelola_edukasi_screen.dart';
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

  List<BoxShadow> _shadow([double alpha = 0.12]) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: alpha),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  void _keluar(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreenPengurus()),
      (route) => false,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nomor WhatsApp Terdaftar',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const Text(
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
              const Expanded(
                child: Text(
                  '0834-0968-5634',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Ubah nomor belum tersedia (tahap front-end)',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Ubah',
                  style: TextStyle(
                    color: darkGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
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
  Widget _kinerjaHeader() => Row(
    children: [
      const Icon(Icons.bar_chart, color: Colors.black87, size: 26),
      const SizedBox(width: 10),
      const Expanded(
        child: Text(
          'Kinerja Posko Hari Ini',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      const Text(
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
      onTap: () => _keluar(context),
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
            tujuan = const KelolaEdukasiPengurusScreen();
            break;
          case 2:
            tujuan = const KelolaAntrianPengumumanScreen();
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
