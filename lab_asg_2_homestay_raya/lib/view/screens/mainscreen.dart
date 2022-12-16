import 'package:flutter/material.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';
import 'package:lab_asg_2_homestay_raya/view/shared/mainmenuwidget.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(title: const Text("Homestay Raya")),
          body: const Center(
              child: Text(
            "Find the best homestay!",
            style: TextStyle(fontSize: 18),
          )),
          drawer: MainMenuWidget(user: widget.user),
        ));
  }
}
