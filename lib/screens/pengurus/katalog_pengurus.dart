import 'package:flutter/material.dart';

import 'rekap_gabungan_screen.dart';
import 'kelola_gabungan_screen.dart';
import 'verifikasi_warga_screen.dart';
import 'kelola_antrian_pengumuman_screen.dart';
import 'profil_pengurus.dart';

// ====== MODEL DATA ======
class SampahItem {
  final String kode;
  final String kategori;
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

  SampahItem copyWith({
    String? kode,
    String? kategori,
    String? nama,
    String? harga,
    String? badge,
    String? catatan,
    bool? berbahaya,
  }) {
    return SampahItem(
      kode: kode ?? this.kode,
      kategori: kategori ?? this.kategori,
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
      badge: badge ?? this.badge,
      catatan: catatan ?? this.catatan,
      berbahaya: berbahaya ?? this.berbahaya,
    );
  }
}

const _hijau = Color(0xFF0F6E56);
const _bg = Color(0xFFF4F1E8);
const _merah = Color(0xFFD32F2F);

Color _warnaKategori(String k) {
  switch (k.toUpperCase()) {
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

// ====== DATA KATALOG AWAL ======
final List<SampahItem> daftarSampah = [
  const SampahItem(
    kode: 'P1',
    kategori: 'PLASTIK',
    nama: 'Gelas cup bening bersih',
    harga: 'Rp 4.500/kg',
    badge: 'Cup Plastik',
    catatan: 'Label dan tutup dibuang',
  ),
  const SampahItem(
    kode: 'P2',
    kategori: 'PLASTIK',
    nama: 'Gelas cup bening kotor',
    harga: 'Rp 2.200/kg',
    badge: 'Cup Plastik',
    catatan: 'Label & tutup dibuang',
  ),
  const SampahItem(
    kode: 'P3',
    kategori: 'PLASTIK',
    nama: 'Botol plastik bersih',
    harga: 'Rp 3.800/kg',
    badge: 'Prioritas Tinggi',
    catatan: 'Label & tutup dilepas',
  ),
  const SampahItem(
    kode: 'P4',
    kategori: 'PLASTIK',
    nama: 'Botol plastik kotor',
    harga: 'Rp 1.600/kg',
    badge: 'Botol Plastik',
    catatan: 'Nilai lebih rendah dari P3',
  ),
  const SampahItem(
    kode: 'P7',
    kategori: 'PLASTIK',
    nama: 'Ember',
    harga: 'Rp 2.500/kg',
    badge: 'Plastik Keras',
    catatan: 'Barang plastik keras/tebal',
  ),
  const SampahItem(
    kode: 'P8',
    kategori: 'PLASTIK',
    nama: 'Tutup galon',
    harga: 'Rp 3.500/kg',
    badge: 'Aksesoris Galon',
    catatan: 'Dipisah tersendiri',
  ),
  const SampahItem(
    kode: 'P9',
    kategori: 'PLASTIK',
    nama: 'Tutup botol',
    harga: 'Rp 3.000/kg',
    badge: 'Aksesoris Botol',
    catatan: 'Dipisah tersendiri',
  ),
  const SampahItem(
    kode: 'P10',
    kategori: 'PLASTIK',
    nama: 'Kresek/kantong asoy warna-warni',
    harga: 'Rp 800/kg',
    badge: 'Kantong Film',
    catatan: 'Kering dan bersih',
  ),
  const SampahItem(
    kode: 'P18',
    kategori: 'PLASTIK',
    nama: 'Ember hitam',
    harga: 'Rp 1.500/kg',
    badge: 'Plastik Hitam',
    catatan: 'Dipisah dari ember warna (P7)',
  ),
  const SampahItem(
    kode: 'P20',
    kategori: 'LIMBAH',
    nama: 'Aki bekas',
    harga: 'Rp 12.000/kg',
    badge: 'Limbah',
    catatan: 'Sisa air aki wajib dibuang dahulu',
    berbahaya: true,
  ),
  const SampahItem(
    kode: 'P21',
    kategori: 'PLASTIK',
    nama: 'Kaset CD',
    harga: 'Rp 3.500/kg',
    badge: 'Polikarbonat',
    catatan: '-',
  ),
  const SampahItem(
    kode: 'P23',
    kategori: 'PLASTIK',
    nama: 'HDPE',
    harga: 'Rp 4.000/kg',
    badge: 'HDPE Tebal',
    catatan: 'Plastik jenis tebal (galon, botol tebal, dll)',
  ),
  const SampahItem(
    kode: 'P24',
    kategori: 'PLASTIK',
    nama: 'Gelas cup warna',
    harga: 'Rp 2.000/kg',
    badge: 'Cup Berwarna',
    catatan: 'Dipisah dari cup bening (P1/P2)',
  ),
  const SampahItem(
    kode: 'C1',
    kategori: 'LOGAM',
    nama: 'Kaleng alka (aluminium)',
    harga: 'Rp 13.000/kg',
    badge: 'Aluminium Ringan',
    catatan: 'Kaleng minuman',
  ),
  const SampahItem(
    kode: 'C2',
    kategori: 'LOGAM',
    nama: 'Besi kropos',
    harga: 'Rp 3.200/kg',
    badge: 'Besi Tua',
    catatan: 'Besi tua/berkarat',
  ),
  const SampahItem(
    kode: 'C3',
    kategori: 'LOGAM',
    nama: 'ALMA (aluminium)',
    harga: 'Rp 15.000/kg',
    badge: 'Perabot Dapur',
    catatan: 'Panci/wajan aluminium bekas',
  ),
  const SampahItem(
    kode: 'K1',
    kategori: 'KERTAS/KARDUS',
    nama: 'Karton/kardus',
    harga: 'Rp 1.800/kg',
    badge: 'Populer',
    catatan: 'Dilipat, dipisah dari lakban plastik',
  ),
  const SampahItem(
    kode: 'K2',
    kategori: 'KERTAS/KARDUS',
    nama: 'Buku paket pelajaran',
    harga: 'Rp 1.500/kg',
    badge: 'Buku Sekolah',
    catatan: 'Sampul/cover harus dilepas dulu',
  ),
  const SampahItem(
    kode: 'K3',
    kategori: 'KERTAS/KARDUS',
    nama: 'HVS (kertas putih)',
    harga: 'Rp 2.400/kg',
    badge: 'Dokumen Kantor',
    catatan: 'Kering dan tanpa klip/staples',
  ),
  const SampahItem(
    kode: 'K4',
    kategori: 'KERTAS/KARDUS',
    nama: 'Kertas padat',
    harga: 'Rp 1.200/kg',
    badge: 'Campuran',
    catatan: 'Kertas campuran/tebal',
  ),
  const SampahItem(
    kode: 'K5',
    kategori: 'KERTAS/KARDUS',
    nama: 'Koran bekas',
    harga: 'Rp 1.600/kg',
    badge: 'Koran/Media',
    catatan: 'Kering dan rapi',
  ),
  const SampahItem(
    kode: 'MJ',
    kategori: 'LAINNYA',
    nama: 'Minyak jelantah',
    harga: 'Rp 6.500/kg',
    badge: 'Cair/Liter',
    catatan: 'Ditampung dalam jerigen/botol tertutup rapat',
  ),
];

// ====== HALAMAN KATALOG PENGURUS ======
class KatalogPengurusScreen extends StatefulWidget {
  final bool showBottomBar;

  const KatalogPengurusScreen({super.key, this.showBottomBar = true});

  @override
  State<KatalogPengurusScreen> createState() => _KatalogPengurusScreenState();
}

class _KatalogPengurusScreenState extends State<KatalogPengurusScreen> {
  String _filter = 'Semua';
  String _query = '';

  final List<String> _kategori = [
    'PLASTIK',
    'LIMBAH',
    'LOGAM',
    'KERTAS/KARDUS',
    'LAINNYA',
  ];

  List<String> get _semuaKategori => List<String>.from(_kategori)..sort();

  String _labelKategori(String kategori) {
    switch (kategori) {
      case 'PLASTIK':
        return 'Plastik';
      case 'LIMBAH':
        return 'Limbah';
      case 'LOGAM':
        return 'Logam';
      case 'KERTAS/KARDUS':
        return 'Kertas & Kardus';
      case 'LAINNYA':
        return 'Lainnya';
      default:
        return kategori;
    }
  }

  bool _cocokKategori(SampahItem s, String f) =>
      f == 'Semua' || s.kategori == f;

  int _jumlah(String f) => f == 'Semua'
      ? daftarSampah.length
      : daftarSampah.where((s) => _cocokKategori(s, f)).length;

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase().trim();

    final hasil = daftarSampah.where((s) {
      final cocokFilter = _cocokKategori(s, _filter);

      final cocokCari =
          s.nama.toLowerCase().contains(q) ||
          s.kode.toLowerCase().contains(q) ||
          s.badge.toLowerCase().contains(q) ||
          s.kategori.toLowerCase().contains(q);

      return cocokFilter && cocokCari;
    }).toList();

    final content = ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header hanya muncul jika halaman dibuka secara mandiri.
        if (widget.showBottomBar) ...[_header(), const SizedBox(height: 12)],

        _menuPengelolaan(),
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
          ...hasil.map(
            (s) => SampahCard(
              key: ValueKey(s.kode),
              item: s,
              onEdit: () => _dialogSampah(index: daftarSampah.indexOf(s)),
              onDelete: () => _hapusSampah(daftarSampah.indexOf(s)),
            ),
          ),
      ],
    );

    // Mode tab: hanya tampilkan konten katalog, tanpa Scaffold
    // dan tanpa bottom navigation tambahan.
    if (!widget.showBottomBar) {
      return Container(color: _bg, child: content);
    }

    // Mode halaman mandiri.
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(child: content),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ====== HEADER ======
  Widget _header() => Row(
    children: [
      IconButton(
        tooltip: 'Kembali',
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const KelolaGabunganScreen()),
          );
        },
        icon: const Icon(Icons.arrow_back_rounded, color: _hijau),
      ),
      const Expanded(
        child: Text(
          'Katalog & Kategori Sampah',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      IconButton(
        tooltip: 'Profil Pengurus',
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ProfilPengurusScreen()),
          );
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        icon: const Icon(
          Icons.account_circle_outlined,
          color: _hijau,
          size: 30,
        ),
      ),
    ],
  );

  // ====== MENU PENGELOLAAN ======
  Widget _menuPengelolaan() => Row(
    children: [
      Expanded(
        child: FilledButton.icon(
          onPressed: _dialogSampah,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Tambah Katalog', textAlign: TextAlign.center),
          style: FilledButton.styleFrom(
            backgroundColor: _hijau,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            textStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: _kelolaKategori,
          icon: const Icon(Icons.category_outlined, size: 18),
          label: const Text('Kelola Kategori', textAlign: TextAlign.center),
          style: OutlinedButton.styleFrom(
            foregroundColor: _hijau,
            side: const BorderSide(color: _hijau),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            textStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );

  // ====== TIPS ======
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
                      text: 'Sampah yang bersih dan dipilah tepat sesuai kode mempermudah timbang posko dan mendapatkan estimasi nilai Rupiah terbaik!',
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

  // ====== PENCARIAN ======
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

  // ====== FILTER KATEGORI ======
  Widget _filterChips() {
    final filters = ['Semua', ..._semuaKategori];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final aktif = _filter == f;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                f == 'Semua'
                    ? 'Semua (${_jumlah(f)})'
                    : '${_labelKategori(f)} (${_jumlah(f)})',
              ),
              selected: aktif,
              selectedColor: _hijau,
              showCheckmark: false,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: aktif ? Colors.white : _hijau,
              ),
              onSelected: (_) => setState(() => _filter = f),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ====== CATATAN HARGA ======
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
            text: 'Harga dapat berubah sewaktu-waktu mengikuti kondisi pengepul mitra Posko RT/RW.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      style: TextStyle(fontSize: 11, color: Colors.black87),
    ),
  );

  // ====== TAMBAH / EDIT KATALOG ======
  Future<void> _dialogSampah({int? index}) async {
    final isEdit = index != null;
    final item = isEdit ? daftarSampah[index] : null;

    final kodeController = TextEditingController(text: item?.kode ?? '');
    final namaController = TextEditingController(text: item?.nama ?? '');
    final hargaController = TextEditingController(
      text: item?.harga.replaceFirst('Rp ', '') ?? '',
    );
    final badgeController = TextEditingController(text: item?.badge ?? '');
    final catatanController = TextEditingController(text: item?.catatan ?? '');

    String kategori =
        item?.kategori ??
        (_semuaKategori.isNotEmpty ? _semuaKategori.first : 'PLASTIK');

    bool berbahaya = item?.berbahaya ?? false;
    final formKey = GlobalKey<FormState>();

    final simpan = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Katalog Sampah' : 'Tambah Katalog Sampah'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _input(kodeController, 'Kode sampah', validator: _wajib),
                    const SizedBox(height: 10),
                    _input(namaController, 'Nama sampah', validator: _wajib),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: _semuaKategori.contains(kategori)
                          ? kategori
                          : (_semuaKategori.isNotEmpty
                                ? _semuaKategori.first
                                : null),
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items: _semuaKategori
                          .map(
                            (k) => DropdownMenuItem<String>(
                              value: k,
                              child: Text(_labelKategori(k)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => kategori = v);
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    _input(
                      hargaController,
                      'Harga (contoh: 4.500/kg)',
                      validator: _wajib,
                    ),
                    const SizedBox(height: 10),
                    _input(badgeController, 'Label / badge', validator: _wajib),
                    const SizedBox(height: 10),
                    _input(
                      catatanController,
                      'Catatan pemilahan',
                      validator: _wajib,
                      maxLines: 2,
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: berbahaya,
                      title: const Text(
                        'Termasuk limbah B3 / berbahaya',
                        style: TextStyle(fontSize: 13),
                      ),
                      onChanged: (v) {
                        setDialogState(() => berbahaya = v ?? false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );

    if (simpan == true && mounted) {
      final kode = kodeController.text.trim().toUpperCase();

      final duplikat = daftarSampah.asMap().entries.any(
        (entry) => entry.value.kode.toUpperCase() == kode && entry.key != index,
      );

      if (duplikat) {
        _pesan('Kode sampah sudah digunakan. Gunakan kode lain.');
      } else {
        final harga = hargaController.text.trim().replaceFirst(
          RegExp(r'^Rp\s*', caseSensitive: false),
          '',
        );

        final dataBaru = SampahItem(
          kode: kode,
          kategori: kategori,
          nama: namaController.text.trim(),
          harga: 'Rp $harga',
          badge: badgeController.text.trim(),
          catatan: catatanController.text.trim(),
          berbahaya: berbahaya,
        );

        setState(() {
          if (isEdit) {
            daftarSampah[index] = dataBaru;
          } else {
            daftarSampah.add(dataBaru);
          }

          if (!_semuaKategori.contains(_filter)) {
            _filter = 'Semua';
          }
        });

        _pesan(
          isEdit ? 'Katalog berhasil diubah.' : 'Katalog berhasil ditambahkan.',
        );
      }
    }

    kodeController.dispose();
    namaController.dispose();
    hargaController.dispose();
    badgeController.dispose();
    catatanController.dispose();
  }

  // ====== HAPUS KATALOG ======
  Future<void> _hapusSampah(int index) async {
    final item = daftarSampah[index];

    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Katalog'),
        content: Text('Hapus katalog "${item.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: _merah),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true && mounted) {
      setState(() {
        daftarSampah.removeAt(index);

        if (_filter != 'Semua' && !_semuaKategori.contains(_filter)) {
          _filter = 'Semua';
        }
      });

      _pesan('Katalog berhasil dihapus.');
    }
  }

  // ====== TAMBAH / EDIT / HAPUS KATEGORI ======
  Future<void> _kelolaKategori() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Kelola Kategori Sampah'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      await _formKategori();
                      setDialogState(() {});
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Kategori'),
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: _semuaKategori
                        .map(
                          (kategori) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: _warnaKategori(kategori)
                                  .withValues(alpha: .15),
                              child: Icon(
                                Icons.category_outlined,
                                color: _warnaKategori(kategori),
                              ),
                            ),
                            title: Text(_labelKategori(kategori)),
                            subtitle: Text('${_jumlah(kategori)} katalog'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Edit kategori',
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: _hijau,
                                  ),
                                  onPressed: () async {
                                    await _formKategori(kategoriLama: kategori);
                                    setDialogState(() {});
                                  },
                                ),
                                IconButton(
                                  tooltip: 'Hapus kategori',
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: _merah,
                                  ),
                                  onPressed: () async {
                                    await _hapusKategori(kategori);
                                    setDialogState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _formKategori({String? kategoriLama}) async {
    final controller = TextEditingController(
      text: kategoriLama == null ? '' : _labelKategori(kategoriLama),
    );

    final formKey = GlobalKey<FormState>();

    final namaBaru = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(kategoriLama == null ? 'Tambah Kategori' : 'Edit Kategori'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nama kategori',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Nama kategori wajib diisi.'
                : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(dialogContext, controller.text.trim());
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (namaBaru == null || !mounted) return;

    final normalized = _normalisasiKategori(namaBaru);

    final bentrok = _semuaKategori.any(
      (k) => k.toLowerCase() == normalized.toLowerCase() && k != kategoriLama,
    );

    if (bentrok) {
      _pesan('Kategori tersebut sudah ada.');
      return;
    }

    setState(() {
      if (kategoriLama == null) {
        _kategori.add(normalized);
      } else {
        for (var i = 0; i < daftarSampah.length; i++) {
          if (daftarSampah[i].kategori == kategoriLama) {
            daftarSampah[i] = daftarSampah[i].copyWith(kategori: normalized);
          }
        }

        final kategoriIndex = _kategori.indexOf(kategoriLama);

        if (kategoriIndex >= 0) {
          _kategori[kategoriIndex] = normalized;
        }

        if (_filter == kategoriLama) {
          _filter = normalized;
        }
      }
    });

    _pesan(
      kategoriLama == null
          ? 'Kategori berhasil ditambahkan.'
          : 'Kategori berhasil diubah.',
    );
  }

  String _normalisasiKategori(String nama) {
    final trimmed = nama.trim();

    switch (trimmed.toLowerCase()) {
      case 'plastik':
        return 'PLASTIK';
      case 'logam':
        return 'LOGAM';
      case 'limbah':
        return 'LIMBAH';
      case 'lainnya':
        return 'LAINNYA';
      case 'kertas & kardus':
      case 'kertas/kardus':
        return 'KERTAS/KARDUS';
      default:
        return trimmed.toUpperCase();
    }
  }

  Future<void> _hapusKategori(String kategori) async {
    final jumlahItem = daftarSampah.where((s) => s.kategori == kategori).length;

    if (jumlahItem > 0) {
      _pesan(
        'Kategori masih digunakan oleh $jumlahItem katalog. '
        'Edit atau hapus katalog tersebut terlebih dahulu.',
      );
      return;
    }

    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text('Hapus kategori "${_labelKategori(kategori)}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: _merah),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin == true && mounted) {
      setState(() {
        _kategori.remove(kategori);

        if (_filter == kategori) {
          _filter = 'Semua';
        }
      });

      _pesan('Kategori berhasil dihapus.');
    }
  }

  // ====== INPUT FORM ======
  Widget _input(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  String? _wajib(String? value) {
    return value == null || value.trim().isEmpty
        ? 'Bagian ini wajib diisi.'
        : null;
  }

  void _pesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  // ====== BOTTOM NAVIGATION PENGURUS ======
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      backgroundColor: Colors.white,
      selectedItemColor: _hijau,
      unselectedItemColor: Colors.black45,
      selectedFontSize: 9.5,
      unselectedFontSize: 9.5,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      onTap: (index) {
        // Menu Kelola selalu membuka halaman gabungan.
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const KelolaGabunganScreen()),
          );
          return;
        }

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

class _FormSampahDialog extends StatefulWidget {
  final SampahItem? item;
  final List<String> kategoriList;
  final String Function(String) labelKategori;

  const _FormSampahDialog({
    required this.item,
    required this.kategoriList,
    required this.labelKategori,
  });

  @override
  State<_FormSampahDialog> createState() => _FormSampahDialogState();
}

class _FormSampahDialogState extends State<_FormSampahDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _kodeC;
  late final TextEditingController _namaC;
  late final TextEditingController _hargaC;
  late final TextEditingController _badgeC;
  late final TextEditingController _catatanC;

  late String _kategori;
  late bool _berbahaya;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;

    _kodeC = TextEditingController(text: item?.kode ?? '');
    _namaC = TextEditingController(text: item?.nama ?? '');
    _hargaC = TextEditingController(
      text: item?.harga.replaceFirst('Rp ', '') ?? '',
    );
    _badgeC = TextEditingController(text: item?.badge ?? '');
    _catatanC = TextEditingController(text: item?.catatan ?? '');

    _berbahaya = item?.berbahaya ?? false;

    final daftar = widget.kategoriList;
    _kategori = (item != null && daftar.contains(item.kategori))
        ? item.kategori
        : (daftar.isNotEmpty ? daftar.first : 'PLASTIK');
  }

  @override
  void dispose() {
    _kodeC.dispose();
    _namaC.dispose();
    _hargaC.dispose();
    _badgeC.dispose();
    _catatanC.dispose();
    super.dispose();
  }

  String? _wajib(String? v) =>
      v == null || v.trim().isEmpty ? 'Bagian ini wajib diisi.' : null;

  Widget _input(TextEditingController c, String label, {int maxLines = 1}) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      validator: _wajib,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final harga = _hargaC.text.trim().replaceFirst(
      RegExp(r'^Rp\s*', caseSensitive: false),
      '',
    );

    final hasil = SampahItem(
      kode: _kodeC.text.trim().toUpperCase(),
      kategori: _kategori,
      nama: _namaC.text.trim(),
      harga: 'Rp $harga',
      badge: _badgeC.text.trim(),
      catatan: _catatanC.text.trim(),
      berbahaya: _berbahaya,
    );

    Navigator.pop(context, hasil);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit Katalog Sampah' : 'Tambah Katalog Sampah'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _input(_kodeC, 'Kode sampah'),
                const SizedBox(height: 10),
                _input(_namaC, 'Nama sampah'),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _kategori,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.kategoriList
                      .map(
                        (k) => DropdownMenuItem<String>(
                          value: k,
                          child: Text(widget.labelKategori(k)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _kategori = v);
                  },
                ),
                const SizedBox(height: 10),
                _input(_hargaC, 'Harga (contoh: 4.500/kg)'),
                const SizedBox(height: 10),
                _input(_badgeC, 'Label / badge'),
                const SizedBox(height: 10),
                _input(_catatanC, 'Catatan pemilahan', maxLines: 2),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _berbahaya,
                  title: const Text(
                    'Termasuk limbah B3 / berbahaya',
                    style: TextStyle(fontSize: 13),
                  ),
                  onChanged: (v) => setState(() => _berbahaya = v ?? false),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _simpan, child: const Text('Simpan')),
      ],
    );
  }
}

// ====== KARTU ITEM SAMPAH ======
class SampahCard extends StatelessWidget {
  final SampahItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SampahCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Edit katalog',
                    onPressed: onEdit,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: _hijau,
                      size: 21,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Hapus katalog',
                    onPressed: onDelete,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: _merah,
                      size: 21,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (item.berbahaya) ...[
                Container(
                  key: const ValueKey('badge-b3'),
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
                const SizedBox(key: ValueKey('gap-b3'), width: 6),
              ],
              Expanded(
                key: const ValueKey('badge-kategori'),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
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
                ),
              ),
              Container(
                key: const ValueKey('harga'),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
          const SizedBox(height: 8),
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
