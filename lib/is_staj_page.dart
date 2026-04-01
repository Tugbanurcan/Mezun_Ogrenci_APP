import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔹 Firestore eklendi
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

  // 🔹 Kullanıcı Tipi (Giriş yapan kullanıcının verisinden çekilmeli)
  String userType = "Mezun";

  // 🔹 Filtreleme Değişkenleri
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
      appBar: _buildAppBar(),

      // ⭐ Mezun ise Ekleme Butonu Görünür
      floatingActionButton: userType == "Mezun"
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF7AD0B0),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IsStajEklePage())),
      )
          : null,

      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            // ⭐ FIRESTORE BAĞLANTISI BURADA BAŞLIYOR
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('job_postings')
                  .where('status', isEqualTo: 'approved') // 🔹 Sadece admin onaylıları getir
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Center(child: Text("Bir hata oluştu."));
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

                // Verileri filtreleme fonksiyonuna gönderiyoruz
                final docs = snapshot.data!.docs;
                final filteredDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = data['title']?.toString().toLowerCase() ?? "";
                  final company = data['company']?.toString().toLowerCase() ?? "";

                  final matchesSearch = title.contains(searchText.toLowerCase()) || company.contains(searchText.toLowerCase());

                  bool matchesCategory = true;
                  if (selectedCategory != "Tümü") {
                    matchesCategory = (data['type'] == selectedCategory);
                  }
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredDocs.isEmpty) return _buildEmptyState();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
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

  // --- Görsel Widgetlar (Aynı Tasarım) ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text("İş & Staj İlanları", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      centerTitle: true,
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
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7AD0B0) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.w600)),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: Text(job['company']?[0] ?? "İ", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job['title'] ?? "Başlıksız", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(job['company'] ?? "Şirket Bilgisi Yok", style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.bookmark_border, color: Colors.grey),
            ],
          ),
          const Divider(height: 25),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(job['location'] ?? "Belirtilmedi", style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 15),
              const Icon(Icons.work_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(job['type'] ?? "Belirtilmedi", style: const TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("İlan Aktif", style: TextStyle(color: Colors.green, fontSize: 12)),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black87),
                child: const Text("Başvur", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("Henüz onaylanmış bir ilan bulunmuyor."));
  }
}