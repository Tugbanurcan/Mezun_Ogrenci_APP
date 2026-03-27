import 'package:flutter/material.dart';

class IlanDetayPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const IlanDetayPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "İlan Detay Sayfası",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏢 LOGO VE ŞİRKET ADI (Taslaktaki Üst Kısım)
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color:
                        job['color']?.withOpacity(0.1) ?? Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  alignment: Alignment.center,
                  child: job['logo'] != null
                      ? Text(
                          job['logo'],
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: job['color'],
                          ),
                        )
                      : const Icon(
                          Icons.business,
                          size: 40,
                          color: Colors.grey,
                        ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    job['company'] ?? "Şirket Bilgisi Yok",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 📝 DETAY BLOKLARI (Çizimindeki Sıralama)
            _buildDetailBlock(
              "Pozisyon Başlığı:",
              job['title'] ?? "Belirtilmedi",
            ),
            _buildDetailBlock("Lokasyon:", job['location'] ?? "Belirtilmedi"),
            _buildDetailBlock(
              "Staj Süresi:",
              job['duration'] ?? "Belirtilmedi",
            ),
            _buildDetailBlock(
              "Pozisyon Açıklaması:",
              job['description'] ?? "Açıklama bulunmuyor.",
            ),
            _buildDetailBlock(
              "Aranan Nitelikler:",
              job['requirements'] ?? "Nitelik belirtilmedi.",
            ),
            _buildDetailBlock(
              "Başvuru Bitiş Tarihi:",
              job['deadline'] ?? "Süresiz",
            ),

            const SizedBox(height: 30),

            // 🚀 EYLEM BUTONU
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Başvuru işlemi burada yapılacak (örneğin, bir API çağrısı veya başka bir sayfaya yönlendirme)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Şimdi Başvur",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Taslaktaki Başlık ve Alt Metin Yapısı İçin Yardımcı Widget
  Widget _buildDetailBlock(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.5, // Satır aralığı ferahlığı için
            ),
          ),
        ],
      ),
    );
  }
}
