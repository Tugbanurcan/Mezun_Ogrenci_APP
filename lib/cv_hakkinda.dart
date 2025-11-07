import 'package:flutter/material.dart';
import 'widgets/alt_icon.dart';
import 'notifications.dart';
import 'profile_view_screen.dart';

class CvHakkindaPage extends StatefulWidget {
  const CvHakkindaPage({super.key});

  @override
  State<CvHakkindaPage> createState() => _CvHakkindaPageState();
}

class _CvHakkindaPageState extends State<CvHakkindaPage> {
  int _selectedIndex = 4; // Alt bardaki seçili ikon (örnek)
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 60,
        leading: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.black87, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileViewScreen()),
            );
          },
        ),
        title: const Text(
          "CV",
          style: TextStyle(
            fontSize: 22,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black54),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "✅ CV Hazırlarken Mutlaka Dikkat Edilmesi Gerekenler",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text("1. Öz ve net olmalı\n"
                "Gereksiz uzun cümlelerden kaçın, sadece önemli bilgileri yaz.\n"
                "2. Yazım ve imla hatası olmamalı\n"
                "CV’deki küçük bir hata bile ciddiyetini zedeler.\n"
                "3. Güncel bilgiler içermeli\n"
                "E-posta, telefon, mezuniyet yılı gibi bilgiler doğru ve güncel olmalı.\n"
                "4. Tarih sırası tersten olmalı (yeniden eskiye)\n"
                "Deneyim ve eğitim bilgilerinde en güncel olan üstte yer almalı.\n"
                "5. Düzenli ve sade görünüm\n"
                "Karmaşık tasarım ve fazla renk kullanma, okunabilir font tercih et.\n"
                "6. Gerçek bilgiler yer almalı\n"
                "Abartılı veya doğrulanamaz şeylerden kaçın.\n"
                "7. Pozisyona göre özelleştirilmeli\n"
                "Her işe aynı CV’yi göndermek yerine küçük düzenlemeler yap.\n"
                "8. Etkisiz bilgilerden kaçın\n"
                "TC kimlik, medeni hal, doğum tarihi gibi bilgileri ekleme.\n"
                "9. Fotoğraf sadece gerekiyorsa\n"
                "Profesyonel ve sade bir fotoğraf seç.\n"
                "10. Başarı ve katkı odaklı anlatım\n"
                "“Yaptım” demek yerine “şu sonucu elde ettim” tarzında anlat."),
          ],
        ),
      ),

      // 🔹 Alt Navigasyon Bar (her sayfada ortak)
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
              ikon: Icons.home,
              label: 'Ana Sayfa',
              isSelected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            AltIcon(
              ikon: Icons.chat,
              label: 'Chat',
              isSelected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            AltIcon(
              ikon: Icons.celebration,
              label: 'Etkinlik',
              isSelected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            AltIcon(
              ikon: Icons.people,
              label: 'Mentör',
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
