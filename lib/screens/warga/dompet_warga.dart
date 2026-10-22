import 'package:flutter/material.dart';

import 'beranda_warga_screen.dart';
import 'profil_warga.dart';

class DompetPage extends StatelessWidget {
  const DompetPage({super.key});

  static const Color darkGreen = Color(0xFF0F6E56);
  static const Color mint = Color(0xFF59C8A8);
  static const Color orange = Color(0xFFFFCA72);
  static const Color background = Color(0xFFEFEDE3);
  static const Color cardWhite = Color(0xFFFFFCF8);

  // Data simulasi front-end (belum terhubung ke backend).
  static const List<_Transaksi> _riwayat = [
    _Transaksi('Setoran Plastik', '12 Okt 2026', 18500, true),
    _Transaksi('Setoran Kertas & Kardus', '05 Okt 2026', 24000, true),
    _Transaksi('Pencairan Dana', '28 Sep 2026', 50000, false),
    _Transaksi('Setoran Minyak Jelantah', '20 Sep 2026', 32000, true),
    _Transaksi('Setoran Logam & Kaleng', '11 Sep 2026', 12500, true),
  ];

  List<BoxShadow> _shadow([double alpha = 0.10]) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: alpha),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  String _rupiah(int nilai) {
    final s = nilai.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return 'Rp $buf';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),
              _saldoCard(),
              const SizedBox(height: 20),
              _riwayatCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _header() => Row(
    children: [
      Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(color: mint, shape: BoxShape.circle),
        child: const Icon(
          Icons.account_balance_wallet_rounded,
          color: darkGreen,
          size: 20,
        ),
      ),
      const SizedBox(width: 10),
      const Text(
        'Dompet',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ],
  );

  Widget _saldoCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1ED3A3), Color(0xFF0F6E56)],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: _shadow(0.18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Saldo Tabungan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Rp 148.500',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Ibu Siti Aminah (Blok B3 No. 12)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _riwayatCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardWhite,
      borderRadius: BorderRadius.circular(20),
      boxShadow: _shadow(),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.receipt_long_outlined, color: darkGreen, size: 20),
            SizedBox(width: 8),
            Text(
              'Riwayat Transaksi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (int i = 0; i < _riwayat.length; i++) ...[
          _itemTransaksi(_riwayat[i]),
          if (i != _riwayat.length - 1) const SizedBox(height: 10),
        ],
      ],
    ),
  );

  Widget _itemTransaksi(_Transaksi t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFE3E1DA),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: t.masuk ? mint : orange,
            shape: BoxShape.circle,
          ),
          child: Icon(
            t.masuk ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.black87,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.judul,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                t.tanggal,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF7A7870),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${t.masuk ? '+' : '-'}${_rupiah(t.nominal)}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: t.masuk ? darkGreen : const Color(0xFF8B6508),
          ),
        ),
      ],
    ),
  );

  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      backgroundColor: background,
      selectedItemColor: darkGreen,
      unselectedItemColor: Colors.black38,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BerandaWargaScreen(),
            ),
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

class _Transaksi {
  final String judul;
  final String tanggal;
  final int nominal;
  final bool masuk;
  const _Transaksi(this.judul, this.tanggal, this.nominal, this.masuk);
}