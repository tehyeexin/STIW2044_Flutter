import 'package:flutter/material.dart';
import '../screens/mainscreen.dart';
import '../screens/profilescreen.dart';
import '../screens/loginregisterscreen.dart';
import 'EnterExitRoute.dart';

class MainMenuWidget extends StatefulWidget {
  const MainMenuWidget({Key? key}) : super(key: key);

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountEmail: Text("email"),
            accountName: Text("username"),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (content) => MainScreen()));
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: const MainScreen(),
                      enterPage: const MainScreen()));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (content) => const SellerScreen()));
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: const MainScreen(),
                      enterPage: const ProfileScreen()));
            },
          ),
          ListTile(
            title: const Text('Login / Register'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (content) => const ProfileScreen()));
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: const MainScreen(),
                      enterPage: const LoginRegisterScreen()));
            },
          ),
        ],
      ),
    );
  }
}