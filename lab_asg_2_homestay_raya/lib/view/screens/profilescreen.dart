import 'package:flutter/material.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';
import '../shared/mainmenuwidget.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: const Text("Profile")),
          body: const Center(child: Text("Profile")),
          drawer:  MainMenuWidget(user: widget.user),
        ));
  }
}