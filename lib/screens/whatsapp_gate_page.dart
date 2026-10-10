import 'package:flutter/material.dart';
import 'beranda_warga_screen.dart';



class WhatsAppGatePage extends StatefulWidget {

  const WhatsAppGatePage({super.key});



  @override

  State<WhatsAppGatePage> createState() => _WhatsAppGatePageState();

}



class _WhatsAppGatePageState extends State<WhatsAppGatePage> {

  bool _whatsappOpened = false;





  // =====================================================

  // SIMULASI BUKA GRUP WHATSAPP

  // =====================================================

  Future<void> _openWhatsAppGroup(BuildContext context) async {
    // Simulasi frontend tanpa membuka Chrome/WhatsApp.
    setState(() {
      _whatsappOpened = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Simulasi: link grup WhatsApp sudah dibuka',
        ),
      ),
    );
  }


  // =====================================================

  // KE BERANDA

  // =====================================================

  void _goToBeranda() {

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (context) => const BerandaWargaScreen(),

      ),

    );

  }



  // =====================================================

  // BUILD

  // =====================================================

  @override

  Widget build(BuildContext context) {

    return PopScope(

      canPop: false,

      child: Scaffold(

        backgroundColor: const Color(0xFFF7F6EF),

        body: SafeArea(

          child: Column(

            children: [

              _buildHeader(),

              Expanded(

                child: SingleChildScrollView(

                  padding: const EdgeInsets.symmetric(

                    horizontal: 28,

                    vertical: 28,

                  ),

                  child: Column(

                    children: [

                      _buildPortalBadge(),

                      const SizedBox(height: 18),

                      const Text(

                        'Selamat Datang di Posko\nPlamo Garden',

                        textAlign: TextAlign.center,

                        style: TextStyle(

                          fontSize: 25,

                          fontWeight: FontWeight.w800,

                          height: 1.1,

                        ),

                      ),

                      const SizedBox(height: 12),

                      const Text(

                        'Silahkan masuk menggunakan akun warga yang telah\n'

                        'terverifikasi oleh pengurus RW untuk menabung dan\n'

                        'memilah sampah.',

                        textAlign: TextAlign.center,

                        style: TextStyle(

                          fontSize: 12,

                          color: Colors.black54,

                          height: 1.4,

                        ),

                      ),

                      const SizedBox(height: 30),

                      _buildStatusCard(),

                      const SizedBox(height: 35),

                      _buildWhatsAppButton(context),

                      if (_whatsappOpened) ...[

                        const SizedBox(height: 16),

                        _buildContinueButton(),

                      ],

                      const SizedBox(height: 26),

                      _buildRequirementCard(),

                      const SizedBox(height: 75),

                      const Text(

                        'seksi Lingkungan Hidup | Pengurus RW 08 Plamo Garden',

                        textAlign: TextAlign.center,

                        style: TextStyle(

                          fontSize: 12,

                          fontWeight: FontWeight.w600,

                          color: Colors.black45,

                        ),

                      ),

                      const SizedBox(height: 15),

                    ],

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }



  // =====================================================

  // HEADER

  // =====================================================

  Widget _buildHeader() {

    return Container(

      padding: const EdgeInsets.symmetric(

        horizontal: 28,

        vertical: 18,

      ),

      decoration: const BoxDecoration(

        color: Color(0xFFF7F6EF),

        border: Border(

          bottom: BorderSide(

            color: Color(0xFFE4E3DD),

          ),

        ),

      ),

      child: Row(

        children: [

          Container(

            width: 48,

            height: 48,

            decoration: BoxDecoration(

              color: const Color(0xFF117B69),

              borderRadius: BorderRadius.circular(15),

              boxShadow: [

                BoxShadow(

                  color: Colors.black.withOpacity(0.18),

                  blurRadius: 7,

                  offset: const Offset(0, 4),

                ),

              ],

            ),

            child: const Icon(

              Icons.recycling,

              color: Colors.white,

              size: 28,

            ),

          ),

          const SizedBox(width: 14),

          const Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(

                  children: [

                    Text(

                      'Bank Sampah',

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight: FontWeight.w800,

                      ),

                    ),

                    SizedBox(width: 7),

                    _PlamoBadge(),

                  ],

                ),

                SizedBox(height: 2),

                Text(

                  'Posko Lingkungan RT 04 / RW 08',

                  style: TextStyle(

                    fontSize: 11,

                    color: Colors.black54,

                  ),

                ),

              ],

            ),

          ),

          Container(

            padding: const EdgeInsets.symmetric(

              horizontal: 15,

              vertical: 8,

            ),

            decoration: BoxDecoration(

              color: const Color(0xFFE8ECE7),

              borderRadius: BorderRadius.circular(25),

              boxShadow: [

                BoxShadow(

                  color: Colors.black.withOpacity(0.12),

                  blurRadius: 7,

                  offset: const Offset(0, 3),

                ),

              ],

            ),

            child: const Text(

              'Verifikasi RW',

              style: TextStyle(

                fontSize: 10,

                color: Color(0xFF117B69),

                fontWeight: FontWeight.bold,

              ),

            ),

          ),

        ],

      ),

    );

  }



  // =====================================================

  // BADGE PORTAL

  // =====================================================

  Widget _buildPortalBadge() {

    return Container(

      padding: const EdgeInsets.symmetric(

        horizontal: 35,

        vertical: 9,

      ),

      decoration: BoxDecoration(

        color: const Color(0xFF60CEAD),

        borderRadius: BorderRadius.circular(30),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(0.18),

            blurRadius: 8,

            offset: const Offset(0, 3),

          ),

        ],

      ),

      child: const Row(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(

            Icons.badge_outlined,

            size: 18,

          ),

          SizedBox(width: 10),

          Text(

            'Portal Masuk Warga',

            style: TextStyle(

              fontSize: 13,

              fontWeight: FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }



  // =====================================================

  // STATUS AKUN

  // =====================================================

  Widget _buildStatusCard() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: const Color(0xFFFFFAFB),

        borderRadius: BorderRadius.circular(16),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(0.16),

            blurRadius: 10,

            offset: const Offset(0, 5),

          ),

        ],

      ),

      child: Row(

        children: [

          Container(

            width: 45,

            height: 45,

            decoration: BoxDecoration(

              color: const Color(0xFF65D8B8),

              borderRadius: BorderRadius.circular(10),

            ),

            child: const Icon(

              Icons.person_outline,

              color: Color(0xFF087C6C),

              size: 30,

            ),

          ),

          const SizedBox(width: 16),

          const Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  'Status Akun: Terverifikasi Pengurus RW 04',

                  style: TextStyle(

                    fontSize: 13,

                    fontWeight: FontWeight.w800,

                  ),

                ),

                SizedBox(height: 4),

                Text(

                  'Nomor WhatsApp Anda terdaftar otomatis pada\n'

                  'sistem RT 04 / RW 08 Plamo Garden.',

                  style: TextStyle(

                    fontSize: 11,

                    color: Colors.black54,

                    height: 1.3,

                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }



  // =====================================================

  // TOMBOL WHATSAPP (SIMULASI FRONTEND)

  // =====================================================

  Widget _buildWhatsAppButton(BuildContext context) {

    return SizedBox(

      width: double.infinity,

      height: 56,

      child: ElevatedButton(

        onPressed: () => _openWhatsAppGroup(context),

        style: ElevatedButton.styleFrom(

          backgroundColor: const Color(0xFF087D6A),

          foregroundColor: Colors.white,

          elevation: 7,

          shadowColor: Colors.black38,

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(13),

          ),

        ),

        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const CircleAvatar(

              radius: 17,

              backgroundColor: Colors.white,

              child: Icon(

                Icons.arrow_forward,

                color: Color(0xFF087D6A),

                size: 23,

              ),

            ),

            const SizedBox(width: 14),

            Text(

              _whatsappOpened

                  ? 'Buka Grup WhatsApp Lagi'

                  : 'Masuk Ke Grup WA Sekarang',

              style: const TextStyle(

                fontSize: 16,

                fontWeight: FontWeight.w800,

              ),

            ),

          ],

        ),

      ),

    );

  }



  // =====================================================

  // TOMBOL LANJUT KE BERANDA

  // =====================================================

  Widget _buildContinueButton() {

    return Column(

      children: [

        const Row(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(

              Icons.check_circle,

              color: Color(0xFF087D6A),

              size: 18,

            ),

            SizedBox(width: 7),

            Text(

              'Link grup WhatsApp telah dibuka',

              style: TextStyle(

                fontSize: 12,

                color: Color(0xFF087D6A),

                fontWeight: FontWeight.w600,

              ),

            ),

          ],

        ),

        const SizedBox(height: 12),

        SizedBox(

          width: double.infinity,

          height: 56,

          child: ElevatedButton(

            onPressed: _goToBeranda,

            style: ElevatedButton.styleFrom(

              backgroundColor: const Color(0xFF60CEAD),

              foregroundColor: const Color(0xFF073F35),

              elevation: 4,

              shadowColor: Colors.black26,

              shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(13),

              ),

            ),

            child: const Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Icon(

                  Icons.check_circle_outline,

                  size: 23,

                ),

                SizedBox(width: 10),

                Text(

                  'Saya Sudah Bergabung',

                  style: TextStyle(

                    fontSize: 16,

                    fontWeight: FontWeight.w800,

                  ),

                ),

              ],

            ),

          ),

        ),

      ],

    );

  }



  // =====================================================

  // SYARAT AKSES

  // =====================================================

  Widget _buildRequirementCard() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.symmetric(

        horizontal: 24,

        vertical: 24,

      ),

      decoration: BoxDecoration(

        color: const Color(0xFFE8E7E2),

        borderRadius: BorderRadius.circular(16),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(0.18),

            blurRadius: 10,

            offset: const Offset(0, 5),

          ),

        ],

      ),

      child: const Column(

        children: [

          Text(

            'Syarat Akses Beranda:',

            style: TextStyle(

              fontSize: 13,

              fontWeight: FontWeight.w800,

            ),

          ),

          SizedBox(height: 18),

          Text(

            '1. Warga wajib berdomisili di lingkungan perumahan\n'

            '   Plamo Garden RT 04 / RW 08.\n'

            '2. Wajib bergabung ke Grup WhatsApp Resmi\n'

            '   Warga untuk koordinasi jadwal timbang & setoran.\n'

            '3. Akses beranda tabungan terkunci hingga Anda\n'

            '   mengklik link grup WhatsApp resmi.',

            style: TextStyle(

              fontSize: 12,

              height: 1.4,

              color: Colors.black87,

            ),

          ),

        ],

      ),

    );

  }

}



// =====================================================

// BADGE PLAMO

// =====================================================

class _PlamoBadge extends StatelessWidget {

  const _PlamoBadge();



  @override

  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.symmetric(

        horizontal: 9,

        vertical: 3,

      ),

      decoration: BoxDecoration(

        color: const Color(0xFF9CE64F),

        borderRadius: BorderRadius.circular(15),

      ),

      child: const Text(

        'PLAMO',

        style: TextStyle(

          fontSize: 9,

          fontWeight: FontWeight.w800,

          color: Color(0xFF297A1B),

        ),

      ),

    );

  }

}
