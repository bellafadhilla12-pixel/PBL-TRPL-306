import 'package:flutter/material.dart';
import 'verifikasi_warga_screen.dart';
import 'kelola_antrian_pengumuman_screen.dart';
import 'profil_pengurus.dart';
import 'package:flutter/material.dart';

import 'katalog_pengurus.dart';

/// Halaman Pengurus untuk mengelola materi edukasi TRIM.
/// Data pada contoh ini masih disimpan sementara di memori aplikasi.
/// Hubungkan ke database/API agar perubahan tersimpan permanen.
class KelolaEdukasiPengurusScreen extends StatefulWidget {
  const KelolaEdukasiPengurusScreen({super.key});

  @override
  State<KelolaEdukasiPengurusScreen> createState() =>
      _KelolaEdukasiPengurusScreenState();
}

class _KelolaEdukasiPengurusScreenState
    extends State<KelolaEdukasiPengurusScreen> {
  static const Color green = Color(0xFF08765F);
  static const Color mint = Color(0xFF5BCBAA);
  static const Color pageColor = Color(0xFFF1F0E8);
  static const Color cardColor = Color(0xFFFFFCFC);

  String selectedFilter = 'Semua Materi';
  final List<Map<String, String>> materi = [
    {
      'kategori': 'Pilah Anorganik',
      'judul': 'Plastik (Botol P3 & Cup P1/P2)',
      'label': 'Tinggi',
      'deskripsi':
          'Bilas sisa minuman manis, lepaskan label luar dan cincin leher botol, lalu remas atau injak hingga pipih agar kantong tampung muat lebih banyak.',
    },
    {
      'kategori': 'Pilah Anorganik',
      'judul': 'Kertas & Kardus (K1 - K5)',
      'label': 'Prioritas',
      'deskripsi':
          'Kelupas lakban atau selotip, lipat kardus hingga rata, serta pisahkan kertas yang berminyak atau bekas kemasan makanan.',
    },
    {
      'kategori': 'Pilah Anorganik',
      'judul': 'Logam & Kaleng (C1 - C3)',
      'label': 'Rutin',
      'deskripsi':
          'Cuci bersih kaleng susu atau sarden. Pastikan tidak ada sisa saus atau minyak agar tidak memicu karat atau mengundang lalat.',
    },
    {
      'kategori': 'Pilah Anorganik',
      'judul': 'Minyak Jelantah (MJ)',
      'label': 'Bernilai Tinggi',
      'deskripsi':
          'Saring remah atau kotoran, dinginkan, lalu tuang ke jeriken atau botol plastik tertutup. Jangan membuangnya ke saluran air.',
    },
    {
      'kategori': 'Pilah Anorganik',
      'judul': 'B3 Rumah Tangga',
      'label': 'Wadah Khusus',
      'deskripsi':
          'Kumpulkan terpisah di wadah khusus untuk diserahkan ke drop-point B3. Jangan mencampurnya dengan sampah umum.',
    },
    {
      'kategori': 'Pembuatan Kompos',
      'judul': 'Metode Kompos Rumahan',
      'label': 'Panduan',
      'deskripsi':
          'Pilih metode yang sesuai dengan kondisi rumah, seperti Takakura, ember tumpuk, atau lubang biopori.',
    },
    {
      'kategori': 'Pembuatan Kompos',
      'judul': 'Keseimbangan Bahan Kompos (1:2)',
      'label': 'Penting',
      'deskripsi':
          'Seimbangkan bahan hijau yang cenderung basah dengan bahan cokelat yang kering. Hindari daging, tulang besar, dan makanan bersantan pekat.',
    },
    {
      'kategori': 'Pembuatan Kompos',
      'judul': 'Langkah Praktis Membuat Kompos',
      'label': 'Langkah-langkah',
      'deskripsi':
          'Siapkan wadah berventilasi, buat lapisan dasar, masukkan sampah dapur yang dicacah, lalu aduk dan jaga kelembapan secara berkala.',
    },
  ];

  List<Map<String, String>> get materiTampil {
    if (selectedFilter == 'Semua Materi') return materi;
    return materi.where((m) => m['kategori'] == selectedFilter).toList();
  }

  Future<void> _formMateri({int? index}) async {
    final isEdit = index != null;
    final data = isEdit ? materi[index] : <String, String>{};
    final judulController =
        TextEditingController(text: data['judul'] ?? '');
    final deskripsiController =
        TextEditingController(text: data['deskripsi'] ?? '');
    final labelController = TextEditingController(text: data['label'] ?? '');
    String kategori = data['kategori'] ?? 'Pilah Anorganik';
    final formKey = GlobalKey<FormState>();

    final hasil = await showDialog<Map<String, String>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: cardColor,
          title: Text(isEdit ? 'Edit Materi Edukasi' : 'Tambah Materi Edukasi',
              style: const TextStyle(fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kategori',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: kategori,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'Pilah Anorganik',
                            child: Text('Pilah Anorganik')),
                        DropdownMenuItem(
                            value: 'Pembuatan Kompos',
                            child: Text('Pembuatan Kompos')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => kategori = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: judulController,
                      decoration: const InputDecoration(
                        labelText: 'Judul materi',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Judul materi wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: labelController,
                      decoration: const InputDecoration(
                        labelText: 'Label (contoh: Panduan)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: deskripsiController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi / isi materi',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Deskripsi materi wajib diisi'
                              : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: green),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(dialogContext, {
                  'kategori': kategori,
                  'judul': judulController.text.trim(),
                  'label': labelController.text.trim().isEmpty
                      ? 'Materi'
                      : labelController.text.trim(),
                  'deskripsi': deskripsiController.text.trim(),
                });
              },
              child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Materi'),
            ),
          ],
        ),
      ),
    );

    judulController.dispose();
    deskripsiController.dispose();
    labelController.dispose();

    if (hasil == null || !mounted) return;
    setState(() {
      if (isEdit) {
        materi[index] = hasil;
      } else {
        materi.insert(0, hasil);
        selectedFilter = 'Semua Materi';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEdit
            ? 'Materi edukasi berhasil diperbarui.'
            : 'Materi edukasi berhasil ditambahkan.'),
      ),
    );
  }

  Future<void> _hapusMateri(int index) async {
    final judul = materi[index]['judul'] ?? 'materi ini';
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus materi?'),
        content: Text('Kamu yakin ingin menghapus "$judul"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;
    setState(() => materi.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Materi edukasi berhasil dihapus.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = [
      'Semua Materi',
      'Pilah Anorganik',
      'Pembuatan Kompos',
    ];

    return Scaffold(
      backgroundColor: pageColor,
      appBar: AppBar(
        backgroundColor: pageColor,
        foregroundColor: const Color.fromARGB(255, 3, 3, 3),
        elevation: 0,
        title: const Text(
          'Kelola Edukasi',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF19B993), Color(0xFF08765F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.menu_book_rounded,
                              color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('MATERI WARGA HIJAU',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: .6,
                                  )),
                              SizedBox(height: 4),
                              Text('Edukasi & Panduan Lingkungan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  )),
                              SizedBox(height: 4),
                              Text(
                                'Atur materi pemilahan sampah dan pembuatan kompos.',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _menuKelola(
                          icon: Icons.menu_book_rounded,
                          label: 'Kelola Edukasi',
                          selected: true,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _menuKelola(
                          icon: Icons.recycling_rounded,
                          label: 'Katalog & Kategori Sampah',
                          selected: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const KatalogPengurusScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          icon: Icons.library_books_outlined,
                          label: 'Total Materi',
                          value: '${materi.length}',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _summaryCard(
                          icon: Icons.recycling_outlined,
                          label: 'Kategori',
                          value: '2',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Daftar Materi',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => _formMateri(),
                        icon: const Icon(Icons.add, size: 19),
                        label: const Text('Tambah'),
                        style: FilledButton.styleFrom(
                          backgroundColor: green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filters.map((filter) {
                        final selected = selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(filter),
                            selected: selected,
                            showCheckmark: false,
                            onSelected: (_) =>
                                setState(() => selectedFilter = filter),
                            selectedColor: green,
                            backgroundColor: const Color(0xFFE6E4DE),
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                            side: BorderSide.none,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (materiTampil.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.menu_book_outlined,
                              size: 42, color: green),
                          SizedBox(height: 8),
                          Text('Belum ada materi pada kategori ini.'),
                        ],
                      ),
                    )
                  else
                    ...materiTampil.map((item) {
                      final index = materi.indexOf(item);
                      final isKompos =
                          item['kategori'] == 'Pembuatan Kompos';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 11),
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isKompos
                                        ? const Color(0xFFDDF1C9)
                                        : const Color(0xFFD8F3E9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    isKompos
                                        ? Icons.eco_outlined
                                        : Icons.recycling_outlined,
                                    color: green,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['kategori'] ?? '',
                                        style: const TextStyle(
                                          color: green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['judul'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  tooltip: 'Aksi materi',
                                  onSelected: (aksi) {
                                    if (aksi == 'edit') {
                                      _formMateri(index: index);
                                    } else if (aksi == 'hapus') {
                                      _hapusMateri(index);
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_outlined, size: 19),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'hapus',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_outline,
                                              color: Colors.red, size: 19),
                                          SizedBox(width: 8),
                                          Text('Hapus',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item['deskripsi'] ?? '',
                              style: const TextStyle(
                                  fontSize: 12, height: 1.35),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6E4DE),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item['label'] ?? 'Materi',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                TextButton.icon(
                                  onPressed: () => _formMateri(index: index),
                                  icon: const Icon(Icons.edit_outlined,
                                      size: 16),
                                  label: const Text('Edit materi'),
                                  style: TextButton.styleFrom(
                                      foregroundColor: green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuKelola({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? green : cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 82),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? green : const Color(0xFFD8DED8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : green,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : green,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
              color: Color(0x16000000), blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: green, size: 27),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 10, color: Colors.black54)),
                const SizedBox(height: 3),
                Text(value,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
