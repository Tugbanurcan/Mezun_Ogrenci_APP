import 'package:flutter/material.dart';
import 'etkinlikler_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isMentor = false; // Mentör checkbox durumu
  String selectedUserType = "Öğrenci"; // Kullanıcı tipi

  // 🔒 Göz ikonları için değişkenler
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Şifre giriniz";
    if (value.length < 6) return "En az 6 karakter olmalı";
    if (!RegExp(r'[A-Z]').hasMatch(value)) return "En az 1 büyük harf olmalı";
    if (!RegExp(r'[a-z]').hasMatch(value)) return "En az 1 küçük harf olmalı";
    if (!RegExp(r'[0-9]').hasMatch(value)) return "En az 1 rakam olmalı";
    return null;
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Firebase Auth ile kullanıcı oluştur
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: usernameController.text.trim(),
              password: passwordController.text.trim(),
            );

        // Firestore'a kullanıcı bilgisi kaydet
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              "name": usernameController.text.split("@")[0],
              "email": usernameController.text.trim(),
              "userType": selectedUserType,
              "isMentor": isMentor,
              "createdAt": Timestamp.now(),
            });

        // Başarılı popup
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Başarılı"),
            content: const Text("Kayıt başarıyla oluşturuldu"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Tamam"),
              ),
            ],
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "Kayıt hatası")));
      }
    }
  }

  Widget userTypeSelector(String type) {
    bool isSelected = selectedUserType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUserType = type;
          if (type != "Mezun") isMentor = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    // ✨ Boşlukları tek yerden ayarlayabilirsin
    const double gapSmall = 30;
    const double Small = 20;
    const double gapMedium = 25;
    const double Medium = 50;
    const double gapLarge = 40;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),

                SizedBox(height: gapLarge),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Ad Soyad",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Adınızı giriniz" : null,
                ),
                // Kullanıcı Adı
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Kullanıcı adı giriniz"
                      : null,
                ),

                SizedBox(height: gapMedium),

                // Şifre
                TextFormField(
                  controller: passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: validatePassword,
                ),

                SizedBox(height: gapMedium),

                // Şifre Tekrar
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Şifre (Tekrar)",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return "Şifreler eşleşmiyor";
                    }
                    return validatePassword(value);
                  },
                ),

                SizedBox(height: Medium),

                // Kullanıcı Tipi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    userTypeSelector("Öğrenci"),
                    SizedBox(width: 15),
                    userTypeSelector("Mezun"),
                  ],
                ),

                SizedBox(height: gapMedium),

                // Mentör Checkbox
                if (selectedUserType == "Mezun")
                  CheckboxListTile(
                    title: const Text("Mentör olmak istiyorum"),
                    value: isMentor,
                    onChanged: (value) {
                      setState(() {
                        isMentor = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                SizedBox(height: Small),

                // Kayıt Ol Butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: register,
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: gapSmall),

                // Girişe dön
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Zaten hesabın var mı? Giriş yap",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
