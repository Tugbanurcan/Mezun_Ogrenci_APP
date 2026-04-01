import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ilan_detay_page.dart';
import 'is_staj_ekle_page.dart';
import 'widgets/bottom_nav_bar.dart';
import 'home_page.dart';
import 'mentor_bul_page.dart';
import 'etkinlikler_page.dart';
import 'chat_page.dart';

class IsStajPage extends StatefulWidget {
  const IsStajPage({super.key});

  @override
  State<IsStajPage> createState() => _IsStajPageState();
}

class _IsStajPageState extends State<IsStajPage> {
  final int _currentIndex = 4;

  // Renk tanımlamaları (Hata almamak için burada tutuyoruz)
  final Color kPrimaryColor = const Color(0xFFA65DD4);
  final Color kSecondaryColor = const Color(0xFF7AD0B0);

  String userType = "Mezun";
  String selectedCategory = "Tümü";
  String searchText = "";

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    Widget nextStep;
    switch (index) {
      case 0: nextStep = const ChatPage(); break;
      case 1: nextStep = const EtkinliklerPage(); break;
      case 2: nextStep = const AnaSayfa(); break;
      case 3: nextStep = const MentorBulPage(); break;
      default: return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => nextStep));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("İş & Staj İlanları",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      floatingActionButton: userType == "Mezun"
          ? FloatingActionButton(
        backgroundColor: kSecondaryColor,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IsStajEklePage())),
      )
          : null,
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('job_postings')
                  .where('status', isEqualTo: 'approved')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text("Bir hata oluştu."));

                // ⭐ HATALI SATIR BURADA DÜZELTİLDİ (const kaldırıldı)
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: kPrimaryColor));
                }

                final docs = snapshot.data!.docs;
                final filteredDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = data['title']?.toString().toLowerCase() ?? "";
                  final company = data['company']?.toString().toLowerCase() ?? "";
                  final matchesSearch = title.contains(searchText.toLowerCase()) ||
                      company.contains(searchText.toLowerCase());

                  bool matchesCategory = (selectedCategory == "Tümü") || (data['type'] == selectedCategory);
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredDocs.isEmpty) return _buildEmptyState();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final data = filteredDocs[index].data() as Map<String, dynamic>;
                    return _buildJobCard(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _currentIndex, onTap: _onItemTapped),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => setState(() => searchText = value),
            decoration: InputDecoration(
              hintText: "Pozisyon veya şirket ara...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 22),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["Tümü", "Staj", "Tam Zamanlı", "Part-time", "Remote"]
                  .map((cat) => _buildFilterChip(cat)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kSecondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Text(label,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IlanDetayPage(job: job))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
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
                    color: kPrimaryColor.withValues(alpha: 0.1), // ⭐ withOpacity uyarısı düzeltildi
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(job['company']?[0].toUpperCase() ?? "İ",
                        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['title'] ?? "Başlıksız",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87)),
                      Text(job['company'] ?? "Şirket Bilgisi Yok",
                          style: const TextStyle(color: Colors.black54, fontSize: 14)),
                    ],
                  ),
                ),
                const Icon(Icons.bookmark_border, color: Colors.grey),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(height: 1, color: Color(0xFFF1F1F1)),
            ),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job['location'] ?? "Belirtilmedi", style: const TextStyle(fontSize: 13, color: Colors.black54)),
                const SizedBox(width: 20),
                const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Son: ${job['deadline'] ?? "Süresiz"}", style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("İlan Aktif", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IlanDetayPage(job: job))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: const Text("İncele", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text("Henüz uygun bir ilan bulunmuyor.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}