import 'package:flutter/material.dart';

import '../../services/api_client.dart';

// ====== MODEL DATA ======
class SampahItem {
  final String kode;
  final String kategori; // PLASTIK, LOGAM, KERTAS/KARDUS, LIMBAH, LAINNYA
  final String nama;
  final String harga;
  final String badge;
  final String catatan;
  final bool berbahaya;

  const SampahItem({
    required this.kode,
    required this.kategori,
    required this.nama,
    required this.harga,
    required this.badge,
    required this.catatan,
    this.berbahaya = false,
  });
}

const _hijau = Color(0xFF0F6E56);
const _bg = Color(0xFFF4F1E8);
const _merah = Color(0xFFD32F2F);

Color _warnaKategori(String k) {
  switch (k) {
    case 'LOGAM':
      return const Color(0xFFE6A23C);
    case 'KERTAS/KARDUS':
      return const Color(0xFF7CB342);
    case 'LAINNYA':
      return const Color(0xFFF57C00);
    case 'LIMBAH':
      return _merah;
    default:
      return _hijau;
  }
}

// ====== DATA ======
const List<SampahItem> daftarSampah = [];

// ====== HALAMAN ======
class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  String _filter = 'Semua';
  String _query = '';

  /// Data awal memakai daftar lokal; setelah API merespons, diganti data server.
  List<SampahItem> _data = List<SampahItem>.from(daftarSampah);

  @override
  void initState() {
    super.initState();
    _muatKatalog();
  }

  Future<void> _muatKatalog() async {
    final res = await ApiClient.katalog();
    if (!mounted || !res.isSuccess) return;

    final items = res.dataList.map((m) {
      final kategori =
          (m['kategori']?.toString() ?? 'Lainnya').toUpperCase();
      return SampahItem(
        kode: 'S${m['id']}',
        kategori: kategori,
        nama: m['nama_sampah']?.toString() ?? '-',
        harga: m['harga']?.toString() ?? '-',
        badge: m['kategori']?.toString() ?? 'Sampah',
        catatan: m['deskripsi']?.toString() ?? '',
      );
    }).toList();

    if (mounted) {
      setState(() => _data = items);
    }
  }

  // Cek apakah item masuk ke kategori filter tertentu.
  // Dipakai untuk menyaring daftar DAN menghitung angka di chip.
  bool _cocokKategori(SampahItem s, String f) {
    switch (f) {
      case 'Plastik':
        return s.kategori == 'PLASTIK';
      case 'Limbah':
        return s.kategori == 'LIMBAH';
      case 'Logam':
        return s.kategori == 'LOGAM';
      case 'Kertas & Kardus':
        return s.kategori == 'KERTAS/KARDUS';
      default:
        return true; // Semua
    }
  }

  // Jumlah item per kategori (angka di dalam kurung pada chip).
  int _jumlah(String f) => _data.where((s) => _cocokKategori(s, f)).length;

  @override
  Widget build(BuildContext context) {
    final hasil = _data.where((s) {
      final cocokFilter = _cocokKategori(s, _filter);
      final q = _query.toLowerCase();
      final cocokCari =
          s.nama.toLowerCase().contains(q) ||
          s.kode.toLowerCase().contains(q) ||
          s.badge.toLowerCase().contains(q);
      return cocokFilter && cocokCari;
    }).toList();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _header(),
            const SizedBox(height: 12),
            _tipsCard(),
            const SizedBox(height: 12),
            _searchBar(),
            const SizedBox(height: 10),
            _filterChips(),
            const SizedBox(height: 8),
            _estimasiNote(),
            const SizedBox(height: 12),
            if (hasil.isEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 38, color: _hijau),
                    SizedBox(height: 8),
                    Text('Data katalog tidak ditemukan.'),
                  ],
                ),
              )
            else
              ...hasil.map((s) => SampahCard(item: s)),
          ],
        ),
      ),
    );
  }

  // Header: hanya panah kembali (kiri atas) ke Beranda + judul.
  Widget _header() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          IconButton(
            tooltip: 'Kembali ke Beranda',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: _hijau),
          ),
          const Expanded(
            child: Text(
              'Katalog & Panduan Pilah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      const Text(
        'Daftar kode resmi jenis sampah & panduan pemilahan nilai setor maksimal di Posko RT/RW Plamo Garden.',
        style: TextStyle(fontSize: 12, color: Colors.black87),
      ),
    ],
  );

  Widget _tipsCard() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF2E7D4F), Color(0xFF1FA67A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.lightbulb_outline, color: Colors.amber),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tips Sukses Setor Sampah',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Kenapa Harus Dipilah Sesuai Kode? ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Sampah yang bersih dan dipilah tepat sesuai kode mempermudah timbang posko dan mendapatkan estimasi saldo Rupiah terbaik!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _searchBar() => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: TextField(
      onChanged: (v) => setState(() => _query = v),
      decoration: InputDecoration(
        hintText: 'Cari kode atau nama sampah, contoh: botol, P3',
        hintStyle: const TextStyle(fontSize: 13),
        prefixIcon: const Icon(Icons.search, color: _hijau),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );

  Widget _filterChips() {
    const filters = ['Semua', 'Plastik', 'Logam', 'Kertas & Kardus', 'Limbah'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final aktif = _filter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text('$f(${_jumlah(f)})'),
              selected: aktif,
              selectedColor: _hijau,
              showCheckmark: false,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: aktif ? Colors.white : _hijau,
              ),
              onSelected: (_) => setState(() => _filter = f),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _estimasiNote() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE9B8),
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Estimasi Nilai Setor: '),
          TextSpan(
            text: 'Harga dapat berubah sewaktu-waktu mengikuti kondisi pengepul mitra Posko RT/RW',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      style: TextStyle(fontSize: 11, color: Colors.black87),
    ),
  );
}

// ====== KARTU ITEM ======
class SampahCard extends StatelessWidget {
  final SampahItem item;
  const SampahCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final warna = _warnaKategori(item.kategori);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: item.berbahaya ? Border.all(color: _merah, width: 1.2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kode
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.kode,
                  style: TextStyle(fontWeight: FontWeight.bold, color: warna),
                ),
              ),
              const SizedBox(width: 10),

              // Kategori + nama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KATEGORI ${item.kategori}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: warna,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.nama,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Harga (+ badge B3 di sampingnya) dan badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.berbahaya) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _merah,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'B3 BERBAHAYA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE0A3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item.harga,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.badge,
                      style: const TextStyle(fontSize: 9),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Catatan pemilahan (merah pekat + teks putih untuk limbah B3)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: item.berbahaya ? _merah : const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Catatan Pemilahan: ${item.catatan}',
              style: TextStyle(
                fontSize: 11,
                color: item.berbahaya ? Colors.white : Colors.black54,
                fontWeight: item.berbahaya
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
