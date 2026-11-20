import 'package:flutter/material.dart';

class KelolaEdukasiPengurusScreen extends StatefulWidget {
  const KelolaEdukasiPengurusScreen({super.key});

  @override
  State<KelolaEdukasiPengurusScreen> createState() =>
      _KelolaEdukasiPengurusScreenState();
}

class _KelolaEdukasiPengurusScreenState
    extends State<KelolaEdukasiPengurusScreen> {
  static const Color _bg = Color(0xFFF0F0E8);
  static const Color _green = Color(0xFF1B8A6B);
  static const Color _darkGreen = Color(0xFF0F6E56);
  static const Color _border = Color(0xFFE1E5DD);

  String _filter = 'Semua';

  final List<Map<String, dynamic>> _edukasi = [
    {
      'judul': 'Pilah Sampah dari Rumah',
      'kategori': 'Anorganik',
      'deskripsi': 'Kenali cara memisahkan sampah organik dan anorganik sebelum disetorkan.',
      'icon': Icons.delete_sweep_rounded,
    },
    {
      'judul': 'Manfaat Bank Sampah',
      'kategori': 'Anorganik',
      'deskripsi':
          'Pelajari manfaat menabung sampah dan menjaga lingkungan sekitar.',
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'judul': 'Daur Ulang Plastik',
      'kategori': 'Anorganik',
      'deskripsi':
          'Ketahui jenis plastik yang dapat dikumpulkan dan didaur ulang.',
      'icon': Icons.recycling_rounded,
    },
    {
      'judul': 'Membuat Kompos di Rumah',
      'kategori': 'Organik',
      'deskripsi':
          'Pelajari cara mengolah sisa makanan dan daun menjadi pupuk kompos.',
      'icon': Icons.eco_rounded,
    },
  ];

  List<Map<String, dynamic>> get _filteredEdukasi {
    if (_filter == 'Semua') return _edukasi;

    return _edukasi.where((item) => item['kategori'] == _filter).toList();
  }

  int get _jumlahKategori =>
      _edukasi.map((item) => item['kategori']).toSet().length;

  @override
  Widget build(BuildContext context) {
    // Scaffold, header, tab katalog, dan bottom nav
    // tetap dikelola oleh KelolaGabunganScreen.
    return Material(
      color: _bg,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _banner(),
          const SizedBox(height: 16),
          _summary(),
          const SizedBox(height: 22),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Daftar Edukasi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: _tambahEdukasi,
                style: FilledButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah'),
              ),
            ],
          ),

          const SizedBox(height: 12),
          _filterButtons(),
          const SizedBox(height: 14),

          if (_filteredEdukasi.isEmpty)
            _emptyState()
          else
            ..._filteredEdukasi.map(_edukasiCard),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==================== BANNER ====================

  Widget _banner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edukasi Bank Sampah',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Kelola informasi dan materi edukasi untuk warga.',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Icon(Icons.menu_book_rounded, size: 46, color: Colors.white),
        ],
      ),
    );
  }

  // ==================== RINGKASAN ====================

  Widget _summary() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            icon: Icons.menu_book_rounded,
            title: 'Total Edukasi',
            value: '${_edukasi.length}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            icon: Icons.category_rounded,
            title: 'Kategori',
            value: '$_jumlahKategori',
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _green, size: 25),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: _darkGreen,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ==================== FILTER KATEGORI ====================

  Widget _filterButtons() {
    const filters = ['Semua', 'Organik', 'Anorganik'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((filter) {
        final selected = _filter == filter;

        return ChoiceChip(
          label: Text(filter),
          selected: selected,
          selectedColor: _green,
          backgroundColor: Colors.white,
          side: BorderSide(color: selected ? _green : _border),
          labelStyle: TextStyle(
            color: selected ? Colors.white : _darkGreen,
            fontWeight: FontWeight.w600,
          ),
          onSelected: (_) {
            setState(() => _filter = filter);
          },
        );
      }).toList(),
    );
  }

  // ==================== KARTU EDUKASI ====================

  Widget _edukasiCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item['icon'] as IconData, color: _green),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['judul'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _darkGreen,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item['deskripsi'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EFE5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item['kategori'] as String,
                    style: const TextStyle(
                      color: _green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            tooltip: 'Kelola edukasi',
            icon: const Icon(Icons.more_vert_rounded, color: _green),
            onSelected: (value) {
              switch (value) {
                case 'detail':
                  _detailEdukasi(item);
                  break;
                case 'edit':
                  _editEdukasi(item);
                  break;
                case 'hapus':
                  _hapusEdukasi(item);
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'detail',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20),
                    SizedBox(width: 10),
                    Text('Detail'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 20),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'hapus',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _border),
      ),
      child: const Column(
        children: [
          Icon(Icons.menu_book_outlined, size: 44, color: _green),
          SizedBox(height: 12),
          Text(
            'Belum ada edukasi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _darkGreen,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Belum ada materi untuk kategori ini. '
            'Coba kategori lain atau tambahkan materi baru.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ==================== TAMBAH EDUKASI ====================

  Future<void> _tambahEdukasi() async {
    final hasil = await _formEdukasi();

    if (!mounted || hasil == null) return;

    setState(() {
      _edukasi.add(hasil);
    });

    _pesan('Materi edukasi berhasil ditambahkan.');
  }

  // ==================== EDIT EDUKASI ====================

  Future<void> _editEdukasi(Map<String, dynamic> item) async {
    final hasil = await _formEdukasi(item: item);

    if (!mounted || hasil == null) return;

    setState(() {
      item['judul'] = hasil['judul'];
      item['kategori'] = hasil['kategori'];
      item['deskripsi'] = hasil['deskripsi'];
    });

    _pesan('Materi edukasi berhasil diperbarui.');
  }

  // ==================== FORM TAMBAH / EDIT ====================

  Future<Map<String, dynamic>?> _formEdukasi({
    Map<String, dynamic>? item,
  }) async {
    final formKey = GlobalKey<FormState>();

    final judulController = TextEditingController(
      text: item?['judul'] as String? ?? '',
    );

    final deskripsiController = TextEditingController(
      text: item?['deskripsi'] as String? ?? '',
    );

    String kategori = item?['kategori'] as String? ?? 'Organik';

    final hasil = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: _bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                item == null ? 'Tambah Edukasi' : 'Edit Edukasi',
                style: const TextStyle(
                  color: _darkGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Judul Materi',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: judulController,
                        maxLength: 100,
                        decoration: _inputDecoration(
                          'Masukkan judul materi',
                          Icons.title_rounded,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Judul materi wajib diisi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Kategori',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: kategori,
                        decoration: _inputDecoration(
                          'Pilih kategori',
                          Icons.category_outlined,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Organik',
                            child: Text('Organik'),
                          ),
                          DropdownMenuItem(
                            value: 'Anorganik',
                            child: Text('Anorganik'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => kategori = value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Deskripsi Materi',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: deskripsiController,
                        maxLines: 4,
                        maxLength: 500,
                        decoration: _inputDecoration(
                          'Jelaskan isi materi edukasi',
                          Icons.description_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Deskripsi materi wajib diisi.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;

                    Navigator.pop(dialogContext, <String, dynamic>{
                      'judul': judulController.text.trim(),
                      'kategori': kategori,
                      'deskripsi': deskripsiController.text.trim(),
                      'icon':
                          item?['icon'] as IconData? ??
                          (kategori == 'Organik'
                              ? Icons.eco_rounded
                              : Icons.recycling_rounded),
                    });
                  },
                  child: Text(item == null ? 'Simpan' : 'Perbarui'),
                ),
              ],
            );
          },
        );
      },
    );

    judulController.dispose();
    deskripsiController.dispose();

    return hasil;
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: _green, size: 20),
      filled: true,
      fillColor: Colors.white,
      counterStyle: const TextStyle(fontSize: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _green, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  // ==================== DETAIL EDUKASI ====================

  void _detailEdukasi(Map<String, dynamic> item) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            const Icon(Icons.menu_book_rounded, color: _green),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item['judul'] as String,
                style: const TextStyle(
                  fontSize: 18,
                  color: _darkGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EFE5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item['kategori'] as String,
                  style: const TextStyle(
                    color: _green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Deskripsi Materi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['deskripsi'] as String,
                style: const TextStyle(height: 1.6, color: Colors.black87),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup', style: TextStyle(color: _green)),
          ),
        ],
      ),
    );
  }

  // ==================== HAPUS EDUKASI ====================

  Future<void> _hapusEdukasi(Map<String, dynamic> item) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Hapus Materi?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus '
          '"${item['judul']}" dari daftar edukasi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal', style: TextStyle(color: Colors.black54)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || konfirmasi != true) return;

    setState(() {
      _edukasi.remove(item);
    });

    _pesan('Materi edukasi berhasil dihapus.');
  }

  // ==================== NOTIFIKASI ====================

  void _pesan(String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(pesan),
          backgroundColor: _green,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
