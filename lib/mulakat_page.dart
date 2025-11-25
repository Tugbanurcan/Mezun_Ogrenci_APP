import 'package:flutter/material.dart';
import 'widgets/alt_icon.dart';
import 'notifications.dart';
import 'profile_view_screen.dart';
import 'home_page.dart';

class MulakatPage extends StatefulWidget {
  const MulakatPage({super.key});

  @override
  State<MulakatPage> createState() => _MulakatPageState();
}

class _MulakatPageState extends State<MulakatPage> {
  int _selectedIndex = 3; // Alt bardaki seçili ikon
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
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 110,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 26,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AnaSayfa()),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.account_circle,
                color: Colors.black87,
                size: 28,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileViewScreen()),
                );
              },
            ),
          ],
        ),

        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black54,
            ),
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
              " Mülakatta Dikkat Edilmesi Gerekenler",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "1. Hazırlıklı Git\n"
              "Şirket hakkında bilgi edin (vizyon, projeler, kültür). Başvurduğun pozisyonun görev tanımını öğren.\n"
              "2. Zamanında Git (En az 10 dk önce orada ol)\n"
              "Gecikmek ilk izlenimi zayıflatır. Online ise bağlantıyı ve mikrofonu önceden test et.\n"
              "3. Temiz ve Uygun Giyin\n"
              "Sade, profesyonel ve pozisyona uygun kıyafet tercih et.\n"
              "4. Beden Diline Dikkat Et\n"
              "Göz teması kur, dik otur, ellerini kontrollü kullan. Gergin veya ilgisiz duruş olumsuz etki bırakır.\n"
              "5. Kendini Kısa ve Etkili Tanıt\n"
              "Hazırlıklı olduğun 1 dakikalık 'Ben Kimim?' cevabın olsun.\n"
              "6. Sorulara Net ve Özgüvenli Cevap Ver\n"
              "Cevabın yoksa 'Bu konuda araştırma yapmadım ama öğrenmeye açığım' diyebilirsin.\n"
              "7. Somut Örneklerle Konuş\n"
              "'Takım çalışmasına yatkınım' yerine '4 kişilik ekipte X projesini tamamladık' de.\n"
              "8. Gereksiz Detaylardan Kaçın\n"
              "Konu dışına çıkma, lafı uzatma → öz ve odaklı ol.\n"
              "9. Sen de Soru Sor\n"
              "'Pozisyonda başarı nasıl ölçülüyor?' gibi sorularla ilgili ve istekli olduğunu göster.\n"
              "10. Teşekkür Et ve Takipte Kal\n"
              "Mülakat sonunda teşekkür et. 1-2 gün sonra kısa bir teşekkür maili atmak fark yaratır.",
              style: TextStyle(fontSize: 15, height: 1.5),
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
