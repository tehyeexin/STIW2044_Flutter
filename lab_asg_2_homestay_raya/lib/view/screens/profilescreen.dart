import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lab_asg_2_homestay_raya/config.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/startlogin.dart';
import 'package:lab_asg_2_homestay_raya/view/shared/mainmenuwidget.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late double screenHeight, screenWidth, cardwitdh;
  File? _image;
  var pathAsset = "assets/images/profilepic.png";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      cardwitdh = screenWidth;
    } else {
      cardwitdh = 400.00;
    }
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                const SizedBox(height: 30),
                const Text(
                  "My Profile",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                    elevation: 8,
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          SizedBox(
                              height: 180,
                              width: 180,
                              child: GestureDetector(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    child: ClipOval(
                                        child: Container(
                                            decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: _image == null
                                            ? NetworkImage(
                                                "${Config.SERVER}/homestayraya/assets/images/profile/${widget.user.id}.png")
                                            : FileImage(_image!)
                                                as ImageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ))),
                                  ),
                                ),
                              )),
                          const SizedBox(height: 15),
                          Text(
                            widget.user.name.toString(),
                            style: const TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.email),
                              Text(widget.user.email.toString()),
                              const SizedBox(height: 10),
                              const Icon(Icons.phone),
                              Text(widget.user.phone.toString()),
                            ],
                          )
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => {_logout()},
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ])),
          drawer: MainMenuWidget(user: widget.user),
        ));
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Logout?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const StartLoginScreen()));
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
