import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Client terpusat untuk semua request ke Laravel REST API.
///
/// Aturan penting: URL backend HANYA ditulis di sini, jangan di screen.
///
/// Alamat otomatis:
/// - Emulator Android  : 10.0.2.2 (alias localhost komputer)
/// - Windows/Web/iOS   : 127.0.0.1
/// - HP fisik          : isi [overrideBaseUrl] dengan IP LAN komputer,
///                       contoh: 'http://192.168.1.10:3000/api'
class ApiClient {
  ApiClient._();

  /// Kosongkan agar alamat dipilih otomatis sesuai platform.
  /// Isi dengan IP LAN komputer bila memakai HP fisik, contoh:
  /// `ApiClient.overrideBaseUrl = 'http://192.168.1.10:3000/api';`
  static String? overrideBaseUrl = 'http://10.108.142.51:3000/api';

  static String get baseUrl {
    if (overrideBaseUrl != null) return overrideBaseUrl!;
    if (kIsWeb) return 'http://127.0.0.1:3000/api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }
    return 'http://127.0.0.1:3000/api';
  }

  static String? _token;
  static String? role;
  static String? nama;

  static bool get isLoggedIn => _token != null;
  static bool get isPengurus => role == 'pengurus';
  static bool get isUbs => role == 'ubs';
  static bool get isWarga => role == 'warga';

  static void setSession({
    required String? token,
    String? userRole,
    String? userNama,
  }) {
    _token = token;
    role = userRole ?? role;
    nama = userNama ?? nama;
  }

  static void clearSession() {
    _token = null;
    role = null;
    nama = null;
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    // Wajib: agar Laravel membalas JSON (bukan redirect HTML) saat error.
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  static Future<ApiResponse> get(String path) async {
    final res = await http
        .get(Uri.parse('$baseUrl$path'), headers: _headers)
        .timeout(const Duration(seconds: 15));
    return ApiResponse.fromHttp(res);
  }

  static Future<ApiResponse> post(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final res = await http
        .post(
          Uri.parse('$baseUrl$path'),
          headers: _headers,
          body: jsonEncode(body ?? const <String, dynamic>{}),
        )
        .timeout(const Duration(seconds: 15));
    return ApiResponse.fromHttp(res);
  }

  static Future<ApiResponse> patch(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final res = await http
        .patch(
          Uri.parse('$baseUrl$path'),
          headers: _headers,
          body: jsonEncode(body ?? const <String, dynamic>{}),
        )
        .timeout(const Duration(seconds: 15));
    return ApiResponse.fromHttp(res);
  }

  static Future<ApiResponse> delete(String path) async {
    final res = await http
        .delete(Uri.parse('$baseUrl$path'), headers: _headers)
        .timeout(const Duration(seconds: 15));
    return ApiResponse.fromHttp(res);
  }

  // -------------------------------------------------------------------
  // Auth
  // -------------------------------------------------------------------
  static Future<ApiResponse> registerWarga(Map<String, dynamic> data) {
    return post('/warga/register', data);
  }

  static Future<ApiResponse> login({
    required String whatsapp,
    required String password,
  }) async {
    final res = await post('/login', {
      'whatsapp': whatsapp,
      'password': password,
    });

    if (res.isSuccess) {
      final data = res.data;
      setSession(
        token: res.body['token'] as String?,
        userRole: res.body['role'] as String? ?? data?['role'] as String?,
        userNama: data?['nama'] as String?,
      );
    }

    return res;
  }

  static Future<ApiResponse> me() => get('/me');
  static Future<ApiResponse> logout() => post('/logout');

  // -------------------------------------------------------------------
  // Jadwal, pengumuman & antrean
  // -------------------------------------------------------------------
  static Future<ApiResponse> jadwal({String? jenis, bool upcoming = false}) {
    final params = <String>[];
    if (jenis != null) params.add('jenis=$jenis');
    if (upcoming) params.add('upcoming=1');
    return get('/jadwal${params.isEmpty ? '' : '?${params.join('&')}'}');
  }

  /// Nama lama dipertahankan agar layar lama tetap kompatibel.
  static Future<ApiResponse> pengumuman({
    String? jenis,
    bool upcoming = false,
  }) {
    return jadwal(jenis: jenis, upcoming: upcoming);
  }

  static Future<ApiResponse> slots(int jadwalId) {
    return get('/jadwal/$jadwalId/slot');
  }

  static Future<ApiResponse> antreanSaya() => get('/antrean/saya');

  static Future<ApiResponse> buatAntrean({
    required int jadwalId,
    required String slotMulai,
    required String slotSelesai,
    required List<String> jenisSampah,
  }) {
    return post('/antrean', {
      'id_jadwal': jadwalId,
      'slot_mulai': slotMulai,
      'slot_selesai': slotSelesai,
      'jenis_sampah': jenisSampah,
    });
  }

  static Future<ApiResponse> batalkanAntrean(int id) => delete('/antrean/$id');

  // -------------------------------------------------------------------
  // Katalog
  // -------------------------------------------------------------------
  static Future<ApiResponse> katalog() => get('/katalog');
  static Future<ApiResponse> kategori() => get('/kategori');

  // -------------------------------------------------------------------
  // Transaksi & dompet
  // -------------------------------------------------------------------
  static Future<ApiResponse> transaksi({String? dari, String? sampai}) {
    final params = <String>[];
    if (dari != null) params.add('dari=$dari');
    if (sampai != null) params.add('sampai=$sampai');
    return get('/transaksi${params.isEmpty ? '' : '?${params.join('&')}'}');
  }

  static Future<ApiResponse> dompet() => get('/dompet');

  static Future<ApiResponse> pencairan({String? status}) {
    return get('/pencairan${status == null ? '' : '?status=$status'}');
  }

  static Future<ApiResponse> ajukanPencairan({
    required num nominal,
    String? catatan,
  }) {
    return post('/pencairan', {'nominal': nominal, 'catatan': ?catatan});
  }

  // -------------------------------------------------------------------
  // Pengurus
  // -------------------------------------------------------------------
  static Future<ApiResponse> daftarVerifikasi({String status = 'menunggu'}) {
    return get('/verifikasi?status=$status');
  }

  static Future<ApiResponse> verifikasiWarga(
    int userId,
    String status, {
    String? catatan,
  }) {
    return patch('/verifikasi/$userId', {
      'status': status,
      'catatan': ?catatan,
    });
  }

  static Future<ApiResponse> terbitkanJadwal(Map<String, dynamic> data) {
    return post('/jadwal', data);
  }

  static Future<ApiResponse> terbitkanPengumuman(Map<String, dynamic> data) {
    return post('/pengumuman', data);
  }

  // -------------------------------------------------------------------
  // Rekap
  // -------------------------------------------------------------------
  static Future<ApiResponse> rekapSampah({String? awal, String? akhir}) {
    return _rekap('/rekap/sampah', awal, akhir);
  }

  static Future<ApiResponse> rekapKas({String? awal, String? akhir}) {
    return _rekap('/rekap/kas', awal, akhir);
  }

  static Future<ApiResponse> rekapGabungan({String? awal, String? akhir}) {
    return _rekap('/rekap/gabungan', awal, akhir);
  }

  static Future<ApiResponse> _rekap(String path, String? awal, String? akhir) {
    final params = <String>[];
    if (awal != null) params.add('periode_awal=$awal');
    if (akhir != null) params.add('periode_akhir=$akhir');
    return get('$path${params.isEmpty ? '' : '?${params.join('&')}'}');
  }
}

/// Pembungkus response agar penanganan sukses/error konsisten.
class ApiResponse {
  ApiResponse(this.statusCode, this.body);

  final int statusCode;
  final Map<String, dynamic> body;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  String get message =>
      (body['message'] ?? 'Terjadi kesalahan pada server').toString();

  Map<String, dynamic>? get data {
    final value = body['data'];
    return value is Map<String, dynamic> ? value : null;
  }

  List<Map<String, dynamic>> get dataList {
    final value = body['data'];
    if (value is List) {
      return value
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }

  /// Laravel mengirim {message, errors: {field: [pesan]}} saat status 422.
  String get firstError {
    final errors = body['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
    }
    return message;
  }

  factory ApiResponse.fromHttp(http.Response res) {
    Map<String, dynamic> parsed;
    try {
      final decoded = jsonDecode(res.body);
      parsed = decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{'data': decoded};
    } catch (_) {
      parsed = <String, dynamic>{
        'message': 'Respons server bukan JSON (status ${res.statusCode})',
      };
    }
    return ApiResponse(res.statusCode, parsed);
  }
}
