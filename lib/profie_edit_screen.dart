import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  // Sabitler
  static const double _padding = 20.0;
  static const double _avatarSize = 100.0;
  static const double _spacingMedium = 16.0;

  // TextEditingController'lar tanımlanıyor
  late final TextEditingController _nameController;
  late final TextEditingController _titleController;
  late final TextEditingController _aboutController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _githubController;
  late final TextEditingController _educationController;
  File? _profileImage; // Seçilen profil fotoğrafı
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Riverpod'dan ilk değerleri al ve controller'lara ata
    final initialData = ref.read(userProfileNotifierProvider);

    _nameController = TextEditingController(text: initialData.name);
    _titleController = TextEditingController(text: initialData.title);
    _aboutController = TextEditingController(text: initialData.about);
    _linkedinController = TextEditingController(text: initialData.linkedin);
    _githubController = TextEditingController(text: initialData.github);
    _educationController = TextEditingController(text: initialData.education);
  }

  @override
  void dispose() {
    // Controller'ları temizleme
    _nameController.dispose();
    _titleController.dispose();
    _aboutController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    ref.read(userProfileNotifierProvider.notifier).updateProfile(
      name: _nameController.text,
      title: _titleController.text,
      about: _aboutController.text,
      linkedin: _linkedinController.text,
      github: _githubController.text,
      education: _educationController.text,
      photoPath: _profileImage?.path, // Yeni eklenen profil fotoğrafı
    );

    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Galeriden seçmek için
      maxWidth: 600, // Resim boyutunu optimize etmek için
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: _spacingMedium),
            _buildProfileAvatar(),
            const SizedBox(height: _spacingMedium),
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: _avatarSize,
            height: _avatarSize,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
              image: _profileImage != null
                  ? DecorationImage(
                image: FileImage(_profileImage!),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: _profileImage == null
                ? const Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.blueAccent,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField('Ad Soyad', _nameController),
          const SizedBox(height: _spacingMedium),
          _buildTextField('Başlık', _titleController),
          const SizedBox(height: _spacingMedium),
          _buildTextField('Hakkında', _aboutController, maxLines: 4),
          const SizedBox(height: _spacingMedium),
          _buildSocialLinks(),
          const SizedBox(height: _spacingMedium),
          _buildTextField('Eğitim', _educationController),
          const SizedBox(height: _spacingMedium * 2),
          Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 172, 93, 192),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Değişiklikleri Kaydet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label, // Bu üstte yüzen yazı
        floatingLabelBehavior:
        FloatingLabelBehavior.auto, // üstte görünmesini sağlar
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Row(
        children: [
    Expanded(
    child: _buildTextField('LinkedIn', _linkedinController),
    ),
    const SizedBox(width: 10),
    Expanded(
    child: _buildTextField('GitHub', _githubController),
    ),
    ],
    );
    }
}
