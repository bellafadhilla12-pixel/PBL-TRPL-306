import 'package:flutter/material.dart';

import 'login_warga_screen.dart';

import 'beranda_warga_screen.dart';

class ProfilWargaScreen extends StatelessWidget {
  const ProfilWargaScreen({super.key});

  static const Color darkGreen = Color(0xFF0F6E56);
  static const Color mint = Color(0xFF59C8A8);
  static const Color orange = Color(0xFFFFCA72);
  static const Color orangeDark = Color(0xFFEF9F27);
  static const Color background = Color(0xFFEFEDE3);
  static const Color cardWhite = Color(0xFFFFFCF8);
  static const Color greyTile = Color(0xFFE3E1DA);
  static const Color greyText = Color(0xFF7A7870);
  static const Color merah = Color(0xFFE8412F);

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
      MaterialPageRoute(builder: (context) => const LoginScreenWarga()),
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              _topBar(context),
              const SizedBox(height: 16),
              _profileCard(),
              const SizedBox(height: 20),
              _aksesCard(),
              const SizedBox(height: 20),
              _domisiliCard(),
              const SizedBox(height: 20),
              _logoutButton(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  // ====== TOP BAR ======
  Widget _topBar(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const Icon(Icons.account_circle_outlined, size: 32, color: darkGreen),
      const SizedBox(width: 10),
      IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () => _keluar(context),
        icon: const Icon(Icons.logout, size: 26, color: darkGreen),
      ),
    ],
  );

  // ====== KARTU PROFIL (GRADASI HIJAU) ======
  Widget _profileCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1ED3A3), Color(0xFF0F6E56)],
      ),
      borderRadius: BorderRadius.circular(22),
      boxShadow: _shadow(0.18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFF8FE0C4),
                shape: BoxShape.circle,
              ),
              child: const Text(
                'SA',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Flexible(
                        child: Text(
                          'Ibu Siti Aminah',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: orangeDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Nasabah',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'RT 04/ Blok B3',
                    style: TextStyle(color: Colors.white, fontSize: 11.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Nasabah Aktif RT 04 / RW 08',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: orangeDark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars, size: 13, color: Colors.black87),
                SizedBox(width: 5),
                Text(
                  'Warga Peduli Lingkungan',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Divider(color: Colors.white.withValues(alpha: 0.35), height: 1),
        const SizedBox(height: 14),
        const Row(
          children: [
            Expanded(
              child: _StatBox(label: 'Total Sektor', value: '48x'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _StatBox(label: 'Lama Gabung', value: '10 Bln'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _StatBox(label: 'Status Verif', value: 'Sah RW'),
            ),
          ],
        ),
      ],
    ),
  );

  // ====== KARTU PUTIH: HEADER SECTION ======
  Widget _sectionHeader({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 17, color: darkGreen),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10.5, color: Colors.black87),
            ),
          ],
        ),
      ),
      if (trailing != null) trailing,
    ],
  );

  Widget _whiteCard({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardWhite,
      borderRadius: BorderRadius.circular(20),
      boxShadow: _shadow(0.10),
    ),
    child: child,
  );

  // ====== AKSES LOGIN & KEAMANAN ======
  Widget _aksesCard() => _whiteCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.shield_outlined,
          iconBg: orange,
          title: 'Akses Login & Keamanan',
          subtitle: 'Kredensial akun nasabah warga',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: mint.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 11, color: darkGreen),
                SizedBox(width: 4),
                Text(
                  'Aman',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Tile nomor WhatsApp
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: greyTile,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _shadow(0.12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: mint,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone, color: Colors.black87),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Flexible(
                              child: Text(
                                'Nomor WhatsApp Utama',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: mint,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'OTP',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          '0812-7654-3210',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: ganti nomor WhatsApp
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 1,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Ganti',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 14,
                      color: darkGreen,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Terverifikasi untuk Login Instan & Pemberitahuan Timbangan',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Tile sesi login
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: greyTile,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _shadow(0.12),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: mint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.devices, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sesi Login Aktif',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: greyText,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Hari ini, 09:15 WIB',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: mint,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _shadow(0.12),
                ),
                child: const Text(
                  'Perangkat Ini',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
      ],
    ),
  );

  // ====== DATA DOMISILI & WARGA ======
  Widget _domisiliCard() => _whiteCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.location_on,
          iconBg: mint,
          title: 'Data Domisili & Warga',
          subtitle: 'Sesuai catatan RT/RW Plamo Garden',
        ),
        const SizedBox(height: 14),
        _infoTile(
          icon: Icons.home,
          label: 'Blok & Nomor Rumah',
          value: 'Blok B3 No. 12',
        ),
        const SizedBox(height: 10),
        _infoTile(
          icon: Icons.groups,
          label: 'Rukun Tetangga & Rukun Warga',
          value: 'RT 04 / RW 08',
          sub: 'Perumahan Plamo Garden',
        ),
        const SizedBox(height: 10),
        _infoTile(
          icon: Icons.map_outlined,
          label: 'Kelurahan & Kecamatan',
          value: 'Kel. Baloi Permai',
          sub: 'Kecamatan Batam Kota, Batam',
        ),
      ],
    ),
  );

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    String? sub,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: greyTile,
      borderRadius: BorderRadius.circular(14),
      boxShadow: _shadow(0.12),
    ),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: greyText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (sub != null) ...[
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: greyText,
                  ),
                ),
              ],
            ],
          ),
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
              'Keluar Akun Nasabah',
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
  Widget _bottomNav(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: background,
      border: Border(
        top: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
      ),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(
              icon: Icons.home_outlined,
              label: 'Beranda',
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BerandaWargaScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
            _navItem(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Dompet',
              onTap: () {
                // TODO: navigasi ke halaman Dompet
              },
            ),
            _navItem(icon: Icons.person_outline, label: 'Warga', onTap: () {}),
          ],
        ),
      ),
    ),
  );

  Widget _navItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 38, color: darkGreen),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
        ],
      ),
    ),
  );
}

// ====== KOTAK STATISTIK (ORANYE) ======
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: ProfilWargaScreen.orange,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B6508),
            ),
          ),
        ],
      ),
    );
  }
}
