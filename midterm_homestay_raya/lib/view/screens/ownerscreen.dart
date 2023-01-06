import 'dart:convert';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lab_asg_2_homestay_raya/config.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';
import 'package:lab_asg_2_homestay_raya/models/homestay.dart';
import 'package:lab_asg_2_homestay_raya/view/shared/mainmenuwidget.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/newhomestayscreen.dart';

class OwnerScreen extends StatefulWidget {
  final User user;
  const OwnerScreen({super.key, required this.user});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  var _lat, _lng;
  late Position _position;
  List<Homestay> homestayList = <Homestay>[];
  String titlecenter = "Loading...";
  var placemarks;
  late double screenHeight, screenWidth, cardWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _loadHomestay();
  }

  @override
  void dispose() {
    homestayList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      cardWidth = screenWidth;
    } else {
      cardWidth = 400.00;
    }
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.brown[50],
          appBar: AppBar(title: const Text("My Homestay")),
          body: homestayList.isEmpty
              ? Center(
                  child: Column(
                  children: [
                    Expanded(
                      child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 83, 67, 61))),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                            width: 380,
                            child: ElevatedButton(
                              child: const Text('Add new homestay'),
                              onPressed: () => {_gotoNewHomestay()},
                            )),
                      ),
                    )
                  ],
                ))
              : Column(
                  children: [
                    Expanded(
                        child: GridView.count(
                      crossAxisCount: rowcount,
                      padding: const EdgeInsets.all(8),
                      children: List.generate(
                        homestayList.length,
                        (index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                            margin: const EdgeInsets.all(8),
                            child: Column(children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  width: 110,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${Config.SERVER}/homestayraya/assets/images/homestayImages/${homestayList[index].homestayId}.1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          truncateString(
                                              homestayList[index]
                                                  .homestayName
                                                  .toString(),
                                              15),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            "RM ${double.parse(homestayList[index].homestayPrice.toString()).toStringAsFixed(2)}"),
                                        Text(
                                            "${homestayList[index].homestayRoom} Rooms"),
                                      ],
                                    ),
                                  ))
                            ]),
                          );
                        },
                      ),
                    )),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                            width: 380,
                            child: ElevatedButton(
                              child: const Text('Add new homestay'),
                              onPressed: () => {_gotoNewHomestay()},
                            )),
                      ),
                    ),
                  ],
                ),
          drawer: MainMenuWidget(user: widget.user),
        ));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  Future<void> _gotoNewHomestay() async {
    ProgressDialog progressDialog = ProgressDialog(
      context,
      blur: 10,
      message: const Text("Searching your current location"),
      title: null,
    );
    progressDialog.show();
    if (await _checkGetLoc()) {
      progressDialog.dismiss();
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => NewHomestayScreen(
                  user: widget.user,
                  position: _position,
                  placemarks: placemarks)));
      _loadHomestay();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<bool> _checkGetLoc() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      placemarks = await placemarkFromCoordinates(
          _position.latitude, _position.longitude);
      setState(() {
        String loc =
            "${placemarks[0].locality},${placemarks[0].administrativeArea},${placemarks[0].country}";
        print(loc);
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "Error in fixing your location. Make sure internet connection is available and try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return false;
    }
    return true;
  }

  void _loadHomestay() {
    http
        .get(
      Uri.parse(
          "${Config.SERVER}/homestayraya/php/load_homestay.php?userid=${widget.user.id}"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['homestay'] != null) {
            homestayList = <Homestay>[];
            extractdata['homestay'].forEach((v) {
              homestayList.add(Homestay.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No Homestay Available";
            homestayList.clear();
          }
        } else {
          titlecenter = "No Homestay Available";
        }
      } else {
        titlecenter = "No Homestay Available";
        homestayList.clear();
      }
      setState(() {});
    });
  }
}
