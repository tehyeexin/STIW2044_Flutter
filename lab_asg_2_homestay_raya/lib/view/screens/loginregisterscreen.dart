import 'package:flutter/material.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';
import '../shared/mainmenuwidget.dart';
import '../screens/loginscreen.dart';
import '../screens/registerscreen.dart';

class LoginRegisterScreen extends StatefulWidget {
  final User user;
  const LoginRegisterScreen({super.key, required this.user});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegisterScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  double screenHeight = 0.0, screenWidth = 0.0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: const Text("Login/Register")),
          body: Center(
              child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shadowColor: Colors.black,
                        fixedSize: Size(screenWidth / 1.3, screenHeight / 12),
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginScreen()))
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shadowColor: Colors.black,
                        fixedSize: Size(screenWidth / 1.3, screenHeight / 12),
                        textStyle: const TextStyle(fontSize: 20)),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const RegisterScreen()))
                    },
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ],
          )),
          drawer: MainMenuWidget(user: widget.user),
        ));
  }
}
