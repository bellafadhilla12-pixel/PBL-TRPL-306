import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'katalog_pengurus.dart';

class _Kategori {
  final String kode;
  final String nama;
  final int harga; // per kg (untuk padat) atau per liter (untuk cair)
  final Color warna;
  const _Kategori(this.kode, this.nama, this.harga, this.warna);

  factory _Kategori.fromSampah(SampahItem s) =>
      _Kategori(s.kode, s.nama, _parseHarga(s.harga), _warnaItem(s.kategori));

  // "Rp 4.500/kg" -> 4500
  static int _parseHarga(String h) {
    final bagian = h.split('/').first;
    return int.tryParse(bagian.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  // Dropdown membandingkan objek, jadi samakan berdasarkan kode.
  @override
  bool operator ==(Object other) => other is _Kategori && other.kode == kode;

  @override
  int get hashCode => kode.hashCode;
}

Color _warnaItem(String k) {
  switch (k.toUpperCase()) {
    case 'PLASTIK':
      return const Color(0xFF5BCBAA);
    case 'LOGAM':
      return const Color(0xFFFFCB77);
    case 'KERTAS/KARDUS':
      return const Color(0xFFC5E1A5);
    case 'LAINNYA':
      return const Color(0xFFFFB74D);
    case 'LIMBAH':
      return const Color(0xFFEF9A9A);
    default:
      return const Color(0xFFE0E0E0);
  }
}

// Satuan input. `keDasar` = pengali untuk dikonversi ke satuan dasar
// (gram & kg -> kg, ml & liter -> liter).
enum _Satuan {
  gram('Gram', 'g', 0.001, false),
  kg('Kilogram', 'kg', 1, false),
  ml('Mililiter', 'ml', 0.001, true),
  liter('Liter', 'L', 1, true);

  final String nama;
  final String simbol;
  final double keDasar;
  final bool cair;
  const _Satuan(this.nama, this.simbol, this.keDasar, this.cair);

  String get simbolDasar => cair ? 'L' : 'kg';
}

class _ItemKeranjang {
  final _Kategori kategori;
  final bool cair; // true = dihitung dalam liter, false = dalam kg
  double jumlah; // dalam satuan dasar (kg atau liter)
  _ItemKeranjang(this.kategori, this.jumlah, {required this.cair});

  String get simbol => cair ? 'L' : 'kg';
}

class InputTimbangScreen extends StatefulWidget {
  final String nama;
  final String alamat;
  final String kode;
  final int saldoAwal;

  const InputTimbangScreen({
    super.key,
    required this.nama,
    required this.alamat,
    required this.kode,
    this.saldoAwal = 148500,
  });

  @override
  State<InputTimbangScreen> createState() => _InputTimbangScreenState();
}

class _InputTimbangScreenState extends State<InputTimbangScreen> {
  static const bg = Color(0xFFF0EFE7);
  static const green = Color(0xFF0F765F);
  static const mint = Color(0xFF5BCBAA);
  static const lime = Color(0xFFB9EF55);
  static const grey = Color(0xFF777777);
  static const brown = Color(0xFF8B5A4A);

  // Selalu mengikuti katalog pengurus (daftarSampah).
  List<_Kategori> get daftarKategori =>
      daftarSampah.map(_Kategori.fromSampah).toList();

  _Kategori? kategoriDipilih;
  _Satuan satuan = _Satuan.kg;
  final TextEditingController _beratC = TextEditingController();
  final List<_ItemKeranjang> keranjang = [];

  @override
  void dispose() {
    _beratC.dispose();
    super.dispose();
  }

  // Angka yang diketik pengguna (boleh pakai koma atau titik).
  double get _inputNilai =>
      double.tryParse(_beratC.text.trim().replaceAll(',', '.')) ?? 0;

  double get totalKg =>
      keranjang.where((e) => !e.cair).fold(0.0, (s, e) => s + e.jumlah);

  double get totalLiter =>
      keranjang.where((e) => e.cair).fold(0.0, (s, e) => s + e.jumlah);

  int get totalNilai => keranjang
      .fold<double>(0, (s, e) => s + e.jumlah * e.kategori.harga)
      .round();

  String _rp(int v) => v.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );

  String _num(double v) {
    final r = double.parse(v.toStringAsFixed(3));
    return r == r.roundToDouble() ? r.toInt().toString() : r.toString();
  }

  String get _labelBeratTotal {
    if (totalLiter > 0 && totalKg > 0) {
      return '${_num(totalKg)} kg • ${_num(totalLiter)} L';
    }
    if (totalLiter > 0) return '${_num(totalLiter)} L';
    return '${_num(totalKg)} kg';
  }

  // Tombol cepat menyesuaikan satuan yang dipilih.
  List<double> get _cepat =>
      satuan.keDasar < 1 ? [100, 500, 1000] : [0.5, 1, 5];

  void _msg(String t) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  void _tambahCepat(double v) {
    setState(() {
      _beratC.text = _num(_inputNilai + v);
      _beratC.selection = TextSelection.collapsed(offset: _beratC.text.length);
    });
  }

  void _nolkan() {
    setState(() => _beratC.clear());
  }

  void _masukKeranjang() {
    if (kategoriDipilih == null) {
      _msg('Pilih kategori sampah terlebih dahulu.');
      return;
    }
    final nilai = _inputNilai;
    if (nilai <= 0) {
      _msg('Isi berat atau volume lebih dari 0.');
      return;
    }

    // Konversi ke satuan dasar: g -> kg, ml -> liter.
    final dasar = double.parse((nilai * satuan.keDasar).toStringAsFixed(3));
    if (dasar <= 0) {
      _msg('Jumlah terlalu kecil untuk dimasukkan.');
      return;
    }

    setState(() {
      final idx = keranjang.indexWhere(
        (e) =>
            e.kategori.kode == kategoriDipilih!.kode && e.cair == satuan.cair,
      );
      if (idx >= 0) {
        keranjang[idx].jumlah += dasar;
      } else {
        keranjang.add(
          _ItemKeranjang(kategoriDipilih!, dasar, cair: satuan.cair),
        );
      }
      _beratC.clear();
    });
    FocusScope.of(context).unfocus();
  }

  void _ubahItem(_ItemKeranjang item, double d) {
    setState(() {
      item.jumlah = double.parse((item.jumlah + d).toStringAsFixed(3));
      if (item.jumlah <= 0) keranjang.remove(item);
    });
  }

  void _simpan() {
    if (keranjang.isEmpty) {
      _msg('Keranjang masih kosong.');
      return;
    }
    _msg('Setoran ${widget.nama} Rp ${_rp(totalNilai)} berhasil disimpan.');
    Navigator.pop(context, true); // true = selesai
  }

  BoxDecoration _cardDeco({Color color = Colors.white, double r = 16}) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 10),
              _wargaCard(),
              const SizedBox(height: 14),
              _kategoriSection(),
              const SizedBox(height: 10),
              _timbanganCard(),
              const SizedBox(height: 12),
              _keranjangCard(),
              const SizedBox(height: 16),
              _totalCard(),
              const SizedBox(height: 14),
              const Text(
                'Konfirmasi dan Simpan Setoran',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: lime,
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );

  Widget _topBar() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: () => Navigator.pop(context),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_ios_new, color: green, size: 20),
            SizedBox(width: 8),
            Text(
              'Kembali',
              style: TextStyle(
                color: green,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _pill(
            Row(
              children: [
                const Icon(Icons.scale_outlined, size: 16, color: green),
                const SizedBox(width: 6),
                Text(
                  'Sesi #${widget.kode}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          _pill(
            const Row(
              children: [
                Icon(Icons.circle, size: 14, color: green),
                SizedBox(width: 6),
                Text(
                  'Timbangan Terkalibrasi',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );

  Widget _wargaCard() {
    final inisial = widget.nama.trim().isEmpty
        ? '?'
        : widget.nama
              .trim()
              .split(' ')
              .where((e) => e.isNotEmpty)
              .take(2)
              .map((e) => e[0].toUpperCase())
              .join();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDeco(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: mint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  inisial,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nama,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      widget.alamat,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEBE4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined, size: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Total Uang Terkumpul',
                    style: TextStyle(fontSize: 10, color: grey),
                  ),
                ),
                Text(
                  'Rp ${_rp(widget.saldoAwal)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: green,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kategoriSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'KATEGORI SAMPAH',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
          ),
          Text(
            'Tarif Berlaku 2025',
            style: TextStyle(
              fontSize: 10,
              color: green,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: _cardDeco(r: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<_Kategori>(
            value: kategoriDipilih,
            isExpanded: true,
            hint: const Text(
              'Pilih Kategori Sampah',
              style: TextStyle(fontSize: 11, color: grey),
            ),
            items: daftarKategori
                .map(
                  (k) => DropdownMenuItem(
                    value: k,
                    child: Text(
                      '${k.kode} • ${k.nama} (Rp ${_rp(k.harga)}/kg)',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => kategoriDipilih = v),
          ),
        ),
      ),
    ],
  );

  Widget _timbanganCard() => Container(
    padding: const EdgeInsets.all(12),
    decoration: _cardDeco(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.scale_outlined, size: 16),
            const SizedBox(width: 6),
            const Expanded(
              child: Text('Timbangan Digital', style: TextStyle(fontSize: 12)),
            ),
            InkWell(
              onTap: _nolkan,
              child: const Row(
                children: [
                  Icon(Icons.refresh, size: 13, color: Colors.red),
                  SizedBox(width: 3),
                  Text(
                    'Nol-kan (Tare)',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.red,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE2E0DA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.only(left: 8, right: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _beratC,
                          onChanged: (_) => setState(() {}),
                          textAlign: TextAlign.center,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.,]'),
                            ),
                          ],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                          decoration: const InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.black26,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      _satuanDropdown(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: 'Masuk keranjang',
                child: InkWell(
                  onTap: _masukKeranjang,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('Cepat:', style: TextStyle(fontSize: 10)),
            const SizedBox(width: 10),
            for (final v in _cepat)
              Expanded(
                child: InkWell(
                  onTap: () => _tambahCepat(v),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 24,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E0DA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+${_num(v)} ${satuan.simbol}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Ketik angkanya, pilih satuan, lalu tekan tombol keranjang untuk memasukkan.',
          style: TextStyle(fontSize: 9.5, color: grey),
        ),
      ],
    ),
  );

  Widget _satuanDropdown() => DropdownButtonHideUnderline(
    child: DropdownButton<_Satuan>(
      value: satuan,
      isDense: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: green),
      selectedItemBuilder: (_) => _Satuan.values
          .map(
            (s) => Center(
              child: Text(
                s.simbol,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
          .toList(),
      items: _Satuan.values
          .map(
            (s) => DropdownMenuItem(
              value: s,
              child: Text(
                '${s.nama} (${s.simbol})',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => satuan = v);
      },
    ),
  );

  Widget _keranjangCard() => Container(
    padding: const EdgeInsets.all(12),
    decoration: _cardDeco(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFFFCB77),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.inventory_2, size: 18, color: brown),
            ),
            const SizedBox(width: 8),
            const Text('Jenis Sampah', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 10),
        if (keranjang.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'Keranjang masih kosong',
                style: TextStyle(fontSize: 11, color: grey),
              ),
            ),
          ),
        for (final item in keranjang) ...[
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: item.kategori.warna,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.kategori.kode,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.kategori.nama,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rp ${_rp(item.kategori.harga)} /${item.simbol}',
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _stepper(item),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 18),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEBE4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.scale_outlined, size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Berat Total', style: TextStyle(fontSize: 10)),
              ),
              Text(_labelBeratTotal, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _stepper(_ItemKeranjang item) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: green,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _miniBtn(Icons.remove, () => _ubahItem(item, -0.5)),
        Container(
          width: 56,
          height: 22,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            '${_num(item.jumlah)} ${item.simbol}',
            style: const TextStyle(fontSize: 10),
          ),
        ),
        _miniBtn(Icons.add, () => _ubahItem(item, 0.5)),
      ],
    ),
  );

  Widget _miniBtn(IconData i, VoidCallback onTap) => InkWell(
    onTap: onTap,
    customBorder: const CircleBorder(),
    child: Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(i, size: 14, color: green),
    ),
  );

  Widget _totalCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: _cardDeco(color: const Color(0xFFFFF8F5)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.calculate_outlined, size: 18),
            SizedBox(width: 8),
            Text(
              'TOTAL NILAI KONVERSI',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const Text(
              'Rp',
              style: TextStyle(
                fontSize: 18,
                color: brown,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _rp(totalNilai),
              style: const TextStyle(
                fontSize: 34,
                color: brown,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, size: 14, color: brown),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Dihitung otomatis berdasarkan tarif resmi Bank Sampah Plamo Garden',
                style: TextStyle(fontSize: 11, color: brown),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
