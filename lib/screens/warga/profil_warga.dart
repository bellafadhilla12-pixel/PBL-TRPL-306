import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_warga_screen.dart';
import 'dompet_warga.dart' show DompetPage;

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

  static final ValueNotifier<String> _nomorWa = ValueNotifier<String>(
    '0812-7654-3210',
  );

  Future<void> _gantiNomor(BuildContext context) async {
    final hasil = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => _GantiNomorDialog(nomorAwal: _nomorWa.value),
    );

    if (hasil == null) return;

    // TODO: Kirim kode OTP ke nomor baru & simpan ke Firebase bila sudah dipakai.
    _nomorWa.value = hasil;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor WhatsApp berhasil diganti')),
      );
    }
  }

  void _keluar(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreenWarga()),
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
                    TextSpan(text: 'Sesi akun nasabah '),
                    TextSpan(
                      text: 'Ibu Siti Aminah',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' akan diakhiri. Anda perlu masuk kembali untuk mengakses beranda dan dompet.',
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              _profileCard(),
              const SizedBox(height: 20),
              _aksesCard(context),
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
                            color: Color.fromARGB(255, 0, 0, 0),
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
      if (trailing != null) ...[const SizedBox(width: 8), trailing],
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
  Widget _aksesCard(BuildContext context) => _whiteCard(
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
                        ValueListenableBuilder<String>(
                          valueListenable: _nomorWa,
                          builder: (_, nomor, __) => Text(
                            nomor,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _gantiNomor(context),
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
      onTap: () => _konfirmasiLogout(context),
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

  // ====== BOTTOM NAV ======
  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
      selectedItemColor: const Color(0xFF0F6E56),
      unselectedItemColor: Colors.black45,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 9.5,
      unselectedFontSize: 9.5,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BerandaWargaScreen()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DompetPage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Dompet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Warga',
        ),
      ],
    );
  }
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

// ====== DIALOG GANTI NOMOR WHATSAPP ======
class _GantiNomorDialog extends StatefulWidget {
  final String nomorAwal;
  const _GantiNomorDialog({required this.nomorAwal});

  @override
  State<_GantiNomorDialog> createState() => _GantiNomorDialogState();
}

class _GantiNomorDialogState extends State<_GantiNomorDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 081276543210 -> 0812-7654-3210
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
                  color: ProfilWargaScreen.mint.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_iphone,
                  color: ProfilWargaScreen.darkGreen,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Ganti Nomor WhatsApp',
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
                      text: '\nMasukkan nomor baru untuk login instan & pemberitahuan timbangan.',
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
                    color: ProfilWargaScreen.greyText,
                  ),
                  errorText: _error,
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: ProfilWargaScreen.darkGreen,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: ProfilWargaScreen.greyTile,
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
                      color: ProfilWargaScreen.darkGreen,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: ProfilWargaScreen.merah,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: ProfilWargaScreen.merah,
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
                        backgroundColor: ProfilWargaScreen.darkGreen,
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
