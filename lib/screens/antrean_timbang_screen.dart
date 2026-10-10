import 'package:flutter/material.dart';



class AntreanTimbangScreen extends StatefulWidget {

  const AntreanTimbangScreen({super.key});



  @override

  State<AntreanTimbangScreen> createState() => _AntreanTimbangScreenState();

}



class _AntreanTimbangScreenState extends State<AntreanTimbangScreen> {

  static const Color darkGreen = Color(0xFF0F6E56);

  static const Color mint = Color(0xFF59C8A8);

  static const Color background = Color(0xFFF5F3EA);

  static const Color mustard = Color(0xFFEF9F27);

  static const Color cardColor = Color(0xFFE0DFD9);



  String? selectedTime;

  bool sudahAmbilAntrean = false;

  String? nomorAntrean;

  String selectedDate = '17 September 2026';



  final Set<String> selectedWaste = <String>{};



  final List<String> wasteTypes = [

    'Plastik & Botol',

    'Minyak Jelantah',

    'Kardus/Kertas',

    'Besi/Logam',

  ];



  final List<Map<String, dynamic>> timeSlots = [

    {'time': '09:00 - 09:30 WIB', 'quota': '4/5 Warga', 'available': true},

    {'time': '09:30 - 10:00 WIB', 'quota': '5/5 Warga', 'available': false},

    {'time': '10:00 - 10:30 WIB', 'quota': '1/5 Warga', 'available': true},

    {'time': '10:30 - 11:00 WIB', 'quota': '2/5 Warga', 'available': true},

    {'time': '11:00 - 11:30 WIB', 'quota': '5/5 Warga', 'available': false},

    {'time': '11:30 - 12:00 WIB', 'quota': '4/5 Warga', 'available': true},

  ];



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: background,

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              _buildHeader(),

              const SizedBox(height: 16),

              _buildProfileCard(),

              const SizedBox(height: 14),

              _buildInfoCard(),



              if (sudahAmbilAntrean) ...[

                const SizedBox(height: 20),

                const Text(

                  'Sudah Ambil Antrean Timbang',

                  style: TextStyle(

                    fontSize: 12,

                    color: Colors.black38,

                    fontWeight: FontWeight.w500,

                  ),

                ),

                const SizedBox(height: 10),

                _buildActiveQueueCard(),

              ],



              const SizedBox(height: 20),

              _buildSectionTitle(number: '1', title: 'Jadwal Timbang'),

              const SizedBox(height: 10),

              _buildDateCard(),



              const SizedBox(height: 20),

              _buildSectionTitle(number: '2', title: 'Pilih Slot Waktu'),

              const SizedBox(height: 10),

              ...timeSlots.map(

                (slot) => Padding(

                  padding: const EdgeInsets.only(bottom: 9),

                  child: _buildTimeSlot(slot),

                ),

              ),



              const SizedBox(height: 14),

              _buildSectionTitle(number: '3', title: 'Bocoran Jenis Sampah'),

              const SizedBox(height: 8),

              const Padding(

                padding: EdgeInsets.symmetric(horizontal: 4),

                child: Text(

                  'Bantu timbangan RT menyiapkan wadah karung yang sesuai',

                  style: TextStyle(

                    fontSize: 11,

                    fontWeight: FontWeight.bold,

                    color: Colors.black87,

                  ),

                ),

              ),

              const SizedBox(height: 10),

              _buildWasteTypes(),



              const SizedBox(height: 16),

              _buildSummaryCard(),

            ],

          ),

        ),

      ),

      bottomNavigationBar: _buildBottomNav(),

    );

  }



  Widget _buildHeader() {

    return Row(

      children: [

        IconButton(

          padding: EdgeInsets.zero,

          constraints: const BoxConstraints(),

          onPressed: _kembaliKeBeranda,

          icon: const Icon(Icons.arrow_back, color: darkGreen, size: 24),

        ),

        const SizedBox(width: 10),

        const Expanded(

          child: Text(

            'Ambil Antrean Timbang',

            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

          ),

        ),

        const Icon(Icons.account_circle_outlined, color: darkGreen, size: 31),

      ],

    );

  }



  Widget _buildProfileCard() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        gradient: const LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [Color(0xFF0D7B60), Color(0xFF1ED1A6)],

        ),

        borderRadius: BorderRadius.circular(16),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(alpha: 0.18),

            blurRadius: 10,

            offset: const Offset(0, 4),

          ),

        ],

      ),

      child: Column(

        children: [

          Row(

            children: [

              Container(

                width: 48,

                height: 48,

                alignment: Alignment.center,

                decoration: const BoxDecoration(color: mint, shape: BoxShape.circle),

                child: const Text(

                  'SA',

                  style: TextStyle(

                    fontWeight: FontWeight.bold,

                    color: darkGreen,

                    fontSize: 15,

                  ),

                ),

              ),

              const SizedBox(width: 12),

              const Expanded(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(

                      'Siti Aminah',

                      style: TextStyle(

                        color: Colors.white,

                        fontWeight: FontWeight.bold,

                        fontSize: 14,

                      ),

                    ),

                    SizedBox(height: 3),

                    Text(

                      'RT 04 / Blok B3',

                      style: TextStyle(color: Colors.white, fontSize: 11),

                    ),

                  ],

                ),

              ),

              Container(

                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                decoration: BoxDecoration(

                  color: mustard,

                  borderRadius: BorderRadius.circular(20),

                ),

                child: const Text(

                  'Nasabah',

                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),

                ),

              ),

            ],

          ),

          const SizedBox(height: 14),

          Container(

            width: double.infinity,

            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

            decoration: BoxDecoration(

              color: const Color(0xFF145B4C),

              borderRadius: BorderRadius.circular(12),

            ),

            child: Row(

              children: [

                const Icon(Icons.location_on, color: mustard, size: 20),

                const SizedBox(width: 8),

                const Expanded(

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(

                        'Lokasi Bank Sampah',

                        style: TextStyle(

                          color: Colors.white,

                          fontWeight: FontWeight.bold,

                          fontSize: 12,

                        ),

                      ),

                      SizedBox(height: 2),

                      Text(

                        'Posko Lingkungan RT 04 / RW 08',

                        style: TextStyle(

                          color: Colors.white70,

                          fontWeight: FontWeight.bold,

                          fontSize: 10.5,

                        ),

                      ),

                    ],

                  ),

                ),

                Container(

                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                  decoration: BoxDecoration(

                    color: const Color(0xFFB7E868),

                    borderRadius: BorderRadius.circular(20),

                  ),

                  child: const Text(

                    'Buka',

                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),

                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }



  Widget _buildInfoCard() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(alpha: 0.08),

            blurRadius: 5,

            offset: const Offset(0, 3),

          ),

        ],

      ),

      child: const Row(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(Icons.access_time_filled, color: mustard, size: 23),

          SizedBox(width: 10),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  'Pesan Slot Kedatangan Tertib',

                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),

                ),

                SizedBox(height: 4),

                Text(

                  'Pilih jam penimbangan agar tidak menumpuk di posko. '

                  'Setiap slot memiliki kuota maksimal 5 warga.',

                  style: TextStyle(

                    fontWeight: FontWeight.w500,

                    fontSize: 11,

                    height: 1.35,

                  ),

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }



  Widget _buildActiveQueueCard() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

      decoration: BoxDecoration(

        color: const Color(0xFFF6C56B),

        borderRadius: BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(alpha: 0.14),

            blurRadius: 8,

            offset: const Offset(0, 4),

          ),

        ],

      ),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(

                  'Tiket Antrian Aktif',

                  style: TextStyle(

                    fontSize: 14,

                    fontWeight: FontWeight.bold,

                    color: Color(0xFF805A1C),

                  ),

                ),

                const SizedBox(height: 4),

                const Text(

                  'Nomor Urut Pagi',

                  style: TextStyle(fontSize: 11, color: Color(0xFF8D6A2E)),

                ),

                const SizedBox(height: 5),

                Text(

                  '#${nomorAntrean ?? '-'}',

                  style: const TextStyle(

                    fontSize: 22,

                    fontWeight: FontWeight.bold,

                    color: Color(0xFF6B4A16),

                  ),

                ),

              ],

            ),

          ),

          const SizedBox(width: 12),

          Column(

            crossAxisAlignment: CrossAxisAlignment.end,

            children: [

              _buildTicketChip(selectedDate),

              const SizedBox(height: 6),

              _buildTicketChip(selectedTime ?? '-'),

            ],

          ),

        ],

      ),

    );

  }



  Widget _buildTicketChip(String text) {

    return Container(

      constraints: const BoxConstraints(minWidth: 150),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),

      alignment: Alignment.center,

      decoration: BoxDecoration(

        color: const Color(0xFFF3A823),

        borderRadius: BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(alpha: 0.12),

            blurRadius: 5,

            offset: const Offset(0, 2),

          ),

        ],

      ),

      child: Text(

        text,

        style: const TextStyle(

          color: Colors.white,

          fontSize: 11,

          fontWeight: FontWeight.bold,

        ),

      ),

    );

  }



  Widget _buildSectionTitle({

    required String number,

    required String title,

  }) {

    return Row(

      children: [

        Container(

          width: 22,

          height: 22,

          alignment: Alignment.center,

          decoration: const BoxDecoration(color: darkGreen, shape: BoxShape.circle),

          child: Text(

            number,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 11,

              fontWeight: FontWeight.bold,

            ),

          ),

        ),

        const SizedBox(width: 8),

        Text(

          title,

          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),

        ),

      ],

    );

  }



  Widget _buildDateCard() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(13),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(alpha: 0.08),

            blurRadius: 5,

            offset: const Offset(0, 3),

          ),

        ],

      ),

      child: const Row(

        children: [

          Icon(Icons.calendar_month, color: darkGreen, size: 26),

          SizedBox(width: 12),

          Text(

            '17 September 2026',

            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),

          ),

        ],

      ),

    );

  }



  Widget _buildTimeSlot(Map<String, dynamic> slot) {

    final bool available = slot['available'] as bool;

    final bool selected = selectedTime == slot['time'];



    return GestureDetector(

      onTap: available

          ? () {

              setState(() {

                selectedTime = slot['time'] as String;

              });

            }

          : null,

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 180),

        width: double.infinity,

        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),

        decoration: BoxDecoration(

          color: selected ? mint : cardColor,

          borderRadius: BorderRadius.circular(13),

          border: selected ? Border.all(color: darkGreen, width: 1.3) : null,

          boxShadow: [

            BoxShadow(

              color: Colors.black.withValues(alpha: 0.08),

              blurRadius: 5,

              offset: const Offset(0, 3),

            ),

          ],

        ),

        child: Row(

          children: [

            Expanded(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(

                    slot['time'] as String,

                    style: TextStyle(

                      fontSize: 12,

                      fontWeight: FontWeight.bold,

                      color: available ? Colors.black87 : Colors.black38,

                    ),

                  ),

                  const SizedBox(height: 3),

                  Text(

                    slot['quota'] as String,

                    style: TextStyle(

                      fontSize: 10.5,

                      color: available ? Colors.black54 : Colors.black38,

                    ),

                  ),

                ],

              ),

            ),

            Container(

              constraints: const BoxConstraints(minWidth: 78),

              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),

              alignment: Alignment.center,

              decoration: BoxDecoration(

                color: !available

                    ? Colors.white

                    : selected

                        ? darkGreen

                        : mint,

                borderRadius: BorderRadius.circular(20),

              ),

              child: Text(

                !available

                    ? 'Penuh'

                    : selected

                        ? 'Terpilih'

                        : 'Tersedia',

                style: TextStyle(

                  fontSize: 10,

                  fontWeight: FontWeight.w600,

                  color: !available

                      ? Colors.black38

                      : selected

                          ? Colors.white

                          : Colors.black87,

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }



  Widget _buildWasteTypes() {

    return Wrap(

      spacing: 10,

      runSpacing: 8,

      children: wasteTypes.map((waste) {

        final bool selected = selectedWaste.contains(waste);



        return GestureDetector(

          onTap: () {

            setState(() {

              if (selected) {

                selectedWaste.remove(waste);

              } else {

                selectedWaste.add(waste);

              }

            });

          },

          child: Container(

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),

            decoration: BoxDecoration(

              color: selected ? darkGreen : cardColor,

              borderRadius: BorderRadius.circular(20),

              boxShadow: [

                BoxShadow(

                  color: Colors.black.withValues(alpha: 0.08),

                  blurRadius: 4,

                  offset: const Offset(0, 2),

                ),

              ],

            ),

            child: Text(

              waste,

              style: TextStyle(

                fontSize: 11,

                fontWeight: FontWeight.w600,

                color: selected ? Colors.white : Colors.black87,

              ),

            ),

          ),

        );

      }).toList(),

    );

  }



  Widget _buildSummaryCard() {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(13),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(alpha: 0.15),

            blurRadius: 6,

            offset: const Offset(0, 3),

          ),

        ],

      ),

      child: Column(

        children: [

          Row(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Expanded(

                flex: 2,

                child: Text(

                  'Waktu Dipilih',

                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),

                ),

              ),

              const SizedBox(width: 12),

              Expanded(

                flex: 3,

                child: Text(

                  selectedTime == null

                      ? 'Belum memilih waktu'

                      : 'Minggu, 17 September\n$selectedTime',

                  textAlign: TextAlign.right,

                  softWrap: true,

                  style: const TextStyle(

                    fontSize: 12,

                    fontWeight: FontWeight.bold,

                    color: darkGreen,

                    height: 1.3,

                  ),

                ),

              ),

            ],

          ),

          const SizedBox(height: 18),

          SizedBox(

            width: double.infinity,

            height: 47,

            child: ElevatedButton.icon(

              onPressed: sudahAmbilAntrean ? null : _buatAntrean,

              style: ElevatedButton.styleFrom(

                backgroundColor: darkGreen,

                foregroundColor: Colors.white,

                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(11),

                ),

              ),

              icon: const Icon(Icons.confirmation_num_outlined),

              label: Text(

                sudahAmbilAntrean

                    ? 'Antrean Sudah Dibuat'

                    : 'Buat Antrean Timbang',

                style: const TextStyle(

                  fontWeight: FontWeight.bold,

                  fontSize: 14,

                ),

              ),

            ),

          ),

        ],

      ),

    );

  }



  void _buatAntrean() {

    if (selectedTime == null) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text('Silakan pilih slot waktu terlebih dahulu.'),

        ),

      );

      return;

    }



    if (selectedWaste.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text('Pilih minimal satu jenis sampah.'),

        ),

      );

      return;

    }



    setState(() {

      sudahAmbilAntrean = true;

      nomorAntrean = 'C-02';

    });



    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text('Antrean timbang berhasil dibuat.'),

      ),

    );

  }



  void _kembaliKeBeranda() {
    if (sudahAmbilAntrean) {
      Navigator.pop(
        context,
        <String, dynamic>{
          'nomorAntrean': nomorAntrean,
          'tanggal': selectedDate,
          'waktu': selectedTime,
        },
      );
      return;
    }

    Navigator.pop(context);
  }



  Widget _buildBottomNav() {

    return BottomNavigationBar(

      currentIndex: 0,

      selectedItemColor: darkGreen,

      unselectedItemColor: darkGreen,

      type: BottomNavigationBarType.fixed,

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
