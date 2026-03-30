import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // kIsWeb için

const Color kPrimaryColor = Color(0xFFA65DD4);

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

  XFile? _pickedImage; // File? yerine XFile?
  String? _currentPhotoPath;
  bool _isLoading = false;

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
          : userEmail,
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
        _pickedImage = pickedFile;
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (uid.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
    String? photoUrl = _currentPhotoPath;

    try {
      if (_pickedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_photos')
            .child('$uid.jpg');

        if (kIsWeb) {
          final bytes = await _pickedImage!.readAsBytes();
          await storageRef.putData(
            bytes,
            SettableMetadata(contentType: 'image/jpeg'),
          );
        } else {
          await storageRef.putFile(File(_pickedImage!.path));
        }

        photoUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': _nameController.text.trim(),
        'title': _titleController.text.trim(),
        'about': _aboutController.text.trim(),
        'linkedin': _linkedinController.text.trim(),
        'github': _githubController.text.trim(),
        'education': _educationController.text.trim(),
        'communication': _communicationController.text.trim(),
        'photoUrl': photoUrl,
        'lastUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

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
            photoPath: photoUrl,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil başarıyla kaydedildi!'),
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
                'E-posta / Telefon',
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
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
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
      if (kIsWeb) {
        imageProvider = NetworkImage(_pickedImage!.path);
      } else {
        imageProvider = FileImage(File(_pickedImage!.path));
      }
    } else if (_currentPhotoPath != null) {
      imageProvider = NetworkImage(_currentPhotoPath!);
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
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
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
