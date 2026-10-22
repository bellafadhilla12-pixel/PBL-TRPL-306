
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kasGreen = Color(0xFF0D735B);
const kasMint = Color(0xFF59CBA9);
const kasLime = Color(0xFFBAF451);
const kasCream = Color(0xFFF0F0E8);

String formatRupiah(int value) {
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

class RekapKasPage extends StatefulWidget {
  final bool showBottomBar;

  const RekapKasPage({
    super.key,
    this.showBottomBar = true,
  });

  @override
  State<RekapKasPage> createState() => _RekapKasPageState();
}

class _RekapKasPageState extends State<RekapKasPage> {
  String bulanDipilih = 'Semua Bulan';
  bool tampilSemua = false;

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

  List<TransaksiKas> get transaksiDisetujui {
    return transaksi.where((item) {
      return item.disetujui &&
          (bulanDipilih == 'Semua Bulan' ||
              item.bulan == bulanDipilih);
    }).toList();
  }

  int get totalPencairan {
    return transaksiDisetujui.fold(
      0,
      (total, item) => total + item.nominal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kasCream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    kartuSaldo(),
                    const SizedBox(height: 20),
                    pemilihBulan(),
                    const SizedBox(height: 20),
                    kartuTotal(),
                    const SizedBox(height: 20),
                    judulRiwayat(),
                    const SizedBox(height: 8),

                    if (transaksiDisetujui.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'Belum ada pencairan pada bulan ini.',
                          ),
                        ),
                      )
                    else
                      ...((tampilSemua
                              ? transaksiDisetujui
                              : transaksiDisetujui.take(5))
                          .map(kartuTransaksi)),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: tambahPencairan,
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Simulasi Persetujuan Pencairan',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kasGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Data contoh tersimpan sementara selama aplikasi berjalan.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
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

  // Kartu total tabungan kas
  Widget kartuSaldo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0C725B),
            Color(0xFF19B88E),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 7,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_outlined,
                color: Colors.white,
              ),
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Filter berdasarkan bulan
  Widget pemilihBulan() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: bulanDipilih,
          isExpanded: true,
          items: daftarBulan.map((bulan) {
            return DropdownMenuItem(
              value: bulan,
              child: Text(bulan),
            );
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

  // Total pencairan sesuai bulan yang dipilih
  Widget kartuTotal() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFA),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
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
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            formatRupiah(totalPencairan),
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

  // Judul riwayat pencairan
  Widget judulRiwayat() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 17,
          backgroundColor: Color(0xFFB7E8D8),
          child: Icon(
            Icons.receipt_long,
            color: kasGreen,
            size: 20,
          ),
        ),
        const SizedBox(width: 9),
        const Expanded(
          child: Text(
            'Riwayat Pencairan Dana',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              tampilSemua = !tampilSemua;
            });
          },
          child: Text(
            tampilSemua ? 'Lebih Sedikit' : 'Lihat Semua',
          ),
        ),
      ],
    );
  }

  // Kartu transaksi pencairan
  Widget kartuTransaksi(TransaksiKas item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFA),
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 21,
            backgroundColor: Color(0xFFFFCB69),
            child: Icon(
              Icons.check_circle_outline,
              color: kasGreen,
              size: 29,
            ),
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
                  item.waktu,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: kasLime,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              formatRupiah(item.nominal),
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

  // Dialog simulasi persetujuan pencairan
  void tambahPencairan() {
    final namaController = TextEditingController();
    final nominalController = TextEditingController();

    String bulan = bulanDipilih == 'Semua Bulan'
        ? 'Oktober'
        : bulanDipilih;

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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Nominal pencairan',
                    prefixText: 'Rp ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: bulan,
                  decoration: const InputDecoration(
                    labelText: 'Bulan',
                    border: OutlineInputBorder(),
                  ),
                  items: daftarBulan
                      .where((item) => item != 'Semua Bulan')
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      refreshDialog(() {
                        bulan = value;
                      });
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
                final nominal = int.tryParse(
                  nominalController.text.trim(),
                );

                if (nama.isEmpty ||
                    nominal == null ||
                    nominal <= 0) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Masukkan nama dan nominal yang valid.',
                      ),
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
                    content: Text(
                      'Pencairan disetujui. Total diperbarui.',
                    ),
                  ),
                );
              },
              child: const Text('Setujui'),
            ),
          ],
        ),
      ),
    ).then((_) {
      namaController.dispose();
      nominalController.dispose();
    });
  }

  // Navigasi bawah jika halaman dibuka secara mandiri
  Widget bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: kasCream,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E4DC)),
        ),
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

  const _NavItem(this.icon, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: kasGreen,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: kasGreen,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
