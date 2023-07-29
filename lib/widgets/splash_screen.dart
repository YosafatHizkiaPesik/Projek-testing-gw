import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dwijaya_sales_app/utils/auth.dart'; // Import AuthService
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Membuat controller untuk animasi
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Mulai animasi zoom-in
    _animationController.forward();

    // Cek status login
    _checkLoginStatus();
  }

  // Fungsi untuk memeriksa apakah pengguna sudah login atau belum
  _checkLoginStatus() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn();
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacementNamed(
            isLoggedIn ? '/dashboard' : '/login'); // Alihkan berdasarkan status login
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Bersihkan controller saat selesai
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Deteksi apakah aplikasi dalam mode gelap atau terang
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Tentukan warna gradien berdasarkan mode
    final gradientColors = isDarkMode
        ? [Color(0xFF009CFF), Colors.white] // Gradien yang lebih cerah untuk mode terang
        : [Color(0xFF009CFF), Color(0xFF000033)];// Gradien yang lebih gelap untuk mode gelap

    // Tentukan warna teks berdasarkan mode
    final textColor = isDarkMode
        ? Colors.black // Teks lebih gelap untuk mode terang
        : Colors.white; // Teks lebih cerah untuk mode gelap

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            // Tampilkan teks dengan font Heebo
            child: Text(
              'DWI JAYA',
              style: GoogleFonts.heebo(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
