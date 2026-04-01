import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Tarih formatlamak için (pubspec.yaml'a eklemeyi unutma)

const Color kPrimaryColor = Color(0xFFA65DD4);
const Color kBackgroundColor = Color(0xFFF9F9F9);

class IsStajEklePage extends StatefulWidget {
  const IsStajEklePage({super.key});

  @override
  State<IsStajEklePage> createState() => _IsStajEklePageState();
}

class _IsStajEklePageState extends State<IsStajEklePage> {
  final _formKey = GlobalKey<FormState>();

  // Veri Giriş Kontrolcüleri
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedType = 'Staj';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 📅 Tarih Seçici Fonksiyonu
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Geçmiş tarihler seçilemesin
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor, // Takvim ana rengi
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Tarihi gün.ay.yıl formatında yazdırır
        _dateController.text = DateFormat('dd.MM.yyyy').format(picked);
      });
    }
  }

  // ⭐ FIRESTORE KAYIT FONKSİYONU
  Future<void> _savePost() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final String uid = FirebaseAuth.instance.currentUser!.uid;
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final String realName = userDoc.data()?['name'] ?? "Bilinmeyen Üye";

        await FirebaseFirestore.instance.collection('job_postings').add({
          'title': _titleController.text.trim(),
          'company': _companyController.text.trim(),
          'type': _selectedType,
          'location': _locationController.text.trim(),
          'deadline': _dateController.text.trim(),
          'description': _descriptionController.text.trim(),
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'userId': uid,
          'userName': realName,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('İlan onaya gönderildi!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
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
        title: const Text("Yeni İlan Oluştur",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 25),
              const Text("İlan Detayları", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              _buildCustomTextField(
                controller: _titleController,
                label: "Pozisyon / İlan Başlığı",
                hint: "Örn: Flutter Geliştirici Stajyeri",
                icon: Icons.title,
              ),
              const SizedBox(height: 15),
              _buildCustomTextField(
                controller: _companyController,
                label: "Şirket Adı",
                hint: "Örn: Teknoloji A.Ş.",
                icon: Icons.business,
              ),
              const SizedBox(height: 15),
              const Text("Çalışma Türü", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              _buildTypeSelection(),
              const SizedBox(height: 20),
              _buildCustomTextField(
                controller: _locationController,
                label: "Konum",
                hint: "Örn: İstanbul / Remote",
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 15),
              // 📅 TAKVİM TETİKLEYİCİ ALAN
              _buildCustomTextField(
                controller: _dateController,
                label: "Son Başvuru Tarihi",
                hint: "Tarih seçmek için tıklayın",
                icon: Icons.calendar_month_outlined,
                readOnly: true, // Elle yazmayı engeller
                onTap: () => _selectDate(context), // Tıklayınca takvim açılır
              ),
              const SizedBox(height: 15),
              _buildCustomTextField(
                controller: _descriptionController,
                label: "İlan Açıklaması",
                hint: "Nitelikleri ve detayları yazınız...",
                icon: Icons.description_outlined,
                maxLines: 5,
              ),
              const SizedBox(height: 30),
              _buildSubmitButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- Yardımcı Widgetlar ---

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: kPrimaryColor),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "İlanlar, yönetici onayından geçtikten sonra yayınlanacaktır.",
              style: TextStyle(color: kPrimaryColor, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ["Staj", "Tam Zamanlı", "Yarı Zamanlı", "Remote"]
            .map((type) => Padding(
          padding: const EdgeInsets.only(right: 10),
          child: _buildTypeChip(type),
        ))
            .toList(),
      ),
    );
  }

  Widget _buildTypeChip(String label) {
    bool isSelected = _selectedType == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? kPrimaryColor : Colors.grey.shade300),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: _isLoading ? null : _savePost,
        child: const Text("İlanı Yayınla",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      validator: (value) => (value == null || value.isEmpty) ? "$label boş bırakılamaz." : null,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: hint,
        prefixIcon: Icon(icon, color: kPrimaryColor.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kPrimaryColor)),
      ),
    );
  }
}