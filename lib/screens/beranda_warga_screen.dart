import 'package:flutter/material.dart';
import 'login_warga_screen.dart';

class BerandaWargaScreen extends StatefulWidget {
  const BerandaWargaScreen({super.key});

  @override
  State<BerandaWargaScreen> createState() => _BerandaWargaScreenState();
}

class _BerandaWargaScreenState extends State<BerandaWargaScreen> {
  // =====================================================
  // DATA SIMULASI (SEMENTARA, SEBELUM TERHUBUNG FIREBASE)
  // Ganti nilai ini jadi 'false' untuk melihat tampilan
  // beranda versi normal/kosong (Gambar 1)
  // =====================================================
  bool punyaJadwalPenimbangan = true;
  bool punyaPengumumanPencairan = true;
  bool punyaTiketAntrianAktif = true;

  int _selectedNavIndex = 0;

  static const Color darkGreen = Color(0xFF0F6E56);
  static const Color mint = Color(0xFF59C8A8);
  static const Color orange = Color(0xFFFFCA72);
  static const Color background = Color(0xFFF5F3EA);
  static const Color iconMint = Color(0xFF59C8A8);
  static const Color iconLightGreen = Color(0xFFB7E868);
  static const Color iconOrange = Color(0xFFEF9F27);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildBanner(),
              if (punyaPengumumanPencairan) ...[
                const SizedBox(height: 14),
                _buildPengumumanPencairan(),
              ],
              if (punyaTiketAntrianAktif) ...[
                const SizedBox(height: 14),
                _buildTiketAntrianAktif(),
              ],
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 20),
              _buildLangkahPraktis(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // =====================================================
  // HEADER
  // =====================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: iconMint,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.home_rounded, color: darkGreen, size: 20),
        ),
        const SizedBox(width: 10),
        const Text(
          'Beranda',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        const Icon(Icons.account_circle_outlined, size: 32, color: darkGreen),
        const SizedBox(width: 10),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreenWarga()),
            );
          },
          icon: const Icon(Icons.logout, size: 24, color: darkGreen),
        ),
      ],
    );
  }

  // =====================================================
  // BANNER UTAMA
  // =====================================================

  Widget _buildBanner() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [darkGreen, darkGreen.withValues(alpha: 0.75)],
      ),
      borderRadius: BorderRadius.circular(18),
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ubah Sampah Jadi Berkah,\nTabungan untuk Masa Depan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tabungan anorganik terpadu lingkungan Plamo Garden. '
            'Penimbangan digital presisi, setoran transparan, dan tabungan '
            'aman untuk warga',
            style: TextStyle(color: Color(0xFFBFE3D7), fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
          if (punyaJadwalPenimbangan) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Penimbangan Sampah Bulanan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _iconTextRow(Icons.calendar_today_outlined,
                            'Selasa, 24 September 2026'),
                        const SizedBox(height: 3),
                        _iconTextRow(Icons.access_time, '09:00 - 12:00 WIB'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: navigasi ke halaman ambil antrean
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iconOrange,
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Ambil Antrean',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _iconTextRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 13),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
      ],
    );
  }

  // =====================================================
  // PENGUMUMAN PENCAIRAN DANA
  // =====================================================

  Widget _buildPengumumanPencairan() {
  // Nilai simulasi - nanti diambil dari Firestore
  const int kuotaMaksimal = 5;
  const int sudahTerdaftar = 3;
  final double progress = sudahTerdaftar / kuotaMaksimal;
  final int sisaKuota = kuotaMaksimal - sudahTerdaftar;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [darkGreen, darkGreen.withValues(alpha: 0.75)],
      ),
      borderRadius: BorderRadius.circular(18),
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.campaign_outlined,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Announcement',
                  style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: iconLightGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Dibuka',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Pencairan Dana Cash Bank Sampah',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          _iconTextRow(Icons.calendar_today_outlined, 'Senin, 23 September 2026'),
          const SizedBox(height: 3),
          _iconTextRow(Icons.access_time, '09:00 - 12:00 WIB'),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Khusus 5 Orang Tercepat',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Sisa $sisaKuota Kuota Lagi!',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE5E2D8),
                    valueColor: const AlwaysStoppedAnimation(orange),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$sudahTerdaftar Warga telah terdaftar mengantre untuk kloter ini',
                  style: const TextStyle(fontSize: 10.5, color: Color.fromARGB(196, 0, 0, 0), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDaftarPencairanDanaModal(context);
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: iconOrange,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Daftar Pencairan Dana',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // TIKET ANTRIAN AKTIF
  // =====================================================

  Widget _buildTiketAntrianAktif() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFAC775),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tiket Antrian Aktif',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  'Nomor Urut Pagi',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
                SizedBox(height: 4),
                Text(
                  '#C-02',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _pillChip('17 September 2026'),
              const SizedBox(height: 6),
              _pillChip('10:00 - 10:30 WIB'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pillChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: iconOrange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void showDaftarPencairanDanaModal(BuildContext context) {
    final namaController = TextEditingController(text: 'Ibu Siti Aminah');
    final blokController =
        TextEditingController(text: 'Blok B3 No. 12, Plamo Garden');
    final whatsappController =
        TextEditingController(text: '0812-5678-0943');
    final nominalController = TextEditingController(text: '0');

    const double saldoMaksimal = 148500;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(dialogContext).size.height - 16,
              maxWidth: 420,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE9E8E3),
                borderRadius: BorderRadius.circular(18),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // =================================================
                  // HEADER SALDO
                  // =================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF087A63),
                          Color(0xFF12A989),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(dialogContext),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF087A63),
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Saldo Tabungan Siap Cair',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rp 148.500',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      height: 1.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: Color(0xFFFFCA72),
                                        size: 8,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Ibu Siti Aminah (Blok B3 No. 12)',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: mint,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.20),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.attach_money,
                                color: Color(0xFF087A63),
                                size: 29,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // =================================================
                  // FORM - DIBUAT COMPACT AGAR TOMBOL TERLIHAT
                  // TANPA HARUS SCROLL
                  // =================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFA51F),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_add_alt_1,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Nama Lengkap Warga',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _modalInputField(
                          controller: namaController,
                          icon: Icons.person_outline,
                          hint: 'Ibu Siti Aminah',
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Sesuai nama terdaftar pada buku tabungan bank sampah',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Blok, Rumah',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _modalInputField(
                          controller: blokController,
                          icon: Icons.home_outlined,
                          hint: 'Blok B3 No. 12, Plamo Garden',
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Lingkungan RT 04 / RW 08',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Nomor WhatsApp',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _modalInputField(
                          controller: whatsappController,
                          icon: Icons.chat_bubble_outline,
                          hint: '0812-5678-0943',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Pemberitahuan nomor antrean & status dikirim via WA',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Nominal Pencairan',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Max. Rp 148.500',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B6508),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.18),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  'Rp',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: nominalController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: '0',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: _nominalButton(
                                'Rp 50.000',
                                onTap: () {
                                  nominalController.text = '50000';
                                },
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _nominalButton(
                                'Rp 100.000',
                                onTap: () {
                                  nominalController.text = '100000';
                                },
                                color: const Color(0xFF087A63),
                                textColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _nominalButton(
                                'Semua Saldo',
                                onTap: () {
                                  nominalController.text =
                                      saldoMaksimal.toInt().toString();
                                },
                                color: const Color(0xFFFFCA72),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              final nominal = nominalController.text.trim();
                              final nominalValue =
                                  int.tryParse(nominal) ?? 0;

                              // Nominal kosong atau masih 0.
                              if (nominal.isEmpty || nominalValue <= 0) {
                                showDialog(
                                  context: dialogContext,
                                  builder: (alertContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.orange,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Peringatan'),
                                        ],
                                      ),
                                      content: const Text(
                                        'Nominal wajib diisi.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertContext),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }

                              if (nominalValue > saldoMaksimal) {
                                showDialog(
                                  context: dialogContext,
                                  builder: (alertContext) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.orange,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Peringatan'),
                                        ],
                                      ),
                                      content: const Text(
                                        'Nominal pencairan melebihi saldo yang tersedia.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(alertContext),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return;
                              }

                              Navigator.pop(dialogContext);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Pendaftaran pencairan dana berhasil dikirim.',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF087A63),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Kirim Pendaftaran',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _modalInputField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            size: 18,
            color: Colors.black87,
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black26,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 8,
          ),
        ),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _nominalButton(
    String text, {
    required VoidCallback onTap,
    required Color color,
    Color textColor = Colors.black,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // QUICK ACTIONS
  // =====================================================

  Widget _buildQuickActions() {
  return Row(
    children: [
      Expanded(
        child: _quickActionItem(
          icon: Icons.event_busy_outlined,
          label: 'Ambil Antrean',
          onTap: () {
            // TODO: navigasi ke halaman ambil antrean
          },
          imagePath: 'assets/images/queue.png',
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _quickActionItem(
          icon: Icons.school_outlined,
          label: 'Edukasi',
          onTap: () {
            // TODO: navigasi ke halaman edukasi
          },
          imagePath: 'assets/images/mortarboard.png',
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _quickActionItem(
          icon: Icons.menu_book_outlined,
          label: 'Katalog',
          onTap: () {
            // TODO: navigasi ke halaman katalog
          },
          imagePath: 'assets/images/catalog.png',
        ),
      ),
    ],
  );
}

  Widget _quickActionItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  String? imagePath,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(255, 174, 218, 209).withValues(alpha: 0.4), width: 1.2),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: imagePath != null
                ? Image.asset(imagePath, fit: BoxFit.contain)
                : Icon(icon, color: darkGreen, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 0, 3, 2),
            ),
          ),
        ],
      ),
    ),
  );
}

  // =====================================================
  // 4 LANGKAH PRAKTIS DI RUMAH
  // =====================================================

  Widget _buildLangkahPraktis() {
    final langkah = [
      (
        'Siapkan Wadah Berventilasi',
        'Gunakan ember cat bekas berlubang udara di sisi samping '
            'atau keranjang Takakura. Tempatkan di sudut teras yang '
            'teduh dan kering.',
      ),
      (
        'Buat Lapisan Dasar Penyangga',
        'Isi dasar wadah setebal 5-10 cm dengan sekam padi atau '
            'ranting/daun kering sebagai penyerap tirisan kelembapan awal.',
      ),
      (
        'Masukkan Sampah Dapur Cacahan',
        'Cincang sisa sayur agar luas permukaan bakteri melimpah. '
            'Taburkan lapisan cokelat di atasnya untuk meredam bau.',
      ),
      (
        'Aduk & Jaga Kelembapan 3 Hari Sekali',
        'Aduk perlahan. Semprot bioaktivator EM4 bila terasa '
            'sangat kering. Kompos siap panen gembur dalam kurun 3-5 minggu.',
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.format_list_numbered, color: darkGreen, size: 20),
              SizedBox(width: 8),
              Text(
                '4 Langkah Praktis di Rumah',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < langkah.length; i++) ...[
            _langkahItem(i + 1, langkah[i].$1, langkah[i].$2),
            if (i != langkah.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  Widget _langkahItem(int nomor, String judul, String deskripsi) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(color: darkGreen, shape: BoxShape.circle),
          child: Center(
            child: Text(
              '$nomor',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
              const SizedBox(height: 3),
              Text(
                deskripsi,
                style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.4, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =====================================================
  // BOTTOM NAVIGATION
  // =====================================================

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedNavIndex,
      selectedItemColor: darkGreen,
      unselectedItemColor: Colors.black38,
      onTap: (index) {
        setState(() => _selectedNavIndex = index);
        // TODO: navigasi ke halaman Dompet / Warga sesuai index
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined), label: 'Dompet'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Warga'),
      ],
    );
  }
}