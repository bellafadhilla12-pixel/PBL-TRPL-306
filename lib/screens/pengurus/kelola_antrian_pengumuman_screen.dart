import 'dart:async';

import 'package:flutter/material.dart';

import 'verifikasi_warga_screen.dart';
import 'profil_pengurus.dart';
import '../../services/announcement_store.dart';
import 'katalog_pengurus.dart';

class KelolaAntrianPengumumanScreen extends StatefulWidget {
  const KelolaAntrianPengumumanScreen({super.key});

  @override
  State<KelolaAntrianPengumumanScreen> createState() =>
      _KelolaAntrianPengumumanScreenState();
}

class _KelolaAntrianPengumumanScreenState
    extends State<KelolaAntrianPengumumanScreen> {
  static const bg = Color(0xFFF3F1E9);
  static const green = Color(0xFF0F765F);
  static const mint = Color(0xFF5BCBAA);
  static const lime = Color(0xFFB9EF55);
  static const card = Color(0xFFFFFCFC);
  static const panel = Color(0xFFE2E0DA);
  static const grey = Color(0xFF777777);

  bool timbangan = true;
  DateTime tanggal = DateTime.now();
  String mulai = '09:00 WIB';
  String selesai = '12:00 WIB';
  String slot = '09:00 - 09:30 WIB';
  bool pengumumanDikirim = false;
  int kuotaPencairan = 1;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    // Refresh status automatically while this screen is open.
    _statusTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  // Pilihan waktu tersedia setiap 30 menit, dari pukul 06.00 sampai 18.00.
  // Total ada 25 pilihan waktu, termasuk 06.00 dan 18.00.
  final List<String> waktuOptions = List.generate(
    25,
    (index) => _formatTime(6 * 60 + index * 30),
  );

  // Waktu mulai harus menyisakan setidaknya satu slot 30 menit.
  List<String> get waktuMulaiOptions =>
      waktuOptions.where((waktu) => _parseTime(waktu) < 18 * 60).toList();

  // Waktu selesai harus selalu lebih akhir daripada waktu mulai.
  List<String> get waktuSelesaiOptions => waktuOptions
      .where((waktu) => _parseTime(waktu) > _parseTime(mulai))
      .toList();

  DateTime get waktuMulaiSesi {
    final time = _parseTime(mulai);
    return DateTime(tanggal.year, tanggal.month, tanggal.day, time ~/ 60, time % 60);
  }

  DateTime get waktuSelesaiSesi {
    final time = _parseTime(selesai);
    return DateTime(tanggal.year, tanggal.month, tanggal.day, time ~/ 60, time % 60);
  }

  String get statusSesiOtomatis {
    if (!pengumumanDikirim) return 'Belum Dijadwalkan';

    final now = DateTime.now();
    if (now.isBefore(waktuMulaiSesi)) return 'Sesi Akan Dibuka';
    if (now.isAfter(waktuSelesaiSesi)) return 'Sesi Ditutup';
    return 'Sesi Dibuka';
  }

  // Setiap slot berdurasi 30 menit dan maksimal menampung 5 warga.
  List<String> get slotOptions {
    final start = _parseTime(mulai);
    final end = _parseTime(selesai);
    if (end <= start) return [];

    return List.generate(
      (end - start) ~/ 30,
      (index) {
        final slotStart = start + index * 30;
        final slotEnd = slotStart + 30;
        return '${_formatClock(slotStart)} - ${_formatClock(slotEnd)} WIB';
      },
    );
  }

  int get jumlahSlot {
    final start = _parseTime(mulai);
    final end = _parseTime(selesai);
    if (end <= start) return 0;
    return (end - start) ~/ 30;
  }

  int get kapasitasWarga => jumlahSlot * 5;

  static int _parseTime(String value) {
    final clean = value.replaceAll(' WIB', '');
    final parts = clean.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  static String _formatClock(int totalMinutes) {
    final hour = (totalMinutes ~/ 60).toString().padLeft(2, '0');
    final minute = (totalMinutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String _formatTime(int totalMinutes) => '${_formatClock(totalMinutes)} WIB';

  String _formatTanggal(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggal,
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Pilih tanggal pelaksanaan',
      cancelText: 'Batal',
      confirmText: 'Pilih',
    );

    if (picked != null) {
      setState(() {
        tanggal = picked;
        pengumumanDikirim = false;
      });
    }
  }

  void _ubahMulai(String value) {
    final selectedStart = _parseTime(value);
    if (selectedStart >= 18 * 60) {
      _message('Waktu mulai harus sebelum pukul 18:00 WIB.');
      return;
    }

    setState(() {
      mulai = value;
      pengumumanDikirim = false;
      if (_parseTime(selesai) <= selectedStart) {
        selesai = _formatTime(selectedStart + 30);
      }
      final generated = slotOptions;
      if (generated.isNotEmpty && !generated.contains(slot)) {
        slot = generated.first;
      }
    });
  }

  void _ubahSelesai(String value) {
    if (_parseTime(value) <= _parseTime(mulai)) {
      _message('Waktu selesai harus setelah waktu mulai.');
      return;
    }

    setState(() {
      selesai = value;
      pengumumanDikirim = false;
      final generated = slotOptions;
      if (generated.isNotEmpty && !generated.contains(slot)) {
        slot = generated.first;
      }
    });
  }

  final List<Map<String, String>> antreanTimbang = [
    {'nama': 'Siti Aminah', 'telp': '0821-0678-4545', 'alamat': 'Blok D1 No. 04, Plamo Garden', 'kode': 'AA-001'},
    {'nama': 'Della Aminah', 'telp': '0821-0678-4545', 'alamat': 'Blok D1 No. 04, Plamo Garden', 'kode': 'AA-002'},
    {'nama': 'Fahri', 'telp': '0821-0678-4545', 'alamat': 'Blok D1 No. 04, Plamo Garden', 'kode': 'AA-003'},
    {'nama': 'Aisyah', 'telp': '0821-0678-4545', 'alamat': 'Blok D1 No. 04, Plamo Garden', 'kode': 'AA-004'},
    {'nama': 'Ainun', 'telp': '0821-0678-4545', 'alamat': 'Blok D1 No. 04, Plamo Garden', 'kode': 'AA-005'},
  ];

  final List<Map<String, String>> antreanDana = [
    {'nama': 'Siti Aminah', 'telp': '0821-0678-4545', 'alamat': 'Blok D1 No. 04, Plamo Garden', 'nominal': 'Rp 150.000', 'status': 'Menunggu'},
    {'nama': 'Della Aminah', 'telp': '0821-0678-4545', 'alamat': 'Blok D1 No. 04, Plamo Garden', 'nominal': 'Rp 200.000', 'status': 'Menunggu'},
    {'nama': 'Fahri', 'telp': '0821-0678-4545', 'alamat': 'Blok D1 No. 04, Plamo Garden', 'nominal': 'Rp 50.000', 'status': 'Menunggu'},
    {'nama': 'Aisyah', 'telp': '0821-0678-4545', 'alamat': 'Blok D1 No. 04, Plamo Garden', 'nominal': 'Rp 12.000', 'status': 'Menunggu'},
    {'nama': 'Ainun', 'telp': '0821-0678-4545', 'alamat': 'Blok D1 No. 04, Plamo Garden', 'nominal': 'Rp 25.000', 'status': 'Menunggu'},
  ];

  @override
  Widget build(BuildContext context) {
    final count = timbangan ? antreanTimbang.length : antreanDana.length;
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(),
                    const SizedBox(height: 18),
                    _banner(count),
                    const SizedBox(height: 16),
                    _tabs(),
                    const SizedBox(height: 14),
                    _formSesi(),
                    if (pengumumanDikirim) ...[
                      const SizedBox(height: 24),
                      Text(
                        timbangan
                            ? 'Daftar Antrian Penimbangan Sampah'
                            : 'Daftar Antrian Pencairan Dana',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 13),
                      _filterSlot(),
                      const SizedBox(height: 12),
                      _listAntrean(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _header() => Padding(
  padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
  child: Row(
    children: [
      const Spacer(),
      IconButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfilPengurusScreen(),
            ),
          );
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        icon: const Icon(
          Icons.account_circle_outlined,
          color: Color(0xFF0F6E56),
          size: 32,
        ),
      ),
    ],
  ),
);

  Widget _title() => Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: mint, shape: BoxShape.circle),
            child: const Icon(Icons.groups_rounded, color: green),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Kelola Antrean & Pengumuman', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          ),
        ],
      );

  Widget _banner(int count) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF106D58), Color(0xFF12B995)],
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.16), blurRadius: 9, offset: const Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.17), borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      statusSesiOtomatis == 'Belum Dijadwalkan'
                          ? 'Belum Dijadwalkan'
                          : statusSesiOtomatis == 'Sesi Dibuka'
                              ? 'Sesi Dibuka'
                              : statusSesiOtomatis == 'Sesi Akan Dibuka'
                                  ? 'Sesi Akan Dibuka'
                                  : 'Sesi Ditutup',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Bank Sampah RW 04', style: TextStyle(fontSize: 11, color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text('$count Warga Menunggu ${timbangan ? 'Timbangan Sampah' : 'Pencairan Dana'}',
                      style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(13)),
              child: const Icon(Icons.balance_rounded, color: Color(0xFFB6F2DF), size: 29),
            ),
          ],
        ),
      );

  Widget _tabs() => Row(
        children: [
          Expanded(
            child: _tabButton('Timbangan Sampah', timbangan, () {
              if (timbangan) return;
              setState(() {
                timbangan = true;
                pengumumanDikirim = false;
              });
            }),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _tabButton('Pencairan Dana', !timbangan, () {
              if (!timbangan) return;
              setState(() {
                timbangan = false;
                pengumumanDikirim = false;
              });
            }),
          ),
        ],
      );

  Widget _tabButton(String label, bool selected, VoidCallback onTap) => Material(
        color: selected ? mint : card,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 43,
            child: Center(child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800))),
          ),
        ),
      );

  Widget _formSesi() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.11), blurRadius: 8, offset: const Offset(0, 3)),
        ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(
                  timbangan
                      ? 'Buka Sesi Penimbangan Sampah'
                      : 'Buka Sesi Pencairan Dana',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 14),
            _field(
              'Tanggal Pelaksanaan',
              InkWell(
                onTap: _pilihTanggal,
                borderRadius: BorderRadius.circular(11),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        timbangan
                            ? Icons.calendar_month_outlined
                            : Icons.event_outlined,
                        color: green,
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          _formatTanggal(tanggal),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: green,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _field(
                    'Waktu Mulai',
                    _dropdown(mulai, waktuMulaiOptions, (v) {
                      if (v != null) _ubahMulai(v);
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _field(
                    'Waktu Selesai',
                    _dropdown(selesai, waktuSelesaiOptions, (v) {
                      if (v != null) _ubahSelesai(v);
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            timbangan ? _kuotaTimbang() : _kuotaDana(),
            const SizedBox(height: 10),
            Text(
              'Status otomatis: $statusSesiOtomatis',
              style: const TextStyle(
                fontSize: 10,
                color: grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 126,
                height: 42,
                child: ElevatedButton(
                  onPressed: _kirimSesi,
                  style: ElevatedButton.styleFrom(backgroundColor: green, foregroundColor: Colors.white, elevation: 3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Kirim', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _field(String label, Widget child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          child,
        ],
      );

  Widget _dropdown(String value, List<String> options, ValueChanged<String?> onChanged, {bool compact = false}) => Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: compact ? 7 : 10),
        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(11), boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ]),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: green, size: 20),
            items: options.map((item) => DropdownMenuItem(value: item, child: Text(item, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: compact ? 9 : 11, fontWeight: FontWeight.w600)))).toList(),
            onChanged: onChanged,
          ),
        ),
      );

  Widget _kuotaTimbang() => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _roundIcon(Icons.access_time_filled),
                const SizedBox(width: 9),
                const Expanded(
                  child: Text(
                    'Batas Kuota Kehadiran',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(Icons.auto_awesome, color: green, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Kapasitas Warga:',
                    style: TextStyle(fontSize: 10, color: grey),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$kapasitasWarga Warga ($jumlahSlot slot × 5)',
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _kuotaDana() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(13), boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ]),
        child: Row(children: [
          _roundIcon(Icons.access_time_filled),
          const SizedBox(width: 9),
          const Expanded(child: Text('Batas Kuota Kehadiran', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800))),
          _counter(Icons.remove, () { if (kuotaPencairan > 1) setState(() => kuotaPencairan--); }),
          Container(margin: const EdgeInsets.symmetric(horizontal: 6), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(8)), child: Text('$kuotaPencairan', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800))),
          _counter(Icons.add, () => setState(() => kuotaPencairan++)),
        ]),
      );

  Widget _roundIcon(IconData icon) => Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(color: mint, shape: BoxShape.circle),
        child: Icon(icon, color: green, size: 17),
      );

  Widget _counter(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(width: 25, height: 25, decoration: const BoxDecoration(color: green, shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 15)),
      );

  Widget _filterSlot() {
    final availableSlots = slotOptions;
    final selectedSlot = availableSlots.contains(slot)
        ? slot
        : (availableSlots.isNotEmpty ? availableSlots.first : null);

    return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(13), boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ]),
        child: Row(children: [
          const Icon(Icons.access_time_outlined, color: green, size: 21),
          const SizedBox(width: 9),
          const Text('Pilih Jam', style: TextStyle(fontSize: 11, color: grey)),
          const Spacer(),
          Flexible(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSlot,
                isExpanded: true,
                hint: const Text('Atur waktu sesi', style: TextStyle(fontSize: 10)),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: green),
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.black87),
                items: availableSlots
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s, overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => slot = v);
                },
              ),
            ),
          ),
        ]),
      );
  }

  Widget _listAntrean() {
    final data = timbangan ? antreanTimbang : antreanDana;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16), boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
      ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(padding: EdgeInsets.only(left: 7), child: Text('Daftar Antrian', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),
        const SizedBox(height: 12),
        ...List.generate(data.length, (i) => Column(children: [
          _itemAntrean(data[i]),
          if (i != data.length - 1) Container(margin: const EdgeInsets.symmetric(vertical: 9), height: 1, color: Colors.black26),
        ])),
      ]),
    );
  }

  Widget _itemAntrean(Map<String, String> item) {
    final nama = item['nama'] ?? '';
    return Row(children: [
      Container(width: 38, height: 38, alignment: Alignment.center, decoration: const BoxDecoration(color: mint, shape: BoxShape.circle), child: Text(nama.isEmpty ? '?' : nama[0].toUpperCase(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
      const SizedBox(width: 8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(nama, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
        Text('☎ ${item['telp'] ?? '-'}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8.5, color: grey)),
        Text(item['alamat'] ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8, color: grey)),
      ])),
      const SizedBox(width: 5),
      if (timbangan) ...[
        _infoChip(item['kode'] ?? '-'),
        const SizedBox(width: 5),
        _action('Input', () => _message('Form input timbang $nama belum dihubungkan.')),
      ] else ...[
        _moneyChip(item['nominal'] ?? '-'),
        const SizedBox(width: 5),
        _action(item['status'] == 'Selesai' ? 'Selesai' : 'Selesai', () => _selesaikanDana(item)),
      ],
    ]);
  }

  Widget _infoChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(color: mint, borderRadius: BorderRadius.circular(5), boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ]),
        child: Text(text, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
      );

  Widget _moneyChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: BoxDecoration(color: card, borderRadius: BorderRadius.circular(10), boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ]),
        child: Text(text, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
      );

  Widget _action(String label, VoidCallback onTap) => SizedBox(
        width: 58,
        height: 32,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(backgroundColor: lime, foregroundColor: Colors.black87, elevation: 2, padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text(label, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800)),
        ),
      );

  Widget _bottomNav() => BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF4FBF7),
        selectedItemColor: green,
        unselectedItemColor: Colors.black45,
        selectedFontSize: 9.5,
        unselectedFontSize: 9.5,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Verifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Antrean Warga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Rekap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Pengurus',
          ),
        ],
        onTap: (i) {
        Widget? tujuan;

        switch (i) {
          case 0:
            tujuan = const VerifikasiWargaScreen();
            break;

          case 1:
            tujuan = const KatalogPengurusScreen();
            break;

          case 2:
            return;

          case 4:
            tujuan = const ProfilPengurusScreen();
            break;

          default:
            _message('Menu ini belum dihubungkan.');
            return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => tujuan!,
          ),
        );
      },
      );

  void _kirimSesi() {
    final start = _parseTime(mulai);
    final end = _parseTime(selesai);

    if (end <= start) {
      _message('Waktu selesai harus setelah waktu mulai.');
      return;
    }

    if ((end - start) % 30 != 0) {
      _message('Durasi sesi harus kelipatan 30 menit.');
      return;
    }

    if (waktuSelesaiSesi.isBefore(DateTime.now())) {
      _message('Waktu sesi sudah lewat. Pilih tanggal atau waktu yang akan datang.');
      return;
    }

    final pengumuman = AnnouncementData(
      jenis: timbangan ? 'timbangan' : 'pencairan',
      tanggal: tanggal,
      mulai: mulai,
      selesai: selesai,
      kuota: timbangan ? kapasitasWarga : kuotaPencairan,
      diterbitkanPada: DateTime.now(),
    );

    // Publikasikan ke state bersama agar banner beranda warga langsung diperbarui.
    AnnouncementStore.publish(pengumuman);

    setState(() {
      pengumumanDikirim = true;
    });

    _message(
      'Pengumuman ${timbangan ? 'penimbangan sampah' : 'pencairan dana'} '
      'berhasil dikirim untuk ${_formatTanggal(tanggal)}, '
      'pukul $mulai–$selesai. Banner beranda warga telah diperbarui.',
    );
  }

  void _selesaikanDana(Map<String, String> item) {
    setState(() => item['status'] = 'Selesai');
    _message('Status pencairan ${item['nama']} diubah menjadi selesai.');
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
