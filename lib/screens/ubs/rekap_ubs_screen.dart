import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'profil_ubs.dart'; // Sesuaikan jika nama file profil berbeda.

const ubsGreen = Color(0xFF0D735B);
const ubsMint = Color(0xFF59CBA9);
const ubsLime = Color(0xFFBAF451);
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

class TransaksiKas {
  final String nama;
  final String bulan;
  final String waktu;
  final int nominal;
  final bool disetujui;

  TransaksiKas({
    required this.nama,
    required this.bulan,
    required this.waktu,
    required this.nominal,
    required this.disetujui,
  });
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
  int tabDipilih = 0;
  String bulanDipilih = 'Semua Bulan';
  bool tampilSemua = false;

  final List<String> daftarBulan = const [
    'Semua Bulan',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final List<TransaksiKas> transaksi = [
    TransaksiKas(
      nama: 'Siti Aminah',
      bulan: 'Oktober',
      waktu: '09:30',
      nominal: 12000,
      disetujui: true,
    ),
    TransaksiKas(
      nama: 'Abdul Jamal',
      bulan: 'Oktober',
      waktu: '10:00',
      nominal: 24000,
      disetujui: true,
    ),
    TransaksiKas(
      nama: 'Arifin Ahmad',
      bulan: 'Oktober',
      waktu: '10:30',
      nominal: 150000,
      disetujui: true,
    ),
    TransaksiKas(
      nama: 'Bagus Abdullah',
      bulan: 'Oktober',
      waktu: '11:00',
      nominal: 50000,
      disetujui: true,
    ),
    TransaksiKas(
      nama: 'Aisyah Ainun',
      bulan: 'Oktober',
      waktu: '11:30',
      nominal: 13000,
      disetujui: true,
    ),
    TransaksiKas(
      nama: 'Dewi Lestari',
      bulan: 'September',
      waktu: '13:00',
      nominal: 35000,
      disetujui: true,
    ),
    TransaksiKas(
      nama: 'Rudi Hartono',
      bulan: 'Oktober',
      waktu: '14:00',
      nominal: 80000,
      disetujui: false,
    ),
  ];

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

  List<TransaksiKas> get transaksiDisetujui {
    return transaksi.where((item) {
      return item.disetujui &&
          (bulanDipilih == 'Semua Bulan' || item.bulan == bulanDipilih);
    }).toList();
  }

  int get totalPencairan =>
      transaksiDisetujui.fold(0, (total, item) => total + item.nominal);

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
                    saldoCard(),
                    const SizedBox(height: 20),
                    pilihanTab(),
                    const SizedBox(height: 20),
                    if (tabDipilih == 0) rekapKas() else rekapSampah(),
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
          'Rekap Bank Sampah',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 5),
        const Text(
          'Laporan tabungan warga dan rekap sampah yang masuk ke bank sampah',
          style: TextStyle(fontSize: 12, height: 1.4),
        ),
      ],
    );
  }

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

  Widget pilihanTab() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFE1E0DA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          tabButton('Rekap Kas', Icons.account_balance_wallet_outlined, 0),
          tabButton('Rekap Sampah', Icons.recycling_outlined, 1),
        ],
      ),
    );
  }

  Widget tabButton(String label, IconData icon, int index) {
    final selected = tabDipilih == index;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => tabDipilih = index),
        borderRadius: BorderRadius.circular(11),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
          decoration: BoxDecoration(
            color: selected ? ubsGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: selected ? Colors.white : ubsGreen),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : ubsGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= REKAP KAS =================

  Widget rekapKas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pemilihBulan(),
        const SizedBox(height: 20),
        kartuTotal(),
        const SizedBox(height: 20),
        judulRiwayat(),
        const SizedBox(height: 10),
        if (transaksiDisetujui.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Belum ada pencairan pada bulan ini.'),
            ),
          )
        else
          ...(tampilSemua ? transaksiDisetujui : transaksiDisetujui.take(5))
              .map(kartuTransaksi),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: tambahPencairan,
            icon: const Icon(Icons.add),
            label: const Text('Simulasi Persetujuan Pencairan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ubsGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Data contoh tersimpan sementara selama aplikasi berjalan.',
          style: TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  Widget pemilihBulan() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: bulanDipilih,
          isExpanded: true,
          items: daftarBulan.map((bulan) {
            return DropdownMenuItem(value: bulan, child: Text(bulan));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                bulanDipilih = value;
                tampilSemua = false;
              });
            }
          },
        ),
      ),
    );
  }

  Widget kartuTotal() {
    return panel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total Pencairan Dana',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                '${transaksiDisetujui.length} pencairan cash',
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            formatUbsRupiah(totalPencairan),
            style: const TextStyle(
              color: Color(0xFFFF6B65),
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget judulRiwayat() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 17,
          backgroundColor: Color(0xFFB7E8D8),
          child: Icon(Icons.receipt_long, color: ubsGreen, size: 20),
        ),
        const SizedBox(width: 9),
        const Expanded(
          child: Text(
            'Riwayat Pencairan Dana',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() => tampilSemua = !tampilSemua);
          },
          child: Text(tampilSemua ? 'Lebih Sedikit' : 'Lihat Semua'),
        ),
      ],
    );
  }

  Widget kartuTransaksi(TransaksiKas item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: dekorasiKartu(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 21,
            backgroundColor: Color(0xFFFFCB69),
            child: Icon(Icons.check_circle_outline, color: ubsGreen, size: 29),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.bulan} • ${item.waktu}',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: ubsLime,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              formatUbsRupiah(item.nominal),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF46630E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void tambahPencairan() {
    final namaController = TextEditingController();
    final nominalController = TextEditingController();

    String bulan = bulanDipilih == 'Semua Bulan' ? 'Oktober' : bulanDipilih;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, refreshDialog) => AlertDialog(
          title: const Text('Setujui Pencairan Dana'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama warga',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nominalController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Nominal pencairan',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: bulan,
                  decoration: const InputDecoration(
                    labelText: 'Bulan',
                    border: OutlineInputBorder(),
                  ),
                  items: daftarBulan
                      .where((item) => item != 'Semua Bulan')
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      refreshDialog(() => bulan = value);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final nama = namaController.text.trim();
                final nominal = int.tryParse(nominalController.text.trim());

                if (nama.isEmpty || nominal == null || nominal <= 0) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text('Masukkan nama dan nominal yang valid.'),
                    ),
                  );
                  return;
                }

                setState(() {
                  transaksi.insert(
                    0,
                    TransaksiKas(
                      nama: nama,
                      bulan: bulan,
                      waktu: TimeOfDay.now().format(this.context),
                      nominal: nominal,
                      disetujui: true,
                    ),
                  );
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(
                    content: Text('Pencairan disetujui. Total diperbarui.'),
                  ),
                );
              },
              child: const Text('Setujui'),
            ),
          ],
        ),
      ),
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
      backgroundColor: const Color(0xFFDDF5E8),
      selectedItemColor: const Color(0xFF08785F),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 1) {
          bukaProfil();
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Rekap'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Pengurus'),
      ],
    );
  }
}
