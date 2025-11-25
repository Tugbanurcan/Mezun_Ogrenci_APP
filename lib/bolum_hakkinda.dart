import 'package:flutter/material.dart';
import 'widgets/alt_icon.dart';
import 'home_page.dart';

class BolumHakkindaPage extends StatefulWidget {
  const BolumHakkindaPage({super.key});

  @override
  State<BolumHakkindaPage> createState() => _BolumHakkindaPageState();
}

class _BolumHakkindaPageState extends State<BolumHakkindaPage> {
  int _selectedIndex = 2; // Ana sayfa seçili varsayılan

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    //  Burada sayfa yönlendirmelerini yapabilirsin
    // Örneğin:
    // if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (_) => const AnaSayfa()));
  }

  final List<Map<String, String>> akademisyenler = [
    {
      "isim": "Doç. Dr. Kemal AKYOL (Bölüm Başkanı)",
      "alan": "Bilgisayar Bilimleri",
      "mail": "kakyol@kastamonu.edu.tr",
      "foto": "assets/kemal.webp",
    },
    {
      "isim": "Dr. Öğr. Üyesi Ali Burak ÖNCÜL",
      "alan": "Bilgisayar Bilimleri",
      "mail": "boncul@kastamonu.edu.tr",
      "foto": "assets/aliburak.webp",
    },
    {
      "isim": "Dr. Öğr. Üyesi Ahmet Nusret ÖZALP (Bölüm Başkan Yardımcısı)",
      "alan": "Bilgisayar Donanımı",
      "mail": "ali.demir@universite.edu.tr",
      "foto": "assets/nusret.webp",
    },
    {
      "isim": "Doç. Dr. Ekmel ÇETİN",
      "alan": "Bilgisayar Bilimleri",
      "mail": "ekmel@kastamonu.edu.tr",
      "foto": "assets/ekmel.webp",
    },
    {
      "isim": "Doç. Dr. Salih GÖRGÜNOĞLU",
      "alan": "Bilgisayar Donanımı",
      "mail": "sgorgunoglu@kastamonu.edu.tr",
      "foto": "assets/salih.webp",
    },
    {
      "isim": "Doç. Dr. Melike KAPLAN YALÇIN (Bölüm Başkan Yardımcısı)",
      "alan": "Bilgisayar Bilimleri",
      "mail": "mkaplan@kastamonu.edu.tr",
      "foto": "assets/melike.webp",
    },
    {
      "isim": "Dr. Öğr. Üyesi Atilla SUNCAK",
      "alan": "Bilgisayar Teknolojileri",
      "mail": "atillasuncak@kastamonu.edu.tr",
      "foto": "assets/atilla.webp",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Bölüm Hakkında",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AnaSayfa()),
            );
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "AKADEMİSYENLER",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: akademisyenler.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final hoca = akademisyenler[index];
                  return _AkademisyenKart(
                    isim: hoca["isim"]!,
                    alan: hoca["alan"]!,
                    mail: hoca["mail"]!,
                    foto: hoca["foto"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 🔹 Alt Bar (tüm sayfalarla aynı görünüm)
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AltIcon(
              ikon: Icons.chat,
              label: 'Chat',
              isSelected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            AltIcon(
              ikon: Icons.event,
              label: 'Etkinlikler',
              isSelected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            AltIcon(
              ikon: Icons.home,
              label: 'Ana Sayfa',
              isSelected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            AltIcon(
              ikon: Icons.person_search,
              label: 'Mentor Bul',
              isSelected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
            AltIcon(
              ikon: Icons.work_outline,
              label: 'İş & Staj',
              isSelected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Akademisyen Kartı Bileşeni
class _AkademisyenKart extends StatelessWidget {
  final String isim;
  final String alan;
  final String mail;
  final String foto;

  const _AkademisyenKart({
    required this.isim,
    required this.alan,
    required this.mail,
    required this.foto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(foto),
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(height: 8),
          Text(
            isim,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF7AD0B0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              alan,
              style: const TextStyle(fontSize: 12, color: Color(0xFF4A7861)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            mail,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
