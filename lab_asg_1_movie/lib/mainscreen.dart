import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark, primarySwatch: Colors.blueGrey),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Movie App'),
        ),
        body: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchMovie = TextEditingController();

  var title = "";
  var year = "";
  var genre = "";
  var actors = "";
  var imageUrl =
      "https://www.freepnglogos.com/uploads/film-reel-png/film-reel-the-movies-owens-valley-12.png";
  var desc = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        const Padding(padding: EdgeInsets.all(12)),
        const Text("Discover new movie!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const Padding(padding: EdgeInsets.all(12)),
        SizedBox(
          width: 350,
          child: TextField(
            controller: searchMovie,
            decoration: InputDecoration(
                hintText: 'Search movie',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: searchMovie.clear),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          ),
        ),
        const Padding(padding: EdgeInsets.all(8)),
        ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)))),
            onPressed: _confirmSearch,
            child: const Text("Search")),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 20,
          margin: const EdgeInsets.fromLTRB(22, 10, 22, 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text(desc,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade300)),
                const Padding(padding: EdgeInsets.all(6)),
                Image.network(imageUrl),
              ],
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.all(8)),
      ],
    ));
  }

  Future<void> _getMovies() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching movie"));

    progressDialog.show();

    String keyword = searchMovie.text;
    var apikey = "98c4cc0e";
    var url = Uri.parse('https://www.omdbapi.com/?t=$keyword&apikey=$apikey');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        title = parsedJson['Title'];
        year = parsedJson['Year'];
        genre = parsedJson['Genre'];
        actors = parsedJson['Actors'];
        imageUrl = parsedJson['Poster'];

        desc = "Year : $year\nGenre : $genre\nActors : $actors";
      });

      Fluttertoast.showToast(
          msg: "Movie Found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16,
          timeInSecForIosWeb: 3);
    } else {
      setState(() {
        desc = "No record.";
      });
    }
    progressDialog.dismiss();
  }

  void _confirmSearch() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(searchMovie.text),
            content: const Text("Are you sure to search this movie?"),
            actions: [
              TextButton(
                child: const Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _getMovies();
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
