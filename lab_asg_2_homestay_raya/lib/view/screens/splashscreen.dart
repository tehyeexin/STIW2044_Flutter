import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab_asg_2_homestay_raya/config.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/startlogin.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/mainscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loginCheck();
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

  Future<void> loginCheck() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String _email = (pref.getString('email')) ?? '';
    String _pass = (pref.getString('pass')) ?? '';
    if (_email.isNotEmpty) {
      http.post(Uri.parse("${Config.SERVER}/homestayraya/php/login_user.php"),
          body: {"email": _email, "password": _pass}).then((response) {
        var jsonResponse = json.decode(response.body);
        if (response.statusCode == 200 && jsonResponse['status'] == "success") {
          //var jsonResponse = json.decode(response.body);
          User user = User.fromJson(jsonResponse['data']);
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(user: user))));
        } else {
          User user = User(
              id: "0",
              email: "unregistered",
              name: "unregistered",
              phone: "",
              regdate: "0");
          Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) => const StartLoginScreen())));
        }
      }).timeout(const Duration(seconds: 5));
    } else {
      User user = User(
          id: "0",
          email: "unregistered",
          name: "unregistered",
          phone: "",
          regdate: "0");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => const StartLoginScreen())));
    }
  }
}
