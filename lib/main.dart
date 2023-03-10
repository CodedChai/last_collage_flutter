import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:last_collage/Album.dart';
import 'package:last_collage/TopAlbums.dart';
import 'package:stroke_text/stroke_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Last Collage',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Last Collage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget apiWidget = const Text('');
  static const urlPrefix = 'http://ws.audioscrobbler.com/2.0';

  Future<TopAlbums> makeGetRequest(String username) async {
    String lastFm =
        '/?method=user.gettopalbums&user=$username&api_key=key&format=json&period=7day&limit=16';
    final url = Uri.parse('$urlPrefix$lastFm');
    Response response = await get(url);
    var jsonResponse = jsonDecode(response.body);
    var topAlbums = TopAlbums.fromJson(jsonResponse);
    return topAlbums;
  }

  Widget buildAlbumWidget(String username) {
    Future<TopAlbums> futureTopAlbums = makeGetRequest(username);

    return FutureBuilder(
      future: futureTopAlbums,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var albums = snapshot.data!.albums;

          return buildLayout(albums);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Container(
            width: 30, height: 30, child: const CircularProgressIndicator());
      },
    );
  }

  Widget buildAlbumInfo(Album album) {
    return Stack(
      children: [
        CachedNetworkImage(
            placeholder: (context, url) => const CircularProgressIndicator(),
            imageUrl: album.images.last.text),
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StrokeText(
                text: album.artist.name,
                strokeWidth: 1.3,
              ),
              StrokeText(
                text: album.name,
                strokeWidth: 1.3,
              ),
              StrokeText(
                text: "Play count: ${album.playcount}",
                strokeWidth: 1.3,
              ),
            ])
      ],
    );
  }

  LayoutBuilder buildLayout(List<Album> albums) {
    var grid = LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
        primary: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 0.0, mainAxisSpacing: 0.0),
        itemCount: albums.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildAlbumInfo(albums[index]);
        },
      );
    });
    return grid;
  }

  final _formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your last.fm username',
                  ),
                  controller: textEditingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Must not be empty';
                    }
                    return value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    //  if (_formKey.currentState!.validate()) {
                    setState(() {
                      apiWidget = buildAlbumWidget(textEditingController.text);
                    });
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Getting albums for ${textEditingController.text}')),
                    );
                    //    }
                  },
                  child: const Text('Collage!'),
                ),
              ),
              Expanded(
                child: apiWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
