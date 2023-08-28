import 'package:flutter/material.dart';
import 'package:good_login/good_login.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../controllers/auth_controller.dart';
import '../home/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController _authController = AuthController();

  void _submitLogin(BuildContext context) async {
  try {
    await _authController.login(
      _usernameController.text,
      _passwordController.text,
      '123456' // Logika IMEI Nanti
    );

    // Jika login berhasil, tampilkan Awesome Snackbar dan redirect ke DashboardPage.
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success!',
        message: 'Login berhasil!',
        contentType: ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)..showSnackBar(snackBar);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()),
    );
  } catch (e) {
    // Jika terjadi kesalahan saat login, tampilkan pesan kesalahan.
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Error!',
        message: e.toString(),
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)..showSnackBar(snackBar);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const SizedBox(height: 90),
                Text(
                  'UD. DWI JAYA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF009CFF),
                  ),
                ),
                const SizedBox(height: 20),
                GoodLogin(
                  color: Colors.blue[300],
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                  onPressed: () => _submitLogin(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
