import 'package:flutter/material.dart';

import 'beranda_warga_screen.dart';
import 'profil_warga.dart';

class DompetPage extends StatefulWidget {
  const DompetPage({super.key});

  @override
  State<DompetPage> createState() => _DompetPageState();
}

class _DompetPageState extends State<DompetPage> {
  static const Color darkGreen = Color(0xFF0F6E56);
  static const Color btnGreen = Color(0xFF0F765F);
  static const Color mint = Color(0xFF5BCBAA);
  static const Color lime = Color(0xFFB9EF55);
  static const Color orange = Color(0xFFF0A02A);
  static const Color background = Color(0xFFF0EFE7);
  static const Color cardWhite = Color(0xFFFFFCF8);
  static const Color grey = Color(0xFF6F6D66);

  // ====== DATA DUMMY (belum terhubung ke backend) ======
  static const List<String> _daftarBulan = [
    'Januari 2026',
    'Desember 2025',
    'November 2025',
    'Oktober 2025',
  ];

  static const Map<String, List<_Setoran>> _dataSetoran = {
    'Januari 2026': [
      _Setoran(
        'Setor Botol Plastik Bersih (P3)',
        '3 kg',
        11400,
        Icons.local_drink_outlined,
      ),
      _Setoran(
        'Setor Kardus & Kertas (K1)',
        '4 kg',
        7200,
        Icons.inventory_2_outlined,
      ),
      _Setoran(
        'Setor Ember (P7)',
        '2 kg',
        5000,
        Icons.shopping_basket_outlined,
      ),
      _Setoran(
        'Setor Tutup Galon (P8)',
        '3 kg',
        10500,
        Icons.water_drop_outlined,
      ),
    ],
    'Desember 2025': [
      _Setoran('Setor Kaleng Alka (C1)', '1.5 kg', 19500, Icons.recycling),
      _Setoran(
        'Setor Koran Bekas (K5)',
        '5 kg',
        8000,
        Icons.newspaper_outlined,
      ),
    ],
    'November 2025': [
      _Setoran(
        'Setor Botol Plastik Kotor (P4)',
        '2 kg',
        3200,
        Icons.local_drink_outlined,
      ),
    ],
    'Oktober 2025': [],
  };

  static const Map<String, List<_Pencairan>> _dataPencairan = {
    'Januari 2026': [
      _Pencairan('3.000.000', '12 Januari 2026'),
      _Pencairan('250.000', '14 Januari 2026'),
      _Pencairan('35.000', '20 Januari 2026'),
      _Pencairan('125.000', '28 Januari 2026'),
    ],
    'Desember 2025': [_Pencairan('500.000', '20 Desember 2025')],
    'November 2025': [],
    'Oktober 2025': [_Pencairan('125.000', '20 Oktober 2025')],
  };

  String _bulanSetor = 'Januari 2026';
  String _bulanCair = 'Januari 2026';

  List<_Setoran> get _setoran => _dataSetoran[_bulanSetor] ?? const [];
  List<_Pencairan> get _pencairan => _dataPencairan[_bulanCair] ?? const [];
  int get _totalSetoran => _setoran.fold(0, (s, e) => s + e.nilai);

  List<BoxShadow> _shadow([double alpha = 0.12]) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: alpha),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  String _angka(int nilai) {
    final s = nilai.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  void _pesan(String teks) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(teks)));
  }

  Future<void> _pilihBulan({
    required String aktif,
    required ValueChanged<String> onPilih,
  }) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Pilih Bulan Rekap',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            for (final b in _daftarBulan)
              ListTile(
                leading: const Icon(
                  Icons.calendar_month_outlined,
                  color: darkGreen,
                ),
                title: Text(
                  b,
                  style: TextStyle(
                    fontWeight: b == aktif ? FontWeight.bold : FontWeight.w500,
                    color: b == aktif ? darkGreen : Colors.black87,
                  ),
                ),
                trailing: b == aktif
                    ? const Icon(Icons.check_circle, color: darkGreen)
                    : null,
                onTap: () => Navigator.pop(ctx, b),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (picked != null && mounted) onPilih(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _identitas(),
              const SizedBox(height: 14),
              _saldoCard(),
              const SizedBox(height: 22),
              const Text(
                'Riwayat Setor Sampah',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              _pilihBulanCard(
                _bulanSetor,
                () => _pilihBulan(
                  aktif: _bulanSetor,
                  onPilih: (v) => setState(() => _bulanSetor = v),
                ),
              ),
              const SizedBox(height: 12),
              _totalBar(),
              const SizedBox(height: 10),
              if (_setoran.isEmpty)
                _kosong('Belum ada setoran di bulan ini.')
              else
                for (final s in _setoran) ...[
                  _itemSetoran(s),
                  const SizedBox(height: 10),
                ],
              const SizedBox(height: 14),
              _tombolPdf(),
              const SizedBox(height: 26),
              const Text(
                'Riwayat Pencairan Dana',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              _pilihBulanCard(
                _bulanCair,
                () => _pilihBulan(
                  aktif: _bulanCair,
                  onPilih: (v) => setState(() => _bulanCair = v),
                ),
              ),
              const SizedBox(height: 12),
              if (_pencairan.isEmpty)
                _kosong('Belum ada pencairan dana di bulan ini.')
              else
                for (final p in _pencairan) ...[
                  _itemPencairan(p),
                  const SizedBox(height: 10),
                ],
              const SizedBox(height: 18),
              _jadwalCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _identitas() => Row(
    children: [
      Container(
        width: 46,
        height: 46,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: mint, shape: BoxShape.circle),
        child: const Text(
          'SA',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
      const SizedBox(width: 10),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ibu Siti Aminah',
              style: TextStyle(
                color: darkGreen,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Plamo Garden Blok B3 No.12',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: lime,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _shadow(0.10),
        ),
        child: const Text(
          'Warga Aktif',
          style: TextStyle(
            color: darkGreen,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      const SizedBox(width: 6),
      IconButton(
        tooltip: 'Profil Warga',
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilWargaScreen()),
          );
        },
        icon: const Icon(
          Icons.account_circle_outlined,
          size: 32,
          color: darkGreen,
        ),
      ),
    ],
  );

  // ====== KARTU TOTAL UANG ======
  Widget _saldoCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F6E56), Color(0xFF1ED3A3)],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: _shadow(0.18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'TOTAL UANG TERKUMPUL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: mint,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _shadow(0.12),
              ),
              child: const Text(
                'RT 04 / RW 08',
                style: TextStyle(
                  color: Color(0xFF0D5A47),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Rp 150.000',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '35 kg Sampah Terdaur',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: orange,
            borderRadius: BorderRadius.circular(14),
            boxShadow: _shadow(0.16),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.recycling, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BULAN INI',
                    style: TextStyle(
                      color: Color(0xFF7A4A00),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '16.5 kg',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ====== PILIH BULAN ======
  Widget _pilihBulanCard(String bulan, VoidCallback onTap) => Material(
    color: cardWhite,
    borderRadius: BorderRadius.circular(14),
    elevation: 4,
    shadowColor: Colors.black38,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: mint.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: darkGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Bulan Rekap',
                    style: TextStyle(
                      fontSize: 11,
                      color: grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bulan,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Ubah',
              style: TextStyle(
                color: darkGreen,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down_rounded, color: darkGreen),
          ],
        ),
      ),
    ),
  );

  Widget _totalBar() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: mint.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      'Total : ${_angka(_totalSetoran)}',
      style: const TextStyle(
        color: Color(0xFF0D5A47),
        fontSize: 11.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  // ====== ITEM SETORAN ======
  Widget _itemSetoran(_Setoran s) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    decoration: BoxDecoration(
      color: cardWhite,
      borderRadius: BorderRadius.circular(14),
      boxShadow: _shadow(0.10),
    ),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: mint.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(s.ikon, color: Colors.black87, size: 21),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                s.berat,
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: mint,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _shadow(0.12),
          ),
          child: Text(
            'Rp ${_angka(s.nilai)}',
            style: const TextStyle(
              color: Color(0xFF0D5A47),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _tombolPdf() => SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      onPressed: () => _pesan(
        'Fitur Buat PDF rekap setoran $_bulanSetor akan segera tersedia.',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: btnGreen,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Buat PDF',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    ),
  );

  // ====== ITEM PENCAIRAN ======
  Widget _itemPencairan(_Pencairan p) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    decoration: BoxDecoration(
      color: cardWhite,
      borderRadius: BorderRadius.circular(14),
      boxShadow: _shadow(0.10),
    ),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: mint.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: darkGreen,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.nominal,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                p.tanggal,
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF6FBFA5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _shadow(0.12),
          ),
          child: const Text(
            'Berhasil',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );

  Widget _kosong(String teks) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 22),
    decoration: BoxDecoration(
      color: cardWhite,
      borderRadius: BorderRadius.circular(14),
      boxShadow: _shadow(0.08),
    ),
    child: Column(
      children: [
        const Icon(Icons.inbox_outlined, color: darkGreen, size: 28),
        const SizedBox(height: 6),
        Text(teks, style: const TextStyle(fontSize: 11.5, color: grey)),
      ],
    ),
  );

  // ====== JADWAL TIMBANG ======
  Widget _jadwalCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: btnGreen,
      borderRadius: BorderRadius.circular(14),
      boxShadow: _shadow(0.18),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.history, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'Jadwal Timbang Posko\nRT 04',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: mint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Segera',
                      style: TextStyle(
                        color: Color(0xFF0D5A47),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Sabtu, 15 Mar 2026 (09:00 - 09:30 WIB)',
                style: TextStyle(color: Colors.white70, fontSize: 10.5),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ====== BOTTOM NAV ======
  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: darkGreen,
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
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilWargaScreen()),
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

class _Setoran {
  final String judul;
  final String berat;
  final int nilai;
  final IconData ikon;
  const _Setoran(this.judul, this.berat, this.nilai, this.ikon);
}

class _Pencairan {
  final String nominal;
  final String tanggal;
  const _Pencairan(this.nominal, this.tanggal);
}
