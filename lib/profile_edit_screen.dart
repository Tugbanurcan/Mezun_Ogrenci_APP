import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'etkinlikler_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Renk sabitleri
const Color kPrimaryColor = Color(0xFFA65DD4);
bool _isLoading = false;

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _titleController;
  late final TextEditingController _aboutController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _githubController;
  late final TextEditingController _educationController;
  late final TextEditingController _communicationController;

  File? _pickedImage;
  String? _currentPhotoPath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    final initialData = ref.read(userProfileNotifierProvider);
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "";

    _nameController = TextEditingController(text: initialData.name);

    _titleController = TextEditingController(text: initialData.title);

    _aboutController = TextEditingController(text: initialData.about);

    _linkedinController = TextEditingController(text: initialData.linkedin);

    _githubController = TextEditingController(text: initialData.github);

    _educationController = TextEditingController(text: initialData.education);

    _communicationController = TextEditingController(
      text: initialData.communication.isNotEmpty
          ? initialData.communication
          : userEmail, // Firebase mail otomatik gelir
    );

    _currentPhotoPath = initialData.photoPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _aboutController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _educationController.dispose();
    _communicationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true); // İsteğe bağlı: Loading ekleyebilirsin

    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (uid.isEmpty) return;

    String? photoPath = _currentPhotoPath;

    if (_pickedImage != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(_pickedImage!.path);
      final savedImage = await _pickedImage!.copy(
        '${directory.path}/$fileName',
      );
      photoPath = savedImage.path;
    }

    try {
      // 1. ADIM: VERİTABANINI (FIRESTORE) GÜNCELLE
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': _nameController.text.trim(),
        'title': _titleController.text.trim(),
        'about': _aboutController.text.trim(),
        'linkedin': _linkedinController.text.trim(),
        'github': _githubController.text.trim(),
        'education': _educationController.text.trim(),
        'communication': _communicationController.text.trim(),
        'photoPath':
            photoPath, // Not: Resimler için ilerde Firebase Storage kullanmalısın
        'lastUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Sadece değişen alanları üzerine yazar

      // 2. ADIM: RIVERPOD'U (YEREL DURUM) GÜNCELLE
      ref
          .read(userProfileNotifierProvider.notifier)
          .updateProfile(
            name: _nameController.text.trim(),
            title: _titleController.text.trim(),
            about: _aboutController.text.trim(),
            linkedin: _linkedinController.text.trim(),
            github: _githubController.text.trim(),
            education: _educationController.text.trim(),
            communication: _communicationController.text.trim(),
            photoPath: photoPath,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil başarıyla buluta kaydedildi!'),
            backgroundColor: Colors.green,
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profili Düzenle',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 30),
              _buildSectionHeader("Kişisel Bilgiler"),
              _buildTextField('Ad Soyad', _nameController, Icons.person),

              const SizedBox(height: 30),
              _buildTextField('Unvan', _titleController, Icons.work),
              const SizedBox(height: 30),
              _buildTextField(
                'Hakkında',
                _aboutController,
                Icons.info_outline,
                maxLines: 4,
              ),
              const SizedBox(height: 40),
              _buildSectionHeader("Eğitim"),
              _buildTextField(
                'Okul / Bölüm',
                _educationController,
                Icons.school,
              ),

              const SizedBox(height: 40),

              _buildSectionHeader("İletişim"),
              _buildTextField(
                'Okul / Bölüm',
                _communicationController,
                Icons.mail,
              ),

              const SizedBox(height: 40),

              _buildSectionHeader("Sosyal Medya"),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'LinkedIn',
                      _linkedinController,
                      FontAwesomeIcons.linkedin,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTextField(
                      'GitHub',
                      _githubController,
                      FontAwesomeIcons.github,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Değişiklikleri Kaydet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    ImageProvider? imageProvider;
    if (_pickedImage != null) {
      imageProvider = FileImage(_pickedImage!);
    } else if (_currentPhotoPath != null) {
      imageProvider = FileImage(File(_currentPhotoPath!));
    }

    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              image: imageProvider != null
                  ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                  : null,
            ),
            child: imageProvider == null
                ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      // Hint text özelliğini kaldırdık çünkü artık varsayılan text var
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 22),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
        ),
      ),
    );
  }
}
