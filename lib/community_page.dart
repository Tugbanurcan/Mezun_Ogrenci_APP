import 'package:flutter/material.dart';
import 'widgets/alt_icon.dart';
import 'home_page.dart';
import 'profile_view_screen.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}


// altbar fonksiyonu
class _CommunityPageState extends State<CommunityPage> {
  int _selectedIndex = -1; // Alt bardaki seçili ikon
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) { // Ana Sayfa ikonu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AnaSayfa()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Topluluk formları",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            // 1. ADIM: Tıklama özelliği için GestureDetector ekliyoruz
            child: GestureDetector(
              onTap: () {
                // 2. ADIM: Sayfa geçiş kodunu buraya yazıyoruz
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileViewScreen()),
                );
              },
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ForumKarti(
            etiket: "Staj",
            cevapSayisi: "3 Cevap",
            baslik: "Yaz stajı bulmak için ne yapmalıyım?",
            aciklama: "Staj başvuruları konusunda...",
            yazarBilgisi: "Ahmet Yılmaz . 2 gün önce",
          ),
          SizedBox(height: 15),
          ForumKarti(
            etiket: "Ders",
            cevapSayisi: "5 Cevap",
            baslik: "Veri Yapıları dersi için kaynak önerisi...",
            aciklama: "Çalışma için etkili kaynaklar arıyorum...",
            yazarBilgisi: "Zeynep Demir . 2 gün önce",
          ),
        ],
      ),
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
        )
    );
  }
}

// --- YARDIMCI WIDGET'LAR AYNI DOSYADA KALABİLİR VEYA BAŞKA DOSYAYA ALINABİLİR ---

class CustomButton extends StatelessWidget {
  final String text;

  const CustomButton({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ForumKarti extends StatelessWidget {
  final String etiket;
  final String cevapSayisi;
  final String baslik;
  final String aciklama;
  final String yazarBilgisi;

  const ForumKarti({
    required this.etiket,
    required this.cevapSayisi,
    required this.baslik,
    required this.aciklama,
    required this.yazarBilgisi,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black54),
                ),
                child: Text(etiket, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(cevapSayisi, style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            baslik,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            aciklama,
            style: TextStyle(color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  yazarBilgisi,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  CustomButton(text: "Cevapla"),
                  SizedBox(height: 5),
                  CustomButton(text: "Cevapları gör"),
                ],
              )
            ],
          ),
        ],
      ),

    );
  }
}