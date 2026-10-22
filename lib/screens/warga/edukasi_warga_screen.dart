import 'package:flutter/material.dart';

class EdukasiPage extends StatefulWidget {
  const EdukasiPage({super.key});

  @override
  State<EdukasiPage> createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
  static const Color green = Color(0xFF08765F);
  static const Color mint = Color(0xFF5BCBAA);
  static const Color pageColor = Color(0xFFF1F0E8);
  static const Color cardColor = Color(0xFFFFFCFC);

  String selectedFilter = 'Semua Modul';

  bool get showAnorganik =>
      selectedFilter == 'Semua Modul' || selectedFilter == 'Pilah Anorganik';
  bool get showKompos =>
      selectedFilter == 'Semua Modul' || selectedFilter == 'Pembuatan Kompos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageColor,
      // Tanpa AppBar/header profil-logout dan tanpa bottomNavigationBar.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeading(),
                    const SizedBox(height: 18),
                    _buildFilters(),
                    const SizedBox(height: 14),
                    if (showAnorganik) ...[
                      _buildPrincipleCard(),
                      const SizedBox(height: 18),
                      _buildModuleHeader(
                        module: 'MODUL 01',
                        title: 'Pilah Anorganik (Zero Contamination)',
                        badge: '5 Kategori',
                        badgeColor: const Color(0xFFE6E4DE),
                      ),
                      const SizedBox(height: 10),
                      _buildWasteCard(
                        icon: Icons.local_drink_outlined,
                        iconColor: mint,
                        title: 'Plastik (Botol P3 & Cup P1/P2)',
                        badge: 'Tinggi',
                        badgeColor: const Color(0xFF71C9B1),
                        badgeTextColor: green,
                        description: 'Bilas sisa minuman manis, lepaskan label luar dan cincin leher botol, lalu remas atau injak hingga pipih agar kantong tampung muat lebih banyak',
                      ),
                      _buildWasteCard(
                        icon: Icons.inventory_2_outlined,
                        iconColor: const Color(0xFFFFC66D),
                        title: 'Kertas & Kardus (K1 - K5)',
                        badge: 'Prioritas',
                        badgeColor: const Color(0xFFFFC66D),
                        badgeTextColor: const Color(0xFF86500C),
                        description: 'Kelupas lakban/selotip cokelat, lipat kardus hingga rata, serta pisahkan kertas yang berminyak atau bekas kemasan makanan',
                      ),
                      _buildWasteCard(
                        icon: Icons.delete_outline,
                        iconColor: const Color(0xFFD9D9D9),
                        title: 'Logam & Kaleng (C1 - C3)',
                        badge: 'Rutin',
                        badgeColor: const Color(0xFFE0DED8),
                        badgeTextColor: Colors.black87,
                        description: 'Cuci bersih kaleng susu atau sarden. Pastikan tidak ada sisa saus/minyak tersisa agar tidak memicu karat atau mengundang lalat',
                      ),
                      _buildWasteCard(
                        icon: Icons.oil_barrel_outlined,
                        iconColor: const Color(0xFFFFD9A8),
                        title: 'Minyak Jelantah (MJ)',
                        badge: 'Bernilai Tinggi',
                        badgeColor: const Color(0xFFFFC66D),
                        badgeTextColor: const Color(0xFF86500C),
                        description: 'Saring remah tepung/kotoran, dinginkan, lalu tuang ke jeriken/botol plastik tertutup. Dilarang keras dibuang ke got saluran sungai',
                      ),
                      _buildWasteCard(
                        icon: Icons.warning_amber_rounded,
                        iconColor: const Color(0xFFE5E5E5),
                        title: 'B3 Rumah Tangga',
                        badge: 'Wadah Khusus',
                        badgeColor: const Color(0xFFE5E5E5),
                        badgeTextColor: Colors.red,
                        iconIsWarning: true,
                        description: 'Kumpulkan terpisah di kotak khusus untuk diserahkan ke Drop-Point B3 Posko Plamo. Jangan pernah campur kresek sampah umum.',
                      ),
                      const SizedBox(height: 14),
                    ],
                    if (showKompos) ...[
                      _buildModuleHeader(
                        module: 'MODUL 02',
                        title: 'Kompos Mandiri Skala Pekarangan',
                        badge: 'Organik Sehat',
                        badgeColor: const Color(0xFFB6ED55),
                      ),
                      const SizedBox(height: 10),
                      _buildMethodsCard(),
                      const SizedBox(height: 10),
                      _buildCompostBalanceCard(),
                      const SizedBox(height: 10),
                      _buildStepsCard(),
                      const SizedBox(height: 30),
                      _buildReadyCompostCard(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Panah kembali (kiri atas) menuju halaman Beranda.
  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        tooltip: 'Kembali ke Beranda',
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: green, size: 28),
      ),
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: mint,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: green,
                size: 26,
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'MODUL WARGA HIJAU',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: green,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: .2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Edukasi & Panduan Lingkungan',
          style: TextStyle(
            fontSize: 22,
            height: 1.15,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Panduan praktis warga Plamo Garden untuk memilah sampah dari rumah dan mengolah kompos mandiri bernilai guna.',
          style: TextStyle(fontSize: 12, height: 1.25, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    const filters = ['Semua Modul', 'Pilah Anorganik', 'Pembuatan Kompos'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final selected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: selected,
              onSelected: (_) => setState(() => selectedFilter = filter),
              showCheckmark: false,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              backgroundColor: const Color(0xFFE6E4DE),
              selectedColor: green,
              elevation: selected ? 2 : 3,
              shadowColor: Colors.black26,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPrincipleCard() {
    return _panel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: _smallBadge(
                  'Kunci Sukses Timbangan Bersih',
                  const Color(0xFFFFC66D),
                  const Color(0xFF86500C),
                ),
              ),
              const SizedBox(width: 8),
              _iconTile(Icons.verified_outlined, mint, green, size: 40),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'Prinsip 3B: Bersih, Kering, Pipih',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 9),
          const Text(
            'Kenapa harus dari rumah? Menghilangkan aroma tak sedap, meningkatkan nilai tebus timbangan hingga +40%, dan mempercepat rekap posko RT',
            style: TextStyle(fontSize: 11.5, height: 1.22),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E4E0),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              children: [
                Expanded(
                  child: _PrincipleItem(
                    number: '1. Bersih',
                    description: 'Bilas sisa kuah',
                  ),
                ),
                Expanded(
                  child: _PrincipleItem(
                    number: '2. Kering',
                    description: 'Bebas air residu',
                  ),
                ),
                Expanded(
                  child: _PrincipleItem(
                    number: '3. Pipih/Rapi',
                    description: 'Ringkas wadah',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleHeader({
    required String module,
    required String title,
    required String badge,
    required Color badgeColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            module,
            style: const TextStyle(
              color: green,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _smallBadge(badge, badgeColor, Colors.black87),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWasteCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
    required String description,
    bool iconIsWarning = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: _panel(
        padding: const EdgeInsets.all(11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 46,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: iconIsWarning
                    ? Colors.red
                    : (iconColor == mint ? green : const Color(0xFF7B4A0C)),
                size: 29,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      _smallBadge(badge, badgeColor, badgeTextColor),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodsCard() {
    return _panel(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.psychology_alt_outlined, color: green, size: 22),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  '3 Metode Ramah Pekarangan Plamo',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _MethodTile(
                  icon: Icons.waves,
                  title: 'Takakura',
                  subtitle: 'Keranjang kain',
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: _MethodTile(
                  icon: Icons.delete_outline,
                  title: 'Ember Tumpuk',
                  subtitle: 'Panen pupuk cair',
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: _MethodTile(
                  icon: Icons.grass,
                  title: 'Lubang Biopori',
                  subtitle: 'Serap air hujan',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompostBalanceCard() {
    return _panel(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.balance_outlined, color: green, size: 25),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Rumus Keseimbangan Kompos (1:2)',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _balanceItem(
            color: const Color(0xFF5BCBAA),
            icon: Icons.eco_outlined,
            title: 'Unsur Hijau (Nitrogen/Basah)',
            description: 'Sisa sayur sop/tumis tanpa minyak berlebih, kulit buah, ampas kopi bubuk, dan kantong/daun teh basah',
          ),
          const SizedBox(height: 8),
          _balanceItem(
            color: const Color(0xFFFFC96E),
            icon: Icons.settings_outlined,
            title: 'Unsur Cokelat (Karbon/Kering)',
            description: 'Daun pekarangan kering, sekam mentah, serbuk gergaji kayu bersih, atau sobekan karton cokelat tanpa tinta',
          ),
          const SizedBox(height: 8),
          _balanceItem(
            color: const Color(0xFFF34840),
            icon: Icons.do_not_disturb_alt_outlined,
            title: 'Pantangan Kompos (Hindari Bau & Belatung)',
            description: 'Dilarang: Tulang sapi/ayam besar, daging berlendir basi, kotoran hewan peliharaan, dan gulai/sayur bersantan pekat',
            textColor: Colors.white,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _balanceItem({
    required Color color,
    required IconData icon,
    required String title,
    required String description,
    Color textColor = Colors.black,
    Color? iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .35),
              shape: BoxShape.circle,
              border: Border.all(color: textColor.withValues(alpha: .22)),
            ),
            child: Icon(icon, color: iconColor ?? green, size: 23),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10.5,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard() {
    const steps = [
      (
        'Siapkan Wadah Berventilasi',
        'Gunakan ember cat bekas berlubang udara di sisi samping atau keranjang Takakura. Tempatkan di sudut teras yang teduh dan kering',
      ),
      (
        'Buat Lapisan Dasar Penyangga',
        'Isi dasar wadah setebal 5–10 cm dengan sekam padi atau ranting/daun kering sebagai penyerap tirisan dan kelembapan awal',
      ),
      (
        'Masukkan Sampah Dapur Cacahan',
        'Cincang sisa sayur agar luas permukaan bakteri melimpah. Taburkan lapisan cokelat di atasnya untuk meredam bau',
      ),
      (
        'Aduk & Jaga Kelembapan 3 Hari Sekali',
        'Aduk perlahan. Semprot bioaktivator EM4 bila terasa sangat kering. Kompos siap panen gembur dalam kurun 3–5 minggu',
      ),
    ];

    return _panel(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.format_list_numbered, color: green, size: 25),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  '4 Langkah Praktis di Rumah',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == steps.length - 1 ? 0 : 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.$1,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          step.$2,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.2,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReadyCompostCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF19B993), Color(0xFF08765F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .17),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.eco_outlined,
              color: Colors.white,
              size: 31,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tanda Kompos Matang Siap Panen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Warna remah hitam kecokelatan seperti tanah humus pegunungan, aroma segar humus hutan (tidak asam/busuk), dan suhu dingin merata saat disentuh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(12),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _smallBadge(String label, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
          height: 1,
        ),
      ),
    );
  }

  Widget _iconTile(
    IconData icon,
    Color background,
    Color foreground, {
    double size = 42,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: foreground, size: 25),
    );
  }
}

class _PrincipleItem extends StatelessWidget {
  final String number;
  final String description;
  const _PrincipleItem({required this.number, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _MethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 88),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCFC),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF9A5A0B), size: 26),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, height: 1.1),
          ),
        ],
      ),
    );
  }
}
