import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

const Color kPrimaryColor = Color(0xFFA65DD4);
const Color kBackgroundColor = Color(0xFFF8F9FA);

class MentorProfilPage extends StatefulWidget {
  final String isim;
  final String unvan;
  final String sirket;
  final String yil;
  final String aciklama;
  final String fotoUrl;
  final String linkedin;
  final String github;
  final String hakkinda;
  final List<String> yetkinlikler;
  final String iletisim;

  const MentorProfilPage({
    super.key,
    required this.isim,
    required this.unvan,
    required this.sirket,
    required this.yil,
    required this.aciklama,
    this.fotoUrl = "",
    this.linkedin = "",
    this.github = "",
    this.hakkinda = "",
    this.yetkinlikler = const [],
    required this.iletisim,
  });

  @override
  State<MentorProfilPage> createState() => _MentorProfilPageState();
}

class _MentorProfilPageState extends State<MentorProfilPage> {
  String? _currentPhoto;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Eğer network fotoğraf varsa
    if (widget.fotoUrl.isNotEmpty) {
      _currentPhoto = widget.fotoUrl;
    }
  }

  Future<void> _pickImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 85,
    );

    if (file != null) {
      setState(() {
        _pickedImage = File(file.path);
        _currentPhoto = file.path; // Yeni foto yolu
      });
    }
  }

  void _removePhoto() {
    setState(() {
      _pickedImage = null;
      _currentPhoto = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // ------------------ ÜST KISIM ------------------
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: size.height * 0.28,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(25, 105, 27, 154), kPrimaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),

                Positioned(
                  bottom: -60,
                  child: Stack(
                    children: [
                      // Profil Fotoğrafı
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage!)
                              : (widget.fotoUrl.isNotEmpty
                                        ? NetworkImage(widget.fotoUrl)
                                        : null)
                                    as ImageProvider?,
                          child: (_currentPhoto == null)
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey.shade400,
                                )
                              : null,
                        ),
                      ),

                      // Fotoğraf Değiştirme (Kamera)
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

                      // Fotoğraf Silme Butonu
                      if (_currentPhoto != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _removePhoto,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70),

            // ------------------ İSİM + SOSYAL ------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          widget.isim,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      if (widget.linkedin.isNotEmpty ||
                          widget.github.isNotEmpty) ...[
                        const SizedBox(width: 10),

                        if (widget.linkedin.isNotEmpty)
                          _smallIcon(
                            FontAwesomeIcons.linkedinIn,
                            const Color(0xFF0077B5),
                            "https://www.linkedin.com/in/${widget.linkedin}",
                          ),

                        if (widget.linkedin.isNotEmpty &&
                            widget.github.isNotEmpty)
                          const SizedBox(width: 8),

                        if (widget.github.isNotEmpty)
                          _smallIcon(
                            FontAwesomeIcons.github,
                            const Color(0xFF333333),
                            "https://github.com/${widget.github}",
                          ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "${widget.yil} • ${widget.unvan} @ ${widget.sirket}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ------------------ HAKKINDA ------------------
            _buildCard(
              icon: Icons.info_outline,
              title: "Hakkında",
              child: Text(
                widget.hakkinda.isNotEmpty ? widget.hakkinda : widget.aciklama,
                style: TextStyle(color: Colors.grey.shade700, height: 1.5),
              ),
            ),

            // ------------------ YETKİNLİKLER ------------------
            _buildCard(
              icon: Icons.star_border,
              title: "Yetkinlikler",
              child: _buildSkills(widget.yetkinlikler),
            ),

            // ------------------ İLETİŞİM ------------------
            _buildCard(
              icon: Icons.mail_outline,
              title: "İletişim",
              child: Text(
                widget.iletisim.isEmpty
                    ? "Email belirtilmemiş."
                    : widget.iletisim,
                style: TextStyle(color: Colors.grey.shade700, height: 1.5),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // ------------------ YARDIMCI WIDGETLAR ------------------

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kPrimaryColor),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Divider(height: 25, thickness: 0.5),
          child,
        ],
      ),
    );
  }

  Widget _buildSkills(List<String> skills) {
    if (skills.isEmpty) {
      return const Text(
        "Bu mentor henüz yetkinlik eklememiş.",
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
          ),
          child: Text(
            skill,
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _smallIcon(IconData icon, Color color, String url) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(child: FaIcon(icon, size: 16, color: color)),
      ),
    );
  }
}
