import 'package:flutter/material.dart';
import 'package:near_me/Screens/homePage.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then((val) {
      _navigateToHome();
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(seconds: 3), () {});
    return true;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/background.jpg'),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(tag: "logo", child: Image.asset('assets/splash.png')),
                SizedBox(
                  height: 10.0,
                ),
                Shimmer.fromColors(
                  period: Duration(milliseconds: 1500),
                  baseColor: Colors.orange,
                  highlightColor: Color(0xffe100ff),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Near Me",
                      style: TextStyle(
                        fontSize: 100.0,
                        fontFamily: 'Economica',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
