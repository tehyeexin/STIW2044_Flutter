import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/mainscreen.dart';
import '../../models/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
     Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => MainScreen(user: user))));
    //autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splashscreen.jpg'),
                    fit: BoxFit.cover))),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "HOMESTAY RAYA",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown),
              ),
              Padding(padding: EdgeInsets.all(12)),
              Text(
                "Find your best homestay!",
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.brown),
              ),
              Padding(padding: EdgeInsets.all(32)),
              CircularProgressIndicator()
            ],
          ),
        )
      ],
    );
  }
}
