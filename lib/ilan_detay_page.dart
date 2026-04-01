import 'package:flutter/material.dart';

class IlanDetayPage extends StatelessWidget {
  final Map<String, dynamic> job;

  // Ana renk paleti (IsStajPage ile uyumlu olması için)
  final Color kPrimaryColor = const Color(0xFFA65DD4);

  IlanDetayPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    // Şirket baş harfi ve logo rengi için hazırlık
    String companyFirstLetter = job['company']?[0].toUpperCase() ?? "?";

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      // ⭐ APPBAR: Şık ve sade
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          job['title'] ?? "İlan Detayı",
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ ÜST KISIM (Header Card)
            _buildHeaderCard(companyFirstLetter),

            const SizedBox(height: 10),

            // ⭐ DETAY BİLGİLERİ (Body)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Pozisyon Açıklaması"),
                  _buildContentText(job['description'] ?? "Açıklama bulunmuyor."),

                  const SizedBox(height: 25),

                  _buildSectionTitle("Aranan Nitelikler"),
                  _buildContentText(job['requirements'] ?? "Nitelik belirtilmedi."),

                  const SizedBox(height: 25),

                  _buildSectionTitle("İlan Detayları"),
                  _buildDetailTile(Icons.assignment_ind_outlined, "Çalışma Türü:", job['type'] ?? "Belirtilmedi"),
                  _buildDetailTile(Icons.timer_outlined, "Staj Süresi:", job['duration'] ?? "Belirtilmedi"),

                  const SizedBox(height: 30),

                  // ⭐ SON BAŞVURU KARTI
                  _buildDeadlineCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Yardımcı Widgetlar ---

  Widget _buildHeaderCard(String firstLetter) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          // Şirket Logosu/Baş Harfi
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                firstLetter,
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Şirket Adı
          Text(
            job['company'] ?? "Şirket Bilgisi Yok",
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15),
          // Lokasyon Badgesı
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                job['location'] ?? "Belirtilmedi",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Container(
          width: 50,
          height: 3,
          margin: const EdgeInsets.only(top: 5, bottom: 12),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        )
      ],
    );
  }

  Widget _buildContentText(String content) {
    return Text(
      content,
      style: const TextStyle(
          fontSize: 15, color: Colors.black54, height: 1.5),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: kPrimaryColor.withOpacity(0.7)),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15, color: Colors.black54))),
        ],
      ),
    );
  }

  Widget _buildDeadlineCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: kPrimaryColor),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Başvuru Bitiş Tarihi:",
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            job['deadline'] ?? "Süresiz",
            style: TextStyle(
                color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}