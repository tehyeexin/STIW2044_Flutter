import 'package:flutter/material.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/loginscreen.dart';

class StartLoginScreen extends StatefulWidget {
  const StartLoginScreen({super.key});

  @override
  State<StartLoginScreen> createState() => _StartLoginState();
}

class _StartLoginState extends State<StartLoginScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  double screenHeight = 0.0, screenWidth = 0.0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splashscreen.jpg'),
                    fit: BoxFit.cover))),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 50),
            const Text(
              "HOMESTAY RAYA",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shadowColor: Colors.black,
                  fixedSize: Size(screenWidth / 2, screenHeight / 15),
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScreen()))
              },
              child: const Text('Login',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}
