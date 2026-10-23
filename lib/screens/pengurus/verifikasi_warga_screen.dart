import 'package:flutter/material.dart';

import 'kelola_gabungan_screen.dart';
import 'kelola_antrian_pengumuman_screen.dart';
import 'profil_pengurus.dart';
import 'rekap_gabungan_screen.dart';

// =====================================================
// =====================================================

const _hijau = Color(0xFF0F6E56);
const _hijauTerang = Color(0xFF1B8A6B);
const _mint = Color(0xFF59C8A8);
const _lightMint = Color(0xFFB8E0D2);
const _lime = Color(0xFFB7E868);
const _bg = Color(0xFFF5F3EA);
const _cardGrey = Color(0xFFE5E1D7);
const _avatarBg = Color(0xFFF3E2B4);
const _merah = Color(0xFFE8412F);
const _teksGelap = Color(0xFF1F1F1F);
const _teksAbu = Color(0xFF6F6F6F);
const _teksHijauMuda = Color(0xFFBFE3D7);
const _oranyePill = Color(0xFFF7DCA0);
const _hijauHeader = Color(0xFF0D735B);

// =====================================================
// MODEL DATA
// =====================================================

/// Data warga yang mendaftar mandiri dan menunggu verifikasi pengurus.
class WargaMenunggu {
  final String nama;
  final String rt;
  final String jam;
  final String telepon;
  final String alamat;
  final String statusTempatTinggal;
  final String blokRumah;
  final String nomorRumah;
  final String rw;
  final String keteranganTempatTinggal;
  final String detailTempatTinggal;

  const WargaMenunggu({
    required this.nama,
    required this.rt,
    required this.jam,
    required this.telepon,
    required this.alamat,
    this.statusTempatTinggal = 'Rumah Pribadi',
    this.blokRumah = 'D1',
    this.nomorRumah = '04',
    this.rw = '04',
    this.keteranganTempatTinggal = '',
    this.detailTempatTinggal = '',
  });

  /// Huruf pertama nama untuk avatar bulat.
  String get inisial => nama.isEmpty ? '?' : nama[0].toUpperCase();
}

// =====================================================
// HALAMAN
// =====================================================

class VerifikasiWargaScreen extends StatefulWidget {
  const VerifikasiWargaScreen({super.key});

  @override
  State<VerifikasiWargaScreen> createState() => _VerifikasiWargaScreenState();
}

class _VerifikasiWargaScreenState extends State<VerifikasiWargaScreen> {
  // =====================================================
  // DATA SIMULASI (SEMENTARA, SEBELUM TERHUBUNG BACKEND)
  // =====================================================

  final List<WargaMenunggu> _menunggu = [
    const WargaMenunggu(
      nama: 'Hendra Wijaya',
      rt: 'RT 02',
      jam: '10:20',
      telepon: '0821-0678-4545',
      alamat: 'Blok D1 No. 04, Plamo Garden',
      statusTempatTinggal: 'Rumah Pribadi',
      blokRumah: 'D1',
      nomorRumah: '04',
      rw: '04',
    ),
    const WargaMenunggu(
      nama: 'Susi Susanti',
      rt: 'RT 04',
      jam: '10:20',
      telepon: '0821-0678-4545',
      alamat: 'Blok D1 No. 04, Plamo Garden',
      statusTempatTinggal: 'Rumah Kontrakan',
      blokRumah: 'D1',
      nomorRumah: '04',
      rw: '04',
    ),
    const WargaMenunggu(
      nama: 'Bagus Stan',
      rt: 'RT 04',
      jam: '10:20',
      telepon: '0821-0678-4545',
      alamat: 'Blok D1 No. 04, Plamo Garden',
      statusTempatTinggal: 'Lainnya',
      blokRumah: 'D1',
      nomorRumah: '04',
      rw: '04',
      keteranganTempatTinggal: 'Kost',
      detailTempatTinggal: 'Kamar Kost No. 7',
    ),
  ];

  static const List<String> _labelNav = [
    'Verifikasi Warga',
    'Kelola Katalog',
    'Antrian Warga',
    'Rekap',
    'Pengurus',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 18),
              _buildRingkasan(),
              _buildDaftarWarga(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // =====================================================
  // AKSI
  // =====================================================

  Future<void> _konfirmasiVerifikasi(WargaMenunggu w) async {
    final yakin = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(Icons.verified_user_outlined, color: _hijau, size: 34),
        title: const Text(
          'Konfirmasi Verifikasi',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: _teksGelap),
        ),
        content: Text(
          'Apakah Anda yakin ingin menerima verifikasi warga ${w.nama}?',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: _teksAbu),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _hijau,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Ya, Verifikasi'),
          ),
        ],
      ),
    );

    if (yakin == true && mounted) {
      _verifikasi(w);
    }
  }

  Future<void> _konfirmasiTolak(WargaMenunggu w) async {
    final yakin = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(Icons.warning_amber_rounded, color: _merah, size: 36),
        title: const Text(
          'Konfirmasi Penolakan',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: _teksGelap),
        ),
        content: Text(
          'Apakah Anda yakin ingin menolak verifikasi warga ${w.nama}?',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: _teksAbu),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _merah,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Ya, Tolak'),
          ),
        ],
      ),
    );

    if (yakin == true && mounted) {
      _tolak(w);
    }
  }

  void _verifikasi(WargaMenunggu w) {
    setState(() => _menunggu.remove(w));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${w.nama} berhasil diverifikasi')));
  }

  void _tolak(WargaMenunggu w) {
    setState(() => _menunggu.remove(w));

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${w.nama} ditolak')));
  }

  void _lihatRincian(WargaMenunggu w) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: _bg,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440, maxHeight: 650),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: _mint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_outline, color: _hijau),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Rincian Data Registrasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _teksGelap,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Periksa data berikut sebelum memutuskan verifikasi.',
                  style: TextStyle(fontSize: 12, color: _teksAbu),
                ),
                const SizedBox(height: 18),
                _detailBaris('Nama lengkap', w.nama),
                _detailBaris('Nomor WhatsApp', w.telepon),
                _detailBaris('Status tempat tinggal', w.statusTempatTinggal),
                if (w.keteranganTempatTinggal.isNotEmpty)
                  _detailBaris(
                    'Keterangan tempat tinggal',
                    w.keteranganTempatTinggal,
                  ),
                _detailBaris('Blok rumah', w.blokRumah),
                _detailBaris('Nomor rumah', w.nomorRumah),
                _detailBaris('Rukun Tetangga (RT)', w.rt),
                _detailBaris('Rukun Warga (RW)', w.rw),
                if (w.detailTempatTinggal.isNotEmpty)
                  _detailBaris(
                    'Nomor kamar/keterangan lainnya',
                    w.detailTempatTinggal,
                  ),
                _detailBaris('Alamat lengkap', w.alamat),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(dialogContext),
                        icon: const Icon(Icons.close),
                        label: const Text('Tutup'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hijau,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          Future<void>.delayed(Duration.zero, () {
                            if (mounted) _konfirmasiVerifikasi(w);
                          });
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Verifikasi'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailBaris(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: _teksAbu,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                fontSize: 13,
                color: _teksGelap,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _hubungiWa(WargaMenunggu w) {
    // Simulasi tahap front-end: belum dihubungkan ke WhatsApp / backend.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Simulasi: membuka chat WhatsApp ${w.nama}')),
    );
  }

  // =====================================================
  // BARIS ATAS (PROFIL & KELUAR)
  // =====================================================

  // =====================================================
  // HEADER (sama dengan Rekap)
  // =====================================================

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProfilPengurusScreen()),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: const Icon(
              Icons.account_circle_outlined,
              color: _hijauHeader,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: _mint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: _hijau,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Verifikasi Warga',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =====================================================
  // KARTU RINGKASAN (HIJAU)
  // =====================================================

  Widget _buildRingkasan() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_hijau, _hijauTerang],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _buildPill(
                  'Admin Pengurus',
                  bg: _lime,
                  fg: _teksGelap,
                  fontSize: 11.5,
                  hPad: 12,
                  vPad: 5,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Bank Sampah RW 04',

                  style: TextStyle(
                    color: _teksHijauMuda,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${_menunggu.length} Warga Menunggu Verifikasi',

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Container(
            width: 56,
            height: 56,

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),

            child: const Icon(
              Icons.workspace_premium_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // KARTU DAFTAR WARGA (PUTIH)
  // =====================================================

  Widget _buildDaftarWarga() {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(top: 14),

      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,

                decoration: const BoxDecoration(
                  color: _mint,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Text(
                  'Warga Baru Menunggu Verifikasi',

                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: _teksGelap,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              _buildPill(
                '${_menunggu.length} Antrian',
                bg: _oranyePill,
                fg: _teksGelap,
                fontSize: 11,
                hPad: 10,
                vPad: 5,
              ),
            ],
          ),

          const SizedBox(height: 4),

          const Padding(
            padding: EdgeInsets.only(left: 16),

            child: Text(
              'Pendaftaran mandiri hari ini',

              style: TextStyle(fontSize: 11.5, color: _teksAbu),
            ),
          ),

          const SizedBox(height: 14),

          if (_menunggu.isEmpty)
            _buildKosong()
          else
            ..._menunggu.map(_buildKartuWarga),
        ],
      ),
    );
  }

  // =====================================================
  // KARTU SATU WARGA
  // =====================================================

  Widget _buildKartuWarga(WargaMenunggu w) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: _cardGrey,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Avatar inisial
              Container(
                width: 46,
                height: 46,

                alignment: Alignment.center,

                decoration: const BoxDecoration(
                  color: _avatarBg,
                  shape: BoxShape.circle,
                ),

                child: Text(
                  w.inisial,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _teksGelap,
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
                        Flexible(
                          child: Text(
                            w.nama,

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _teksGelap,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        _buildPill(w.rt, bg: _lightMint, fg: _hijau),

                        const SizedBox(width: 6),

                        _buildPill(w.jam, bg: Colors.white, fg: _teksGelap),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.call, size: 14, color: _teksGelap),

                        const SizedBox(width: 6),

                        Text(
                          w.telepon,

                          style: const TextStyle(
                            fontSize: 12.5,
                            color: _teksGelap,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      w.alamat,
                      style: const TextStyle(fontSize: 11.5, color: _teksAbu),
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () => _lihatRincian(w),
                      child: const Text(
                        'Lihat Rincian Data',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Divider(
            height: 1,
            thickness: 1,
            color: Colors.black.withValues(alpha: 0.08),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                flex: 6,

                child: _buildAksi(
                  label: 'Hubungi WA',
                  icon: Icons.chat_bubble_outline,
                  bg: Colors.white,
                  fg: _teksGelap,
                  iconColor: _hijau,
                  garisTepi: true,
                  onTap: () => _hubungiWa(w),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                flex: 5,

                child: Column(
                  children: [
                    _buildAksi(
                      label: 'Verifikasi Data',
                      icon: Icons.check_circle,
                      bg: _hijau,
                      fg: Colors.white,
                      iconColor: _mint,
                      onTap: () => _konfirmasiVerifikasi(w),
                    ),

                    const SizedBox(height: 6),

                    _buildAksi(
                      label: 'Tolak Verifikasi',
                      icon: Icons.cancel,
                      bg: _merah,
                      fg: Colors.white,
                      onTap: () => _konfirmasiTolak(w),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // KOMPONEN KECIL
  // =====================================================

  Widget _buildPill(
    String teks, {
    required Color bg,
    required Color fg,
    double fontSize = 10,
    double hPad = 8,
    double vPad = 3,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),

      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        teks,

        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildAksi({
    required String label,
    required IconData icon,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
    Color? iconColor,
    bool garisTepi = false,
  }) {
    return SizedBox(
      height: 36,

      child: ElevatedButton(
        onPressed: onTap,

        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,

          padding: const EdgeInsets.symmetric(horizontal: 8),

          minimumSize: const Size(0, 36),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),

            side: garisTepi
                ? BorderSide(color: Colors.black.withValues(alpha: 0.12))
                : BorderSide.none,
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 15, color: iconColor ?? fg),

            const SizedBox(width: 5),

            // FittedBox: label otomatis mengecil bila ruang sempit,
            // sehingga tidak pernah terpotong (ellipsis) di layar kecil.
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,

                child: Text(
                  label,

                  maxLines: 1,

                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKosong() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),

      child: Column(
        children: [
          Icon(Icons.check_circle_outline, size: 44, color: _hijau),

          SizedBox(height: 8),

          Text(
            'Semua warga sudah diverifikasi',

            style: TextStyle(fontSize: 12.5, color: _teksAbu),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // BOTTOM NAVIGATION
  // =====================================================

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,

      currentIndex: 0,

      selectedItemColor: _hijau,

      unselectedItemColor: Colors.black45,

      selectedFontSize: 9.5,
      unselectedFontSize: 9.5,

      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),

      onTap: (index) {
        if (index == 0) return;

        Widget? tujuan;
        switch (index) {
          case 1:
            tujuan = const KelolaGabunganScreen();
            break;
          case 2:
            tujuan = const KelolaAntrianPengumumanScreen();
            break;
          case 3:
            tujuan = const RekapGabunganScreen();
            break;
          case 4:
            tujuan = const ProfilPengurusScreen();
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
          label: 'Antrian Warga',
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
