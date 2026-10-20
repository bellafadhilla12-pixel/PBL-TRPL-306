import 'package:flutter/foundation.dart';

/// Data pengumuman yang dibagikan antara halaman pengurus dan warga.
/// Saat ini disimpan di memori aplikasi (front-end demo), belum persisten.
class AnnouncementData {
  final String jenis; // 'timbangan' atau 'pencairan'
  final DateTime tanggal;
  final String mulai;
  final String selesai;
  final int kuota;
  final DateTime diterbitkanPada;

  const AnnouncementData({
    required this.jenis,
    required this.tanggal,
    required this.mulai,
    required this.selesai,
    required this.kuota,
    required this.diterbitkanPada,
  });

  bool get isTimbangan => jenis == 'timbangan';

  String get judul => isTimbangan
      ? 'Jadwal Penimbangan Sampah'
      : 'Pencairan Dana Cash Bank Sampah';

  String get status {
    final startTime = _dateAt(tanggal, mulai);
    final endTime = _dateAt(tanggal, selesai);
    final now = DateTime.now();

    if (now.isBefore(startTime)) return 'Sesi Akan Dibuka';
    if (now.isAfter(endTime)) return 'Sesi Ditutup';
    return 'Dibuka';
  }

  static DateTime _dateAt(DateTime date, String time) {
    final clean = time.replaceAll(' WIB', '');
    final parts = clean.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}

class AnnouncementStore {
  AnnouncementStore._();

  /// Satu pengumuman aktif per jenis kegiatan.
  static final ValueNotifier<Map<String, AnnouncementData>> announcements =
      ValueNotifier<Map<String, AnnouncementData>>({});

  static void publish(AnnouncementData announcement) {
    final updated = Map<String, AnnouncementData>.from(announcements.value);
    updated[announcement.jenis] = announcement;
    announcements.value = updated;
  }
}
