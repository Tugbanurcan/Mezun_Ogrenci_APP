import 'package:flutter/material.dart';

// Projenin ana renk paleti (Mor)
const Color kPrimaryColor = Color.fromARGB(192, 0, 0, 0);
// Arka plan rengi (IsStajPage ile aynı)
const Color kBackgroundColor = Color(0xFFF9F9F9);

class IsStajEklePage extends StatefulWidget {
  const IsStajEklePage({super.key});

  @override
  State<IsStajEklePage> createState() => _IsStajEklePageState();
}

class _IsStajEklePageState extends State<IsStajEklePage> {
  // Form anahtarı (Validasyon işlemleri için)
  final _formKey = GlobalKey<FormState>();

  // Veri Giriş Kontrolcüleri
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Seçilen İlan Türü (Varsayılan: Staj)
  String _selectedType = 'Staj';

  @override
  void dispose() {
    // Sayfa kapandığında bellek temizliği
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _savePost() {
    if (_formKey.currentState!.validate()) {
      // ---------------------------------------------------------
      // BURAYA İLERİDE DATABASE KAYIT KODLARI GELECEK (Firebase vb.)
      // Şimdilik sadece simülasyon yapıyoruz.
      // ---------------------------------------------------------

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('İlan başarıyla oluşturuldu ve onaya gönderildi!'),
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 2),
        ),
      );

      // İşlem bitince sayfayı kapatıp geri dön
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Yeni İlan Oluştur",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BİLGİLENDİRME KARTI
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: kPrimaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Eklediğiniz ilanlar, yönetici onayından geçtikten sonra 'İş & Staj' sayfasında yayınlanacaktır.",
                        style: TextStyle(
                          color: kPrimaryColor.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              const Text(
                "İlan Detayları",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 15),

              // 1. BAŞLIK
              _buildCustomTextField(
                controller: _titleController,
                label: "Pozisyon / İlan Başlığı",
                hint: "Örn: Flutter Geliştirici Stajyeri",
                icon: Icons.title,
              ),
              const SizedBox(height: 15),

              // 2. ŞİRKET ADI
              _buildCustomTextField(
                controller: _companyController,
                label: "Şirket Adı",
                hint: "Örn: Teknoloji A.Ş.",
                icon: Icons.business,
              ),
              const SizedBox(height: 15),

              // 3. İLAN TÜRÜ SEÇİMİ (Chips)
              const Text(
                "Çalışma Türü",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTypeChip("Staj"),
                    const SizedBox(width: 10),
                    _buildTypeChip("Tam Zamanlı"),
                    const SizedBox(width: 10),
                    _buildTypeChip("Yarı Zamanlı"),
                    const SizedBox(width: 10),
                    _buildTypeChip("Remote"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. KONUM
              _buildCustomTextField(
                controller: _locationController,
                label: "Konum",
                hint: "Örn: İstanbul (Maslak) / Uzaktan",
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 15),

              // 5. SON BAŞVURU TARİHİ (Opsiyonel manuel giriş şimdilik)
              _buildCustomTextField(
                controller: _dateController,
                label: "Son Başvuru Tarihi",
                hint: "Örn: 30 Aralık 2025",
                icon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 15),

              // 6. AÇIKLAMA
              _buildCustomTextField(
                controller: _descriptionController,
                label: "İlan Açıklaması & Şartlar",
                hint: "Aranan nitelikleri ve iş tanımını detaylıca yazınız...",
                icon: Icons.description_outlined,
                maxLines: 5,
              ),

              const SizedBox(height: 30),

              // KAYDET BUTONU
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    elevation: 5,
                    shadowColor: kPrimaryColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _savePost,
                  child: const Text(
                    "İlanı Yayınla",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Yardımcı Widget: Özel Text Alanı
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label boş bırakılamaz.";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, color: kPrimaryColor.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  // Yardımcı Widget: Seçim Kutucuğu (Chip)
  Widget _buildTypeChip(String label) {
    bool isSelected = _selectedType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kPrimaryColor : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.3),
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
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
