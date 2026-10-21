import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pengurus/login_pengurus_screen.dart';

class ProfileUbs extends StatefulWidget {
  const ProfileUbs({super.key});

  @override
  State<ProfileUbs> createState() => _ProfileUbsState();
}

class _ProfileUbsState extends State<ProfileUbs> {
  static const Color green = Color(0xFF08785F);
  static const Color background = Color(0xFFF1F0EA);

  final String nomorWhatsApp = '0845-7865-0934';

  void bukaWhatsApp() {
    // Simulasi tahap front-end: belum memakai url_launcher.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulasi: tautan reset password dikirim via WhatsApp'),
      ),
    );
  }

  void salinNomor() {
    Clipboard.setData(
      ClipboardData(text: nomorWhatsApp),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nomor WhatsApp berhasil disalin'),
      ),
    );
  }

  // =====================================================
  // LOGOUT -> KEMBALI KE LOGIN PENGURUS
  // =====================================================

  void konfirmasiLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Keluar Akun'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun UBS?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              // TODO: Tambahkan proses sign out Firebase di sini bila sudah dipakai.

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreenPengurus(),
                ),
                (route) => false,
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget card({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFA),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Profil UBS',
          style: TextStyle(
            color: Color(0xFFB5B5B5),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerBankSampah(),
                    const SizedBox(height: 12),
                    profilPetugas(),
                    const SizedBox(height: 14),
                    judulSection(
                      Icons.history,
                      'Pemulihan Sandi Akun UBS',
                    ),
                    const SizedBox(height: 9),
                    cardVerifikasi(),
                    const SizedBox(height: 10),
                    cardCakupan(),
                    const SizedBox(height: 32),
                    tombolLogout(),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Dinas Lingkungan Hidup & Kebersihan Kota Batam',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            bottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget headerBankSampah() {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.recycling,
            color: Colors.white,
            size: 29,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bank Sampah',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Pusat Logistik | Mitra DLH Batam',
                style: TextStyle(fontSize: 9),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFB5ED69),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Unit Bank\nSampah',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget profilPetugas() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF006B55),
            Color(0xFF09BA8D),
          ],
        ),
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: ClipOval(
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bpk. H. Rahmat Hidayat, S.T',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Koordinator Utama Unit Bank Sampah (UBS)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pusat Pengelolaan & Logistik Batam Kota',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget judulSection(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF57734D), size: 19),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget cardVerifikasi() {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE3E2DD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.message_outlined,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 9),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verifikasi No. WhatsApp UBS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Daftarkan nomor WhatsApp penanggung jawab UBS. Jika lupa kata sandi login, tautan verifikasi pemulihan (reset password) akan otomatis dikirimkan ke WhatsApp resmi.',
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nomor WhatsApp Pendaftar',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Aktif & Terverifikasi',
                style: TextStyle(
                  color: Color(0xFF668A36),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: salinNomor,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F1E9),
                border: Border.all(
                  color: const Color(0xFFCDD5BD),
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.contact_phone_outlined,
                    color: Color(0xFF648657),
                    size: 19,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      nomorWhatsApp,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const Text(
                    'Ubah',
                    style: TextStyle(
                      color: green,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF668A36),
                size: 18,
              ),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Tautan pemulihan & kode verifikasi dikirim langsung oleh bot resmi.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          const Text(
            'Minta Tautan Reset Sekarang',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Tekan tombol di bawah untuk mencoba pengiriman tautan login sementara lewat sandi ke nomor WhatsApp Anda.',
            style: TextStyle(fontSize: 10, height: 1.3),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: bukaWhatsApp,
              icon: const Icon(
                Icons.link,
                size: 18,
                color: Colors.white,
              ),
              label: const Text(
                'Kirim Tautan Reset Password via WhatsApp',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardCakupan() {
    return card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: Color(0xFF77956A),
                size: 19,
              ),
              SizedBox(width: 7),
              Text(
                'CAKUPAN WILAYAH & MITRA INDUK',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          infoCakupan(
            Icons.storefront,
            const Color(0xFF3FC5A3),
            'UNIT POSKO TERDAFTAR',
            '12 Posko Unit Binaan (Termasuk RW 08 Prima Garden)',
          ),
          const SizedBox(height: 12),
          infoCakupan(
            Icons.account_balance,
            const Color(0xFFFFB83F),
            'GUDANG & TIMBANGAN INDUK',
            'Pusat Daur Ulang (PDU) Baloi Permai',
          ),
        ],
      ),
    );
  }

  Widget infoCakupan(
    IconData icon,
    Color color,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 17,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tombolLogout() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: konfirmasiLogout,
        icon: const Icon(
          Icons.logout,
          color: Colors.red,
          size: 20,
        ),
        label: const Text(
          'Keluar Akun Petugas UBS',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFFBFA),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }

  Widget bottomNavigation() {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 5),
      decoration: BoxDecoration(
        color: background,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navigationItem(
            Icons.location_city_outlined,
            'Rekap',
            () {
              // TODO: Navigasi ke halaman rekap UBS.
            },
          ),
          navigationItem(
            Icons.person_outline,
            'Pengurus',
            () {},
          ),
        ],
      ),
    );
  }

  Widget navigationItem(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: green, size: 27),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                color: green,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}