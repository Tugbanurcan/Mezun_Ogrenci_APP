import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
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

  void register() {
    if (_formKey.currentState!.validate()) {
      // Backend’e gönderilecek veriler
      print("Kullanıcı Adı: ${usernameController.text}");
      print("Şifre: ${passwordController.text}");
      print("Kullanıcı Tipi: $selectedUserType");
      print("Mentör mü?: $isMentor");

      // Modern popup dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 60,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Başarılı!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Kayıt işleminiz başarıyla tamamlandı.",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Dialog kapat
                        Navigator.pop(context); // Login sayfasına dön
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      child: const Text(
                        "Tamam",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

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
                const SizedBox(height: 40),

                // Kullanıcı Adı
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Kullanıcı Adı",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? "Kullanıcı adı giriniz"
                      : null,
                ),
                const SizedBox(height: 20),

                // 🔒 Şifre (göz ikonlu)
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
                const SizedBox(height: 20),

                // 🔒 Şifre (Tekrar) (göz ikonlu)
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
                const SizedBox(height: 20),

                // Kullanıcı Tipi Seçimi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    userTypeSelector("Öğrenci"),
                    userTypeSelector("Mezun"),
                  ],
                ),
                const SizedBox(height: 20),

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
                const SizedBox(height: 10),

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

                // Giriş sayfasına dön
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
