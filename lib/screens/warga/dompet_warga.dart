import 'package:flutter/material.dart';



void main() => runApp(const MyApp());

// ===== Warna =====
const kBg = Color(0xFFEEEEE6);
const kCard = Color(0xFFFDFAF8);
const kGreen = Color(0xFF0F6B52);
const kGreenD = Color(0xFF0B5A45);
const kMint = Color(0xFF5ECBA6);
const kMintL = Color(0xFFB3E2D0);
const kChip = Color(0xFF7BBBA3);
const kGrey = Color(0xFFE0DFDA);
const kOrange = Color(0xFFF09E2A);

final kShadow = [
  BoxShadow(color: Colors.black.withOpacity(.22), blurRadius: 6, offset: const Offset(0, 3)),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dompet',
      theme: ThemeData(scaffoldBackgroundColor: kBg, useMaterial3: true),
      home: const DompetPage(),
    );
  }
}

// ===== Data =====
class Setoran {
  final IconData icon;
  final String nama, berat, harga;
  const Setoran(this.icon, this.nama, this.berat, this.harga);
}

class Pencairan {
  final String jumlah, tanggal;
  const Pencairan(this.jumlah, this.tanggal);
}

const setoranList = [
  Setoran(Icons.local_drink_outlined, 'Setor Botol Plastik Bersih (P3)', '3 kg', 'Rp 11.400'),
  Setoran(Icons.inventory_2_outlined, 'Setor Kardus & Kertas (K1)', '4 kg', 'Rp 7.200'),
  Setoran(Icons.delete_outline, 'Setor Ember (P7)', '2 kg', 'Rp 5.000'),
  Setoran(Icons.water_drop_outlined, 'Setor Tutup Galon (P8)', '3 kg', 'Rp 10.500'),
];

const pencairanList = [
  Pencairan('3.000.000', '12 Januari 2026'),
  Pencairan('250.000', '14 Februari 2026'),
  Pencairan('35.000', '28 Juli 2026'),
  Pencairan('125.000', '20 Agustus 2025'),
];

// ===== Halaman =====
class DompetPage extends StatelessWidget {
  const DompetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const _BottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ikon atas
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.account_circle_outlined, size: 32, color: kGreen),
                  SizedBox(width: 12),
                  Icon(Icons.logout, size: 28, color: kGreen),
                ],
              ),
              const SizedBox(height: 10),
              const _ProfileRow(),
              const SizedBox(height: 8),
              const _HeroCard(),

              // Riwayat setor sampah
              const _SectionTitle('Riwayat Setor Sampah', top: 26, bottom: 15),
              const _Dropdown('Pilih Bulan - Januari 2026'),
              const SizedBox(height: 12),
              Container(
                height: 26,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 11),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: kMint, borderRadius: BorderRadius.circular(13), boxShadow: kShadow),
                child: const Text('Total : 34.100',
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: kGreenD)),
              ),
              const SizedBox(height: 13),
              for (final s in setoranList)
                _ItemCard(
                  icon: s.icon,
                  title: s.nama,
                  subtitle: s.berat,
                  badge: s.harga,
                  badgeColor: kMint,
                ),

              // Riwayat pencairan dana
              const _SectionTitle('Riwayat Pencairan Dana', top: 21, bottom: 14),
              const _Dropdown('Pilih Bulan -  Semua'),
              const SizedBox(height: 15),
              for (final p in pencairanList)
                _ItemCard(
                  icon: Icons.check_circle_outline,
                  title: p.jumlah,
                  subtitle: p.tanggal,
                  badge: 'Berhasil',
                  badgeColor: kChip,
                  bigTitle: true,
                ),

              const SizedBox(height: 27),
              const _JadwalCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== Profil =====
class _ProfileRow extends StatelessWidget {
  const _ProfileRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: kMint, shape: BoxShape.circle, boxShadow: kShadow),
            child: const Text('SA', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kGreenD)),
          ),
          const SizedBox(width: 7),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ibu Siti Aminah',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: kGreen)),
                Text('Plamo Garden Blok B3 No.12',
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.black)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                width: 90,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xFFC5F06B), borderRadius: BorderRadius.circular(10), boxShadow: kShadow),
                child: const Text('Warga Aktif',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kGreenD)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Kartu hijau utama =====
class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 19, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1FBF92), Color(0xFF0E6E55)],
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.28), blurRadius: 10, offset: const Offset(0, 6))],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('TOTAL UANG TERKUMPUL',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text('Rp 150.000',
                  style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Container(
                width: 192,
                height: 26,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.17), borderRadius: BorderRadius.circular(13), boxShadow: kShadow),
                child: const Text('35 kg Sampah Terdaur',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 9),
              Container(
                width: 194,
                height: 41,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(color: kOrange, borderRadius: BorderRadius.circular(12), boxShadow: kShadow),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration:
                          BoxDecoration(color: const Color(0xFFF8C474), borderRadius: BorderRadius.circular(9)),
                      child: const Icon(Icons.recycling, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 9),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BULAN INI',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFFA8620E))),
                        Text('16.5 kg',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: -6,
            right: 8,
            child: Container(
              width: 110,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: const Color(0xFF58C4A0), borderRadius: BorderRadius.circular(12)),
              child: const Text('RT 04 / RW 08',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kGreenD)),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Judul bagian & dropdown =====
class _SectionTitle extends StatelessWidget {
  final String text;
  final double top, bottom;
  const _SectionTitle(this.text, {required this.top, required this.bottom});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: top, bottom: bottom, left: 7),
        child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      );
}

class _Dropdown extends StatelessWidget {
  final String label;
  const _Dropdown(this.label);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: () {}, // TODO: tampilkan pemilih bulan
      child: Container(
        height: 26,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(color: kGrey, borderRadius: BorderRadius.circular(13), boxShadow: kShadow),
        child: Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ===== Kartu item (dipakai setoran & pencairan) =====
class _ItemCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle, badge;
  final Color badgeColor;
  final bool bigTitle;

  const _ItemCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    this.bigTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.only(left: 9, right: 13),
      decoration: BoxDecoration(color: kCard, borderRadius: BorderRadius.circular(14), boxShadow: kShadow),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: kMintL, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 21, color: kGreenD),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: bigTitle ? 13 : 11.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: kGreen)),
              ],
            ),
          ),
          Container(
            width: 106,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(10), boxShadow: kShadow),
            child: Text(badge,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: bigTitle ? const Color(0xFF0A3B2E) : Colors.black)),
          ),
        ],
      ),
    );
  }
}

// ===== Kartu jadwal =====
class _JadwalCard extends StatelessWidget {
  const _JadwalCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.fromLTRB(12, 17, 12, 0),
      decoration: BoxDecoration(
        color: kGreen,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 10, offset: const Offset(0, 6))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 35,
            margin: const EdgeInsets.only(top: 3),
            decoration: BoxDecoration(color: const Color(0xFF2B8068), borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.history, color: Color(0xFFB9E3D3), size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jadwal Timbang Posko\nRT 04',
                    style: TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700, height: 1.15)),
                SizedBox(height: 6),
                Text('Sabtu, 15 Mar 2026 (09:00 - 09:30 WIB)',
                    style: TextStyle(color: Color(0xFFCFE5DC), fontSize: 11)),
              ],
            ),
          ),
          Container(
            width: 53,
            height: 18,
            margin: const EdgeInsets.only(top: 3, right: 13),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: const Color(0xFF58C9A4), borderRadius: BorderRadius.circular(9)),
            child: const Text('Segera',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF0A3B2E))),
          ),
        ],
      ),
    );
  }
}

// ===== Navigasi bawah =====
class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String label) => SizedBox(
          width: 90,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 38, color: kGreen),
              const SizedBox(height: 2),
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kGreen)),
            ],
          ),
        );

    return Container(
      height: 83,
      decoration: BoxDecoration(
        color: kBg,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 6, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          item(Icons.home_outlined, 'Beranda'),
          item(Icons.account_balance_wallet_outlined, 'Dompet'),
          item(Icons.person_outline, 'Warga'),
        ],
      ),
    );
  }
}
