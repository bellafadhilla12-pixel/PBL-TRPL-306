import 'package:flutter/material.dart';

const sampahGreen = Color(0xFF0D735B);
const sampahMint = Color(0xFF59CBA9);
const sampahCream = Color(0xFFF0F0E8);

String rupiahSampah(int value) {
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
  KategoriSampah({
    required this.nama,
    required this.kode,
    required this.warna,
    required this.nilai,
    required this.hargaPerKg,
  });

  final String nama;
  final String kode;
  final Color warna;
  final int hargaPerKg;
  int nilai;

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

class RekapSampahPage extends StatefulWidget {
  final bool showBottomBar;

  const RekapSampahPage({super.key, this.showBottomBar = true});

  @override
  State<RekapSampahPage> createState() => _RekapSampahPageState();
}

class _RekapSampahPageState extends State<RekapSampahPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sampahCream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    saldoCard(),
                    const SizedBox(height: 20),
                    panelBarKategori(),
                    const SizedBox(height: 18),
                    panelSetoran(),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: buatPdf,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: sampahGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Buat PDF',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.showBottomBar) bottomBar(),
          ],
        ),
      ),
    );
  }

  // Kartu saldo kas
  Widget saldoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C725B), Color(0xFF19B88E)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 7, offset: Offset(0, 4)),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_outlined, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Total Tabungan Kas Posko Aktif',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Text(
            'Rp 14.500.000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'Kas fisik bendahara + rekening penampung',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Rekap penjualan berdasarkan kategori sampah
  Widget panelBarKategori() {
    return panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: Color(0xFFB7E8D8),
                child: Icon(Icons.bar_chart, color: sampahGreen),
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
              child: Row(
                children: kategori.where((item) => item.nilai > 0).map((item) {
                  return Expanded(
                    flex: item.nilai,
                    child: Tooltip(
                      message:
                          '${item.nama}: ${rupiahSampah(item.nilai)} '
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
              'Total: ${rupiahSampah(totalNilai)}',
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
      decoration: BoxDecoration(
        color: const Color(0xFFE1E0DA),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
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
                rupiahSampah(item.nilai),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${rupiahSampah(item.hargaPerKg)}/kg',
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

  // Riwayat setoran sampah
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
                child: Icon(Icons.receipt_long, color: sampahGreen),
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
      decoration: BoxDecoration(
        color: const Color(0xFFE1E0DA),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
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
                '+ ${rupiahSampah(item.nilai)}',
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

  Widget panel({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
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

  void buatPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur PDF perlu dihubungkan ke paket generator PDF.'),
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: sampahCream,
        border: Border(top: BorderSide(color: Color(0xFFE5E4DC))),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(Icons.verified_user_outlined, 'Verifikasi'),
          _NavItem(Icons.assignment_outlined, 'Katalog'),
          _NavItem(Icons.groups_2_outlined, 'Antrean'),
          _NavItem(Icons.bar_chart, 'Rekap'),
          _NavItem(Icons.person_outline, 'Pengurus'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: sampahGreen, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: sampahGreen,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
