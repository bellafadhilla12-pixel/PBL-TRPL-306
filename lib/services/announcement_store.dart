import 'package:flutter/foundation.dart';

import 'api_client.dart';

/// Data jadwal yang dibagikan antara halaman pengurus dan warga.
/// Satu jadwal = satu sesi (bukan lagi slot 30 menit).
class AnnouncementData {
  final int? id;
  final String jenis; // 'timbangan' atau 'pencairan'
  final DateTime tanggal;
  final String mulai;
  final String selesai;
  final int kuota;
  final int terdaftar;
  final DateTime? batasPendaftaran;
  final String statusJadwal;
  final DateTime diterbitkanPada;

  const AnnouncementData({
    this.id,
    required this.jenis,
    required this.tanggal,
    required this.mulai,
    required this.selesai,
    required this.kuota,
    this.terdaftar = 0,
    this.batasPendaftaran,
    this.statusJadwal = 'aktif',
    required this.diterbitkanPada,
  });

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    final tanggal = DateTime.tryParse(json['tanggal']?.toString() ?? '') ??
        DateTime.now();
    final diterbitkan =
        DateTime.tryParse(json['diterbitkanPada']?.toString() ?? '') ??
            DateTime.now();
    final batas = DateTime.tryParse(
      json['batas_pendaftaran']?.toString() ?? '',
    );

    return AnnouncementData(
      id: (json['id'] as num?)?.toInt(),
      jenis: json['jenis']?.toString() ?? 'timbangan',
      tanggal: tanggal,
      mulai: json['mulai']?.toString() ?? json['jam_mulai']?.toString() ?? '',
      selesai:
          json['selesai']?.toString() ?? json['jam_selesai']?.toString() ?? '',
      kuota: (json['kuota'] as num?)?.toInt() ?? 0,
      terdaftar: (json['terdaftar'] as num?)?.toInt() ?? 0,
      batasPendaftaran: batas,
      statusJadwal: json['status']?.toString() ?? 'aktif',
      diterbitkanPada: diterbitkan,
    );
  }

  bool get isTimbangan => jenis == 'timbangan';

  String get judul => isTimbangan
      ? 'Jadwal Penimbangan Sampah'
      : 'Pencairan Dana Cash Bank Sampah';

  String get status {
    if (statusJadwal != 'aktif') return 'Sesi Ditutup';

    final now = DateTime.now();

    if (!isTimbangan) {
      final batas = batasPendaftaran;
      if (batas != null) {
        final akhir = DateTime(batas.year, batas.month, batas.day, 23, 59, 59);
        return now.isAfter(akhir) ? 'Sesi Ditutup' : 'Pendaftaran Dibuka';
      }
    }

    if (mulai.isEmpty || selesai.isEmpty) {
      final akhir = DateTime(tanggal.year, tanggal.month, tanggal.day, 23, 59);
      return now.isAfter(akhir) ? 'Sesi Ditutup' : 'Sesi Akan Dibuka';
    }

    final startTime = _dateAt(tanggal, mulai);
    final endTime = _dateAt(tanggal, selesai);

    if (now.isBefore(startTime)) return 'Sesi Akan Dibuka';
    if (now.isAfter(endTime)) return 'Sesi Ditutup';
    return 'Dibuka';
  }

  String get waktuLabel {
    if (isTimbangan) {
      return '${mulai.replaceAll(' WIB', '')} - $selesai WIB';
    }

    final batas = batasPendaftaran;
    if (batas != null) {
      const bulan = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];
      return 'Pendaftaran s.d. ${batas.day} ${bulan[batas.month - 1]} ${batas.year}';
    }

    return 'Sesuai jadwal pencairan';
  }

  static DateTime _dateAt(DateTime date, String time) {
    final clean = time.replaceAll(' WIB', '').trim();
    final parts = clean.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.tryParse(parts[0]) ?? 0,
      parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
    );
  }
}

class AnnouncementStore {
  AnnouncementStore._();

  /// Satu jadwal aktif per jenis kegiatan.
  static final ValueNotifier<Map<String, AnnouncementData>> announcements =
      ValueNotifier<Map<String, AnnouncementData>>({});

  /// Ambil jadwal aktif terdekat dari backend.
  static Future<void> load() async {
    final res = await ApiClient.jadwal(upcoming: true);
    if (!res.isSuccess) return;

    final updated = <String, AnnouncementData>{};
    for (final item in res.dataList) {
      final data = AnnouncementData.fromJson(item);

      // Urutan backend sudah naik (paling dekat lebih dulu), jadi
      // jadwal pertama per jenis adalah sesi berikutnya.
      updated.putIfAbsent(data.jenis, () => data);
    }

    announcements.value = updated;
  }

  /// Kirim jadwal ke backend. Mengembalikan pesan error, atau null jika sukses.
  static Future<String?> publish(AnnouncementData announcement) async {
    final tanggal =
        '${announcement.tanggal.year.toString().padLeft(4, '0')}-'
        '${announcement.tanggal.month.toString().padLeft(2, '0')}-'
        '${announcement.tanggal.day.toString().padLeft(2, '0')}';

    final body = <String, dynamic>{
      'jenis': announcement.jenis,
      'judul': announcement.judul,
      'tanggal': tanggal,
      'kuota': announcement.kuota,
    };

    if (announcement.isTimbangan) {
      body['jam_mulai'] =
          announcement.mulai.replaceAll(' WIB', '').trim();
      body['jam_selesai'] =
          announcement.selesai.replaceAll(' WIB', '').trim();
    } else {
      // Pada skema trimset, pencairan memakai batas pendaftaran, bukan jam.
      body['batas_pendaftaran'] = tanggal;
    }

    final res = await ApiClient.terbitkanJadwal(body);

    if (!res.isSuccess) return res.firstError;

    await load();
    return null;
  }
}
