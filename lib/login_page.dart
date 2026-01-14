import 'package:flutter/material.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'etkinlikler_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ---------------------------
              // Hoş Geldin yazısının üst boşluğu
              // ---------------------------
              SizedBox(
                height: 10,
              ), // Bunu değiştirerek yukarı/aşağı ayarlayabilirsin
              Text(
                "Hoş Geldin",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),

              const SizedBox(height: 100),
              // ---------------------------
              // Kullanıcı Adı
              // ---------------------------
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Kullanıcı Adı",
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 25),
              // ---------------------------
              // Şifre
              // ---------------------------
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Şifre",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 40),
              // ---------------------------
              // Giriş Butonu
              // ---------------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AnaSayfa()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Giriş Yap",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),

              // ---------------------------
              // “Hesabın yok mu? Kayıt ol” butonunun üst boşluğu
              // ---------------------------
              SizedBox(
                height: 50,
              ), // Bunu değiştirerek boşluğu ayarlayabilirsin
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  );
                },
                child: const Text(
                  "Hesabın yok mu? Kayıt ol",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
