import 'package:flutter/material.dart';

import '../../services/api_client.dart';
import 'beranda_warga_screen.dart';
import 'profil_warga.dart';

class DompetPage extends StatefulWidget {
  const DompetPage({super.key});

  @override
  State<DompetPage> createState() => _DompetPageState();
}

class _DompetPageState extends State<DompetPage> {
  static const Color darkGreen = Color(0xFF0F6E56);
  static const Color btnGreen = Color(0xFF0F765F);
  static const Color mint = Color(0xFF5BCBAA);
  static const Color lime = Color(0xFFB9EF55);
  static const Color orange = Color(0xFFF0A02A);
  static const Color background = Color(0xFFF0EFE7);
  static const Color cardWhite = Color(0xFFFFFCF8);
  static const Color grey = Color(0xFF6F6D66);

  // ====== DATA DARI BACKEND ======
  bool _memuat = true;
  int _saldo = 0;
  int _saldoTersedia = 0;
  double _totalBerat = 0;
  double _beratBulanIni = 0;
  String _nama = 'Warga';
  String _alamat = '-';

  List<_Setoran> _semuaSetoran = const [];
  List<_Pencairan> _semuaPencairan = const [];
  List<String> _daftarBulan = const [];

  String _bulanSetor = '';
  String _bulanCair = '';

  @override
  void initState() {
    super.initState();
    _muatDompet();
  }

  Future<void> _muatDompet() async {
    try {
      final hasil = await Future.wait([
        ApiClient.dompet(),
        ApiClient.me(),
        ApiClient.transaksi(),
      ]);
      if (!mounted) return;

      final dompet = hasil[0];
      final me = hasil[1];
      final transaksi = hasil[2];

      final setoran = <_Setoran>[];
      final pencairan = <_Pencairan>[];
      var saldo = 0;
      var saldoTersedia = 0;
      var nama = _nama;
      var alamat = _alamat;

      if (dompet.isSuccess && dompet.data != null) {
        final data = dompet.data!;
        saldo = (data['saldo'] as num?)?.toInt() ?? 0;
        saldoTersedia = (data['saldo_tersedia'] as num?)?.toInt() ?? 0;

        final riwayat = data['riwayat'];
        if (riwayat is List) {
          for (final item in riwayat.whereType<Map>()) {
            final json = Map<String, dynamic>.from(item);
            if (json['jenis']?.toString() == 'masuk') {
              setoran.add(_Setoran.fromJson(json));
            } else {
              pencairan.add(_Pencairan.fromJson(json));
            }
          }
        }
      }

      if (me.isSuccess && me.data != null) {
        final user = me.data!;
        nama = user['nama']?.toString() ?? nama;
        alamat = user['alamat']?.toString() ?? alamat;
        if (alamat.trim().isEmpty) alamat = '-';
      }

      var totalBerat = 0.0;
      var beratBulanIni = 0.0;
      final sekarang = DateTime.now();
      if (transaksi.isSuccess) {
        for (final item in transaksi.dataList) {
          final berat =
              (item['total_berat_kg'] as num?)?.toDouble() ??
              (item['total_berat'] as num?)?.toDouble() ??
              0;
          totalBerat += berat;

          final tanggal = DateTime.tryParse(
            item['tanggal']?.toString() ??
                item['tanggal_transaksi']?.toString() ??
                '',
          );
          if (tanggal != null &&
              tanggal.year == sekarang.year &&
              tanggal.month == sekarang.month) {
            beratBulanIni += berat;
          }
        }
      }

      final bulan =
          <String>{
              ...setoran.map((e) => e.bulan),
              ...pencairan.map((e) => e.bulan),
              _bulanSekarang(),
            }.where((e) => e.isNotEmpty).toList()
            ..sort((a, b) => _bulanKeIndex(b).compareTo(_bulanKeIndex(a)));

      setState(() {
        _saldo = saldo;
        _saldoTersedia = saldoTersedia;
        _totalBerat = totalBerat;
        _beratBulanIni = beratBulanIni;
        _nama = nama;
        _alamat = alamat;
        _semuaSetoran = setoran;
        _semuaPencairan = pencairan;
        _daftarBulan = bulan;
        _bulanSetor = _bulanSetor.isEmpty ? bulan.first : _bulanSetor;
        _bulanCair = _bulanCair.isEmpty ? bulan.first : _bulanCair;
      });
    } catch (_) {
      // Biarkan halaman tetap tampil bila server belum menyala.
    } finally {
      if (mounted) setState(() => _memuat = false);
    }
  }

  static const List<String> _namaBulan = [
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

  static String _bulanSekarang() {
    final now = DateTime.now();
    return '${_namaBulan[now.month - 1]} ${now.year}';
  }

  static int _bulanKeIndex(String bulan) {
    final parts = bulan.split(' ');
    if (parts.length != 2) return 0;
    final index = _namaBulan.indexOf(parts[0]);
    final tahun = int.tryParse(parts[1]) ?? 0;
    return tahun * 12 + (index < 0 ? 0 : index);
  }

  List<_Setoran> get _setoran =>
      _semuaSetoran.where((e) => e.bulan == _bulanSetor).toList();
  List<_Pencairan> get _pencairan =>
      _semuaPencairan.where((e) => e.bulan == _bulanCair).toList();
  int get _totalSetoran => _setoran.fold(0, (s, e) => s + e.nilai);

  List<BoxShadow> _shadow([double alpha = 0.12]) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: alpha),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  String _angka(int nilai) {
    final s = nilai.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  void _pesan(String teks) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(teks)));
  }

  Widget _tombolCairkan() => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: _saldoTersedia <= 0 ? null : _ajukanPencairan,
      icon: const Icon(Icons.payments_outlined, color: darkGreen, size: 20),
      label: const Text(
        'Ajukan Pencairan',
        style: TextStyle(
          color: darkGreen,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: cardWhite,
        disabledForegroundColor: Colors.black38,
        side: BorderSide(
          color: _saldoTersedia <= 0 ? Colors.black26 : darkGreen,
          width: 1.2,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );

  Future<void> _ajukanPencairan() async {
    final controller = TextEditingController();

    final nominal = await showDialog<num>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ajukan Pencairan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo tersedia: Rp ${_angka(_saldoTersedia)}',
              style: const TextStyle(fontSize: 12.5),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nominal',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = num.tryParse(
                controller.text.replaceAll('.', '').replaceAll(',', '').trim(),
              );
              Navigator.pop(dialogContext, value);
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );

    if (nominal == null) return;

    if (nominal < 1000) {
      _pesan('Nominal pencairan minimal Rp 1.000.');
      return;
    }

    if (nominal > _saldoTersedia) {
      _pesan('Nominal melebihi saldo tersedia.');
      return;
    }

    try {
      final res = await ApiClient.ajukanPencairan(nominal: nominal);
      if (!mounted) return;

      _pesan(res.isSuccess ? res.message : res.firstError);

      if (res.isSuccess) await _muatDompet();
    } catch (_) {
      _pesan('Gagal mengirim pengajuan. Cek koneksi server.');
    }
  }

  Future<void> _pilihBulan({
    required String aktif,
    required ValueChanged<String> onPilih,
  }) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Pilih Bulan Rekap',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            for (final b in _daftarBulan)
              ListTile(
                leading: const Icon(
                  Icons.calendar_month_outlined,
                  color: darkGreen,
                ),
                title: Text(
                  b,
                  style: TextStyle(
                    fontWeight: b == aktif ? FontWeight.bold : FontWeight.w500,
                    color: b == aktif ? darkGreen : Colors.black87,
                  ),
                ),
                trailing: b == aktif
                    ? const Icon(Icons.check_circle, color: darkGreen)
                    : null,
                onTap: () => Navigator.pop(ctx, b),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (picked != null && mounted) onPilih(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _identitas(),
              if (_memuat) ...[
                const SizedBox(height: 10),
                const LinearProgressIndicator(minHeight: 2),
              ],
              const SizedBox(height: 14),
              _saldoCard(),
              const SizedBox(height: 12),
              _tombolCairkan(),
              const SizedBox(height: 22),
              const Text(
                'Riwayat Setor Sampah',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              _pilihBulanCard(
                _bulanSetor,
                () => _pilihBulan(
                  aktif: _bulanSetor,
                  onPilih: (v) => setState(() => _bulanSetor = v),
                ),
              ),
              const SizedBox(height: 12),
              _totalBar(),
              const SizedBox(height: 10),
              if (_setoran.isEmpty)
                _kosong('Belum ada setoran di bulan ini.')
              else
                for (final s in _setoran) ...[
                  _itemSetoran(s),
                  const SizedBox(height: 10),
                ],
              const SizedBox(height: 14),
              _tombolPdf(),
              const SizedBox(height: 26),
              const Text(
                'Riwayat Pencairan Dana',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              _pilihBulanCard(
                _bulanCair,
                () => _pilihBulan(
                  aktif: _bulanCair,
                  onPilih: (v) => setState(() => _bulanCair = v),
                ),
              ),
              const SizedBox(height: 12),
              if (_pencairan.isEmpty)
                _kosong('Belum ada pencairan dana di bulan ini.')
              else
                for (final p in _pencairan) ...[
                  _itemPencairan(p),
                  const SizedBox(height: 10),
                ],
              const SizedBox(height: 18),
              _jadwalCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  Widget _identitas() {
    final inisial = _nama
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .take(2)
        .map((e) => e[0].toUpperCase())
        .join();

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: mint, shape: BoxShape.circle),
          child: Text(
            inisial.isEmpty ? '?' : inisial,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _nama,
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _alamat,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: lime,
            borderRadius: BorderRadius.circular(10),
            boxShadow: _shadow(0.10),
          ),
          child: const Text(
            'Warga Aktif',
            style: TextStyle(
              color: darkGreen,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 6),
        IconButton(
          tooltip: 'Profil Warga',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilWargaScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.account_circle_outlined,
            size: 32,
            color: darkGreen,
          ),
        ),
      ],
    );
  }

  // ====== KARTU TOTAL UANG ======
  Widget _saldoCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F6E56), Color(0xFF1ED3A3)],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: _shadow(0.18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'TOTAL UANG TERKUMPUL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: mint,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _shadow(0.12),
              ),
              child: const Text(
                'SALDO',
                style: TextStyle(
                  color: Color(0xFF0D5A47),
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Rp ${_angka(_saldo)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Bisa diajukan: Rp ${_angka(_saldoTersedia)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: orange,
            borderRadius: BorderRadius.circular(14),
            boxShadow: _shadow(0.16),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.recycling, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BULAN INI',
                    style: TextStyle(
                      color: Color(0xFF7A4A00),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${_beratBulanIni.toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '${_totalBerat.toStringAsFixed(1)} kg total',
                style: const TextStyle(
                  color: Color(0xFF7A4A00),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ====== PILIH BULAN ======
  Widget _pilihBulanCard(String bulan, VoidCallback onTap) => Material(
    color: cardWhite,
    borderRadius: BorderRadius.circular(14),
    elevation: 4,
    shadowColor: Colors.black38,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: mint.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: darkGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Bulan Rekap',
                    style: TextStyle(
                      fontSize: 11,
                      color: grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bulan,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              'Ubah',
              style: TextStyle(
                color: darkGreen,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.keyboard_arrow_down_rounded, color: darkGreen),
          ],
        ),
      ),
    ),
  );

  Widget _totalBar() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: mint.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      'Total : ${_angka(_totalSetoran)}',
      style: const TextStyle(
        color: Color(0xFF0D5A47),
        fontSize: 11.5,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  // ====== ITEM SETORAN ======
  Widget _itemSetoran(_Setoran s) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    decoration: BoxDecoration(
      color: cardWhite,
      borderRadius: BorderRadius.circular(14),
      boxShadow: _shadow(0.10),
    ),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: mint.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(s.ikon, color: Colors.black87, size: 21),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                s.berat,
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: mint,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _shadow(0.12),
          ),
          child: Text(
            'Rp ${_angka(s.nilai)}',
            style: const TextStyle(
              color: Color(0xFF0D5A47),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _tombolPdf() => SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      onPressed: () => _pesan(
        'Fitur Buat PDF rekap setoran $_bulanSetor akan segera tersedia.',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: btnGreen,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Buat PDF',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    ),
  );

  // ====== ITEM PENCAIRAN ======
  Widget _itemPencairan(_Pencairan p) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    decoration: BoxDecoration(
      color: cardWhite,
      borderRadius: BorderRadius.circular(14),
      boxShadow: _shadow(0.10),
    ),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: mint.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: darkGreen,
            size: 22,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.nominal,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                p.tanggal,
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF6FBFA5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _shadow(0.12),
          ),
          child: Text(
            p.status,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );

  Widget _kosong(String teks) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 22),
    decoration: BoxDecoration(
      color: cardWhite,
      borderRadius: BorderRadius.circular(14),
      boxShadow: _shadow(0.08),
    ),
    child: Column(
      children: [
        const Icon(Icons.inbox_outlined, color: darkGreen, size: 28),
        const SizedBox(height: 6),
        Text(teks, style: const TextStyle(fontSize: 11.5, color: grey)),
      ],
    ),
  );

  // ====== JADWAL TIMBANG ======
  Widget _jadwalCard() => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: btnGreen,
      borderRadius: BorderRadius.circular(14),
      boxShadow: _shadow(0.18),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.history, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'Jadwal Timbang Posko\nRT 04',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: mint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Segera',
                      style: TextStyle(
                        color: Color(0xFF0D5A47),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Sabtu, 15 Mar 2026 (09:00 - 09:30 WIB)',
                style: TextStyle(color: Colors.white70, fontSize: 10.5),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  // ====== BOTTOM NAV ======
  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: darkGreen,
      unselectedItemColor: Colors.black45,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 9.5,
      unselectedFontSize: 9.5,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BerandaWargaScreen()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilWargaScreen()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Dompet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Warga',
        ),
      ],
    );
  }
}

class _Setoran {
  final String judul;
  final String berat;
  final int nilai;
  final IconData ikon;
  final String bulan;

  const _Setoran(
    this.judul,
    this.berat,
    this.nilai,
    this.ikon, {
    this.bulan = '',
  });

  factory _Setoran.fromJson(Map<String, dynamic> json) {
    final tanggal = DateTime.tryParse(json['tanggal']?.toString() ?? '');
    final keterangan = json['keterangan']?.toString() ?? '';
    return _Setoran(
      json['judul']?.toString() ?? 'Setoran',
      '${_formatTanggal(tanggal)}${keterangan.isEmpty ? '' : ' • $keterangan'}',
      (json['nominal'] as num?)?.toInt() ?? 0,
      Icons.recycling,
      bulan: _bulanLabel(tanggal),
    );
  }
}

class _Pencairan {
  final String nominal;
  final String tanggal;
  final String status;
  final String bulan;

  const _Pencairan(
    this.nominal,
    this.tanggal, {
    this.status = 'Berhasil',
    this.bulan = '',
  });

  factory _Pencairan.fromJson(Map<String, dynamic> json) {
    final tanggal = DateTime.tryParse(json['tanggal']?.toString() ?? '');
    final status = json['status']?.toString() ?? '';
    final statusLabel = status.isEmpty
        ? 'Diajukan'
        : status[0].toUpperCase() + status.substring(1);
    return _Pencairan(
      _formatNominal((json['nominal'] as num?)?.toInt() ?? 0),
      _formatTanggal(tanggal),
      status: statusLabel,
      bulan: _bulanLabel(tanggal),
    );
  }
}

const List<String> _namaBulanPanjang = [
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

String _formatNominal(int nilai) {
  final s = nilai.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

String _formatTanggal(DateTime? tanggal) {
  if (tanggal == null) return '-';
  return '${tanggal.day} ${_namaBulanPanjang[tanggal.month - 1]} ${tanggal.year}';
}

String _bulanLabel(DateTime? tanggal) {
  if (tanggal == null) return '';
  return '${_namaBulanPanjang[tanggal.month - 1]} ${tanggal.year}';
}
