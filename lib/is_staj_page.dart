import 'package:flutter/material.dart';
import 'widgets/alt_icon.dart';
import 'notifications.dart';
import 'profile_view_screen.dart';
import 'home_page.dart';

class IsStajPage extends StatefulWidget {
  const IsStajPage({super.key});

  @override
  State<IsStajPage> createState() => _IsStajPageState();
}

class _IsStajPageState extends State<IsStajPage> {
  int _selectedIndex = 4;

  // 🔹 1. FİLTRELEME İÇİN GEREKLİ DEĞİŞKENLER
  String selectedCategory = "Tümü"; // Hangi buton seçili?
  String searchText = ""; // Arama kutusunda ne yazıyor?

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AnaSayfa()),
        (route) => false,
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Ham Veriler
  final List<Map<String, dynamic>> allJobPostings = [
    {
      "company": "Kastamonu Teknokent",
      "logo": "KT",
      "color": Colors.blueAccent,
      "title": "Flutter Geliştirici Stajyeri",
      "location": "Kastamonu (Hibrit)",
      "type": "Zorunlu Staj", // Kategori: Staj
      "date": "2 gün önce",
    },
    {
      "company": "Trendyol",
      "logo": "TY",
      "color": Colors.orange,
      "title": "Junior Backend Developer",
      "location": "İstanbul (Remote)",
      "type": "Tam Zamanlı", // Kategori: Tam Zamanlı
      "date": "1 hafta önce",
    },
    {
      "company": "Aselsan",
      "logo": "AS",
      "color": Colors.blue.shade900,
      "title": "Siber Güvenlik Uzmanı",
      "location": "Ankara (Ofis)",
      "type": "Tam Zamanlı",
      "date": "3 gün önce",
    },
    {
      "company": "Getir",
      "logo": "GE",
      "color": Colors.purple,
      "title": "Data Analyst Intern",
      "location": "İstanbul (Maslak)",
      "type": "Yaz Stajı", // Kategori: Staj
      "date": "Yeni",
    },
    {
      "company": "Papara",
      "logo": "PA",
      "color": Colors.black,
      "title": "Part-time UI Designer",
      "location": "Remote",
      "type": "Part-time", // Kategori: Part-time
      "date": "Dün",
    },
  ];

  // 🔹 2. FİLTRELEME MANTIĞI (SİHİRLİ FONKSİYON)
  List<Map<String, dynamic>> getFilteredJobs() {
    return allJobPostings.where((job) {
      // A. Arama Kriteri (Büyük/küçük harf duyarsız)
      final searchLower = searchText.toLowerCase();
      final titleMatch = job['title'].toLowerCase().contains(searchLower);
      final companyMatch = job['company'].toLowerCase().contains(searchLower);
      final matchesSearch = titleMatch || companyMatch;

      // B. Kategori Kriteri
      bool matchesCategory = true;
      if (selectedCategory != "Tümü") {
        if (selectedCategory == "Staj") {
          // İçinde "Staj" kelimesi geçen her şeyi kabul et (Yaz Stajı, Zorunlu Staj)
          matchesCategory = job['type'].toString().contains("Staj");
        } else if (selectedCategory == "Remote") {
          // Konum veya tipte Remote yazıyorsa
          matchesCategory = job['location'].toString().contains("Remote");
        } else {
          // Tam Zamanlı, Part-time gibi birebir eşleşmeler
          matchesCategory = job['type'] == selectedCategory;
        }
      }

      // Hem arama hem kategori uyuyorsa listeye ekle
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Filtrelenmiş listeyi alıyoruz
    final displayList = getFilteredJobs();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          // Listeyi çizdirirken artık 'displayList' kullanıyoruz
          Expanded(
            child: displayList.isEmpty
                ? _buildEmptyState() // Eğer sonuç yoksa uyarı göster
                : _buildJobList(displayList),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        "İş & Staj İlanları",
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
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
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        children: [
          // Arama Çubuğu
          TextField(
            // 🔹 3. ARAMA YAPILDIĞINDA TETİKLE
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Pozisyon veya şirket ara...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Filtre Butonları
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("Tümü"),
                _buildFilterChip("Staj"),
                _buildFilterChip("Tam Zamanlı"),
                _buildFilterChip("Part-time"),
                _buildFilterChip("Remote"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 4. TIKLANINCA KATEGORİ DEĞİŞTİR
  Widget _buildFilterChip(String label) {
    bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7AD0B0) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF7AD0B0).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildJobList(List<Map<String, dynamic>> jobs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return _buildJobCard(job);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text(
            "Aradığınız kriterde ilan bulunamadı.",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: job['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  job['logo'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: job['color'],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['company'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.bookmark_border, color: Colors.grey.shade400),
            ],
          ),

          const Divider(height: 25, thickness: 0.5),

          Row(
            children: [
              _buildJobTag(Icons.location_on_outlined, job['location']),
              const SizedBox(width: 12),
              _buildJobTag(Icons.work_outline, job['type']),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                job['date'],
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  minimumSize: const Size(100, 36),
                ),
                child: const Text(
                  "Başvur",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobTag(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
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
    );
  }
}
