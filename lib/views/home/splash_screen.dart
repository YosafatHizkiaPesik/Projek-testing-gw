import 'package:flutter/material.dart';
import '../auth/login_page.dart';
import '../../controllers/auth_controller.dart';
import '../home/dashboard_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  _navigateToNextPage() async {
    await Future.delayed(Duration(seconds: 3));  

    bool isLoggedIn = await AuthController().isUserLoggedIn();
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashboardPage()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'DWI JAYA',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            CircularProgressIndicator()
          ],
        ),
      ),
      backgroundColor: Color(0xFF009CFF), 
    );
  }
}
