import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lab_asg_2_homestay_raya/config.dart';
import 'package:lab_asg_2_homestay_raya/models/user.dart';

class NewHomestayScreen extends StatefulWidget {
  final User user;
  final Position position;
  final List<Placemark> placemarks;
  const NewHomestayScreen(
      {super.key,
      required this.user,
      required this.position,
      required this.placemarks});

  @override
  State<NewHomestayScreen> createState() => _NewHomestayScreenState();
}

class _NewHomestayScreenState extends State<NewHomestayScreen> {
  final TextEditingController _hsnameEditingController =
      TextEditingController();
  final TextEditingController _hsdescEditingController =
      TextEditingController();
  final TextEditingController _hspriceEditingController =
      TextEditingController();
  final TextEditingController _hsroomEditingController =
      TextEditingController();
  final TextEditingController _hsstateEditingController =
      TextEditingController();
  final TextEditingController _hslocalEditingController =
      TextEditingController();
  final TextEditingController _hscontactEditingController =
      TextEditingController();

  TextEditingController nameController = TextEditingController();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();

  final _formKey = GlobalKey<FormState>();
  var _hslat, _hslng;

  int _index = 0;
  List<File> hsImageList = <File>[];

  var imgNo = 1;
  File? _image;
  var pathAsset = "assets/images/camera_icon.png";

  late double screenHeight, screenWidth, cardWidth;

  @override
  void initState() {
    super.initState();
    _hslat = widget.position.latitude.toString();
    _hslng = widget.position.longitude.toString();
    _hsstateEditingController.text =
        widget.placemarks[0].administrativeArea.toString();
    _hslocalEditingController.text = widget.placemarks[0].locality.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      cardWidth = screenWidth;
    } else {
      cardWidth = screenWidth;
    }

    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(title: const Text("Add New Homestay")),
        body: Center(
            child: SingleChildScrollView(
          child: SizedBox(
            width: cardWidth,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              SizedBox(
                                  width: 150,
                                  child: GestureDetector(
                                    onTap: _selectImage,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: Container(
                                          decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: hsImageList.isNotEmpty
                                              ? FileImage(hsImageList[0])
                                                  as ImageProvider
                                              : AssetImage(pathAsset),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                    ),
                                  )),
                              SizedBox(
                                  width: 150,
                                  child: GestureDetector(
                                    onTap: _selectImage,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: Container(
                                          decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: hsImageList.length > 1
                                              ? FileImage(hsImageList[1])
                                                  as ImageProvider
                                              : AssetImage(pathAsset),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                    ),
                                  )),
                              SizedBox(
                                  width: 150,
                                  child: GestureDetector(
                                    onTap: _selectImage,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: Container(
                                          decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: hsImageList.length > 2
                                              ? FileImage(hsImageList[2])
                                                  as ImageProvider
                                              : AssetImage(pathAsset),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter a name";
                              }
                              if (val.length < 3) {
                                return "Name must be at least 3 letters long";
                              }
                              return null;
                            },
                            focusNode: focus,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus1);
                            },
                            controller: _hsnameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Homestay Name',
                                icon: Icon(Icons.home),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter a description";
                              }
                              if (val.length < 10) {
                                return "Description must be at least 10 letters long";
                              }
                              return null;
                            },
                            focusNode: focus1,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus2);
                            },
                            controller: _hsdescEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Describe your homestay',
                                icon: Icon(Icons.description_rounded),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        Row(
                          children: [
                            Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) => val!.isEmpty
                                        ? "Please enter the price of the homestay"
                                        : null,
                                    focusNode: focus2,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus3);
                                    },
                                    controller: _hspriceEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Price',
                                        icon: Icon(Icons.price_change_rounded),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        )))),
                            Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) => val!.isEmpty
                                        ? "Please enter the quantity of rooms"
                                        : null,
                                    focusNode: focus3,
                                    onFieldSubmitted: (v) {
                                      FocusScope.of(context)
                                          .requestFocus(focus4);
                                    },
                                    controller: _hsroomEditingController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Rooms',
                                        icon: Icon(Icons.bed_rounded),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        ))))
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                                flex: 5,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    validator: (val) =>
                                        val!.isEmpty || (val.length < 3)
                                            ? "Current State"
                                            : null,
                                    enabled: false,
                                    controller: _hsstateEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                        labelText: 'Current States',
                                        labelStyle: TextStyle(),
                                        icon: Icon(Icons.flag),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 2.0),
                                        )))),
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  enabled: false,
                                  validator: (val) =>
                                      val!.isEmpty || (val.length < 3)
                                          ? "Current Locality"
                                          : null,
                                  controller: _hslocalEditingController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      labelText: 'Current Locality',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.location_on),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))),
                            )
                          ],
                        ),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                                val!.isEmpty || (val.length < 10)
                                    ? "Please enter a valid contact number"
                                    : null,
                            focusNode: focus4,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus5);
                            },
                            controller: _hscontactEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Contact Number',
                                icon: Icon(Icons.phone),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        const SizedBox(height: 20),
                        MaterialButton(
                          color: Colors.brown,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          minWidth: 110,
                          height: 40,
                          elevation: 8,
                          onPressed: _newhometsayDialog,
                          child: const Text('Add',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        )));
  }

  void _newhometsayDialog() {
    if (_image == null) {
      Fluttertoast.showToast(
          msg: "Please upload images of your homestay",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text("Add new homestay"),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                insertHomestay();
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text(
              "Select from",
              style: TextStyle(color: Color.fromARGB(255, 83, 67, 61)),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton.icon(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromGallery(),
                  },
                  icon: const Icon(
                    Icons.photo,
                  ),
                  label: const Text(
                    'Gallery',
                  ),
                ),
                TextButton.icon(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    _selectFromCamera(),
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                  ),
                  label: const Text(
                    'Camera',
                  ),
                ),
              ],
            ));
      },
    );
  }

  Future<void> _selectFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.brown,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      hsImageList.add(_image!);
      setState(() {});
    }
  }

  void insertHomestay() {
    FocusScope.of(context).requestFocus(FocusNode());

    String hsname = _hsnameEditingController.text;
    String hsdesc = _hsdescEditingController.text;
    String hsprice = _hspriceEditingController.text;
    String hsroom = _hsroomEditingController.text;
    String hsstate = _hsstateEditingController.text;
    String hslocal = _hslocalEditingController.text;
    String hscontact = _hscontactEditingController.text;
    String base64Image1 = base64Encode(hsImageList[0].readAsBytesSync());
    String base64Image2 = base64Encode(hsImageList[1].readAsBytesSync());
    String base64Image3 = base64Encode(hsImageList[2].readAsBytesSync());

    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("In progress..."),
        title: const Text("Add New Homestay"));
    progressDialog.show();

    try {
      http.post(
          Uri.parse("${Config.SERVER}/homestayraya/php/insert_homestay.php"),
          body: {
            "userid": widget.user.id,
            "hsname": hsname,
            "hsdesc": hsdesc,
            "hsprice": hsprice,
            "hsroom": hsroom,
            "hsstate": hsstate,
            "hslocal": hslocal,
            "hslat": _hslat,
            "hslng": _hslng,
            "hscontact": hscontact,
            "image1": base64Image1,
            "image2": base64Image2,
            "image3": base64Image3
          }).then((response) {
        var data = jsonDecode(response.body);

        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "New Homestay Added Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          progressDialog.dismiss();
          Navigator.of(context).pop();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "New Homestay Added Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          progressDialog.dismiss();
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
