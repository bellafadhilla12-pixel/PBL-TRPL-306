import 'package:flutter/material.dart';

import 'verifikasi_warga_screen.dart';
import 'rekap_kas.dart';
import 'rekap_sampah.dart';
import 'kelola_gabungan_screen.dart';
import 'kelola_antrian_pengumuman_screen.dart';
import 'profil_pengurus.dart';

const Color _hijau = Color(0xFF0D735B);
const Color _mint = Color(0xFF59CBA9);
const Color _cream = Color(0xFFF0F0E8);
const Color _hijauNav = Color(0xFF0F6E56); // sama dengan footer Verifikasi

class RekapGabunganScreen extends StatefulWidget {
  const RekapGabunganScreen({super.key});

  @override
  State<RekapGabunganScreen> createState() => _RekapGabunganScreenState();
}

class _RekapGabunganScreenState extends State<RekapGabunganScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
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
                          color: _mint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '● PANEL BENDAHARA RT 04 PLAMO',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _hijau,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilPengurusScreen(),
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        icon: const Icon(
                          Icons.account_circle_outlined,
                          color: _hijau,
                          size: 32,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Rekap Bank Sampah',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Laporan tabungan warga dan rekap sampah '
                    'yang masuk ke bank sampah.',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: _mint,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black87,
                      labelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      tabs: const [
                        Tab(text: 'Rekap Kas & Keuangan'),
                        Tab(text: 'Rekap Sampah'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  RekapKasPage(showBottomBar: false),
                  RekapSampahPage(showBottomBar: false),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 3,
      selectedItemColor: _hijauNav,
      unselectedItemColor: Colors.black45,
      selectedFontSize: 9.5,
      unselectedFontSize: 9.5,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      onTap: (index) {
        // Sudah berada di halaman Rekap.
        if (index == 3) return;

        late final Widget tujuan;

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
