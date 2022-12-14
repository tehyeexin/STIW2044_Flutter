import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lab_asg_2_homestay_raya/config.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/loginregisterscreen.dart';
import 'package:lab_asg_2_homestay_raya/view/screens/loginscreen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void dispose() {
    super.dispose();
    loadEula();
  }

  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _pass2EditingController = TextEditingController();

  bool _isChecked = false;
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  String eula = "";

  File? _image;
  var pathAsset = "assets/images/camera_icon.png";

  late double screenHeight, screenWidth, resWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Registration Form")),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        const Text(
                          "Register New Account",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: screenHeight / 3,
                            child: GestureDetector(
                              onTap: _selectImage,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Container(
                                    decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: _image == null
                                        ? AssetImage(pathAsset)
                                        : FileImage(_image!) as ImageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                )),
                              ),
                            )),
                        const SizedBox(height: 10),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Name must be longer than 3 letters"
                                : null,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus);
                            },
                            controller: _nameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.person),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "Please enter a valid email"
                                : null,
                            focusNode: focus,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus1);
                            },
                            controller: _emailEditingController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                icon: Icon(Icons.email),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                                val!.isEmpty || (val.length < 10)
                                    ? "Please enter a valid phone number"
                                    : null,
                            focusNode: focus1,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(focus2);
                            },
                            controller: _phoneEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                icon: Icon(Icons.phone),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          validator: (val) => validatePassword(val.toString()),
                          focusNode: focus2,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus3);
                          },
                          controller: _passEditingController,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              icon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              )),
                          obscureText: _passwordVisible,
                        ),
                        TextFormField(
                          style: const TextStyle(),
                          textInputAction: TextInputAction.done,
                          validator: (val) {
                            validatePassword(val.toString());
                            if (val != _passEditingController.text) {
                              return "Password do not match";
                            } else {
                              return null;
                            }
                          },
                          focusNode: focus3,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus4);
                          },
                          controller: _pass2EditingController,
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(),
                              icon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              )),
                          obscureText: _passwordVisible,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: showEula,
                                child: const Text(
                                    'Agree with Terms and Conditions.',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color:
                                            Color.fromARGB(255, 21, 70, 111))),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              color: const Color.fromARGB(255, 190, 222, 230),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              minWidth: 110,
                              height: 50,
                              child: Text('Register'),
                              elevation: 8,
                              onPressed: _registerAccountDialog,
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account? ",
                        style: TextStyle(fontSize: 15)),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen()))
                      },
                      child: const Text(
                        "Login here",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoginRegisterScreen()))
                  },
                  child: const Text(
                    "Back",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must have uppercase, lowercase, and number';
      } else {
        return null;
      }
    }
  }

  void _registerAccountDialog() {
    String _name = _nameEditingController.text;
    String _email = _emailEditingController.text;
    String _phone = _phoneEditingController.text;
    String _passa = _passEditingController.text;
    String _passb = _pass2EditingController.text;

    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept Term and Conditions",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (_passa != _passb) {
      Fluttertoast.showToast(
          msg: "Please check your passsword",
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
          title: const Text(
            "Register new account?",
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
                Navigator.of(context).pop();
                _registerUser(_name, _email, _phone, _passa);
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

  loadEula() async {
    WidgetsFlutterBinding.ensureInitialized();
    eula = await rootBundle.loadString('assets/images/eula.txt');
  }

  showEula() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
            style: TextStyle(),
          ),
          content: SizedBox(
            height: 300,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                        ),
                        text: eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
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
              style: TextStyle(),
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
    } else {
      print('No image selected.');
    }
  }

  void _registerUser(String name, String email, String phone, String pass) {
    FocusScope.of(context).requestFocus(FocusNode());

    // String _name = _nameEditingController.text;
    // String _email = _emailEditingController.text;
    // String _phone = _phoneEditingController.text;
    // String _pass = _passEditingController.text;

    FocusScope.of(context).unfocus();
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Registration in progress.."),
        title: const Text("Registering..."));
    progressDialog.show();

    //String base64Image = base64Encode(_image!.readAsBytesSync());

    try {
      http.post(Uri.parse("${Config.SERVER}/php/register_user.php"), body: {
        "name": name,
        "email": email,
        "phone": phone,
        "password": pass,
        "register": "register"
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Registration Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          progressDialog.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Registration Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          //progressDialog.dismiss();
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
