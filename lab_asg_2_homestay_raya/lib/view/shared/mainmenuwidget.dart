import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lab_asg_2_homestay_raya/config.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/mainscreen.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/profilescreen.dart';
import 'package:lab_asg_2_homestay_raya/view/shared/EnterExitRoute.dart';

class MainMenuWidget extends StatefulWidget {
  final User user;
  const MainMenuWidget({super.key, required this.user});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget> {
  File? _image;
  var pathAsset = "assets/images/profile.png";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(widget.user.email.toString()),
            accountName: Text(widget.user.name.toString()),
            currentAccountPicture: CircleAvatar(
              radius: 30.0,
              child: ClipOval(
                  child: Container(
                      decoration: BoxDecoration(
                image: DecorationImage(
                  image: _image == null
                      ? NetworkImage(
                          "${Config.SERVER}/homestayraya/assets/images/profile/${widget.user.id}.png")
                      : FileImage(_image!) as ImageProvider,
                  fit: BoxFit.fill,
                ),
              ))),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: MainScreen(user: widget.user),
                      enterPage: MainScreen(user: widget.user)));
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: MainScreen(user: widget.user),
                      enterPage: ProfileScreen(user: widget.user)));
            },
          )
        ],
      ),
    );
  }
}
