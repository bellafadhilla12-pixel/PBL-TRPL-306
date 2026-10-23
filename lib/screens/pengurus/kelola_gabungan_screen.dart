import 'package:flutter/material.dart';

import 'katalog_pengurus.dart';
import 'verifikasi_warga_screen.dart';
import 'kelola_edukasi_screen.dart';
import 'kelola_antrian_pengumuman_screen.dart';
import 'rekap_gabungan_screen.dart';
import 'profil_pengurus.dart';

const Color _hijauKelola = Color(0xFF0D735B);
const Color _mintKelola = Color(0xFF59CBA9);
const Color _creamKelola = Color(0xFFF0F0E8);
const Color _hijauNav = Color(0xFF0F6E56); // sama dengan footer Verifikasi

class KelolaGabunganScreen extends StatefulWidget {
  const KelolaGabunganScreen({super.key});

  @override
  State<KelolaGabunganScreen> createState() => _KelolaGabunganScreenState();
}

class _KelolaGabunganScreenState extends State<KelolaGabunganScreen> {
  // 0 = Kelola Edukasi, 1 = Kelola Katalog
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _creamKelola,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              // Material dibutuhkan ChoiceChip, TextField, dan tombol di dalam tab.
              child: Material(
                color: _creamKelola,
                child: IndexedStack(
                  index: _tabIndex,
                  children: const [
                    KelolaEdukasiPengurusScreen(),
                    KatalogPengurusScreen(showBottomBar: false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ====== HEADER ======
  // ====== HEADER (sama dengan Rekap) ======
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _mintKelola,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '● PANEL BENDAHARA RT 04 PLAMO',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _hijauKelola,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Profil Pengurus',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilPengurusScreen(),
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: _hijauKelola,
                  size: 32,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Text(
            'Kelola Katalog dan Edukasi',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Kelola materi edukasi warga dan katalog '
            'kategori sampah bank sampah.',
            style: TextStyle(fontSize: 13, height: 1.4),
          ),

          const SizedBox(height: 18),

          // Tombol pill pengganti tab
          Row(
            children: [
              Expanded(child: _pillButton('Kelola Edukasi', 0)),
              const SizedBox(width: 12),
              Expanded(child: _pillButton('Kelola Katalog', 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pillButton(String label, int index) {
    final aktif = _tabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: aktif ? _mintKelola : Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: aktif ? FontWeight.bold : FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // ====== FOOTER ======
  // ====== FOOTER ======
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      selectedItemColor: _hijauNav,
      unselectedItemColor: Colors.black45,
      selectedFontSize: 9.5,
      unselectedFontSize: 9.5,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      onTap: (index) {
        if (index == 1) return; // sudah di halaman Kelola

        late final Widget tujuan;

        switch (index) {
          case 0:
            tujuan = const VerifikasiWargaScreen();
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
          default:
            return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => tujuan),
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
