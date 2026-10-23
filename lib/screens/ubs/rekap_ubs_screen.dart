import 'package:flutter/material.dart';
import 'profil_ubs.dart'; // Sesuaikan jika nama file profil berbeda.

const ubsGreen = Color(0xFF0D735B);
const ubsMint = Color(0xFF59CBA9);
const ubsCream = Color(0xFFF0F0E8);

String formatUbsRupiah(int value) {
  final text = value.toString();
  final result = StringBuffer();

  for (int i = 0; i < text.length; i++) {
    result.write(text[i]);
    final remaining = text.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) {
      result.write('.');
    }
  }
  return 'Rp $result';
}

class KategoriSampah {
  final String nama;
  final String kode;
  final Color warna;
  final int hargaPerKg;
  int nilai;

  KategoriSampah({
    required this.nama,
    required this.kode,
    required this.warna,
    required this.nilai,
    required this.hargaPerKg,
  });

  double persentase(int total) => total == 0 ? 0 : nilai / total * 100;
}

class SetoranSampah {
  final String nama;
  final String berat;
  final int nilai;
  final String kategori;

  SetoranSampah({
    required this.nama,
    required this.berat,
    required this.nilai,
    required this.kategori,
  });
}

class RekapUbsScreen extends StatefulWidget {
  const RekapUbsScreen({super.key});

  @override
  State<RekapUbsScreen> createState() => _RekapUbsScreenState();
}

class _RekapUbsScreenState extends State<RekapUbsScreen> {
  final List<KategoriSampah> kategori = [
    KategoriSampah(
      nama: 'Plastik',
      kode: 'P1-P24',
      warna: const Color(0xFF0E755E),
      nilai: 300000,
      hargaPerKg: 12000,
    ),
    KategoriSampah(
      nama: 'Logam & Besi',
      kode: 'C1-C3',
      warna: const Color(0xFFF6A21D),
      nilai: 500000,
      hargaPerKg: 20000,
    ),
    KategoriSampah(
      nama: 'Kertas & Kardus',
      kode: 'K1-K5',
      warna: const Color(0xFF526F16),
      nilai: 200000,
      hargaPerKg: 15000,
    ),
    KategoriSampah(
      nama: 'Minyak Jelantah',
      kode: 'MJ',
      warna: const Color(0xFF805A1F),
      nilai: 0,
      hargaPerKg: 8000,
    ),
  ];

  final List<SetoranSampah> setoran = [
    SetoranSampah(
      nama: 'Vania Desinta',
      berat: '5 Kg',
      nilai: 12000,
      kategori: 'Plastik',
    ),
    SetoranSampah(
      nama: 'Hendra Wijaya',
      berat: '4.5 Kg',
      nilai: 14000,
      kategori: 'Logam & Besi',
    ),
    SetoranSampah(
      nama: 'Agustina',
      berat: '3 Kg',
      nilai: 20000,
      kategori: 'Kertas & Kardus',
    ),
    SetoranSampah(
      nama: 'Bagus Stan',
      berat: '2 Kg',
      nilai: 10000,
      kategori: 'Minyak Jelantah',
    ),
  ];

  int get totalNilai => kategori.fold(0, (total, item) => total + item.nilai);

  void bukaProfil() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProfileUbs()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ubsCream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(),
                    const SizedBox(height: 20),
                    rekapSampah(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ubsMint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '● PANEL BENDAHARA RT 04 PLAMO',
                  style: TextStyle(
                    fontSize: 10,
                    color: ubsGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Profil UBS',
              onPressed: bukaProfil,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              icon: const Icon(
                Icons.account_circle_outlined,
                color: ubsGreen,
                size: 32,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Rekap Sampah Warga',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 5),
        const Text(
          'Laporan berat dan setoran sampah warga yang masuk ke bank sampah',
          style: TextStyle(fontSize: 12, height: 1.4),
        ),
      ],
    );
  }

  // ================= REKAP SAMPAH =================

  Widget rekapSampah() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        panelBarKategori(),
        const SizedBox(height: 18),
        panelSetoran(),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: buatPdf,
            style: ElevatedButton.styleFrom(
              backgroundColor: ubsGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text(
              'Buat PDF',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget panelBarKategori() {
    final kategoriAktif = kategori.where((item) => item.nilai > 0).toList();

    return panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: Color(0xFFB7E8D8),
                child: Icon(Icons.bar_chart, color: ubsGreen),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Penjualan per Kategori Sampah',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              Text('Bulan Ini', style: TextStyle(fontSize: 10)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 19,
              child: kategoriAktif.isEmpty
                  ? Container(color: Colors.black12)
                  : Row(
                      children: kategoriAktif.map((item) {
                        return Expanded(
                          flex: item.nilai,
                          child: Tooltip(
                            message:
                                '${item.nama}: ${formatUbsRupiah(item.nilai)} '
                                '(${item.persentase(totalNilai).toStringAsFixed(1)}%)',
                            child: Container(color: item.warna),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total: ${formatUbsRupiah(totalNilai)}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...kategori.map(kartuKategori),
        ],
      ),
    );
  }

  Widget kartuKategori(KategoriSampah item) {
    final persen = item.persentase(totalNilai);

    return Container(
      margin: const EdgeInsets.only(top: 9),
      padding: const EdgeInsets.all(11),
      decoration: dekorasiItem(),
      child: Row(
        children: [
          Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              color: item.warna,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.nama} (${item.kode})',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${persen.toStringAsFixed(1)}% dari total',
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatUbsRupiah(item.nilai),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${formatUbsRupiah(item.hargaPerKg)}/kg',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF526F16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget panelSetoran() {
    return panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: Color(0xFFB7E8D8),
                child: Icon(Icons.receipt_long, color: ubsGreen),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Rekap Setor Sampah',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              Text('Bulan Ini', style: TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 14),
          ...setoran.map(kartuSetoran),
        ],
      ),
    );
  }

  Widget kartuSetoran(SetoranSampah item) {
    final warna = kategori
        .firstWhere(
          (k) => k.nama == item.kategori,
          orElse: () => kategori.first,
        )
        .warna;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(11),
      decoration: dekorasiItem(),
      child: Row(
        children: [
          Container(
            width: 17,
            height: 17,
            decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.berat} • ${item.kategori}',
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+ ${formatUbsRupiah(item.nilai)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Lihat rincian',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF526F16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void buatPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur PDF perlu dihubungkan ke paket generator PDF.'),
      ),
    );
  }

  // ================= WIDGET BERSAMA =================

  BoxDecoration dekorasiKartu() {
    return BoxDecoration(
      color: const Color(0xFFFFFBFA),
      borderRadius: BorderRadius.circular(13),
      boxShadow: const [
        BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3)),
      ],
    );
  }

  BoxDecoration dekorasiItem() {
    return BoxDecoration(
      color: const Color(0xFFE1E0DA),
      borderRadius: BorderRadius.circular(13),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
      ],
    );
  }

  Widget panel({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(11),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1DCD8)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }

  Widget bottomBar() {
  return BottomNavigationBar(
    currentIndex: 0,
    type: BottomNavigationBarType.fixed,
    backgroundColor: const Color(0xFFF8FCFA),

    selectedItemColor: const Color(0xFF0F6E56),
    unselectedItemColor: Colors.black45,

    selectedFontSize: 9.5,
    unselectedFontSize: 9.5,

    selectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.w700,
    ),

    elevation: 8,

    onTap: (index) {
      if (index == 1) {
        bukaProfil();
      }
    },

    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_outlined),
        activeIcon: Icon(Icons.receipt_long),
        label: 'Rekap',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'UBS',
      ),
    ],
  );
}
}
