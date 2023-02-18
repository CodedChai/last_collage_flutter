import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:last_collage/TopAlbums.dart';

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
  static const urlPrefix = 'http://ws.audioscrobbler.com/2.0';
  static const lastFm =
      '/?method=user.gettopalbums&user=guardianx1015&api_key=key&format=json&period=7day&limit=25';

  late Future<TopAlbums> futureTopAlbums;

  Future<TopAlbums> makeGetRequest() async {
    final url = Uri.parse('$urlPrefix$lastFm');
    Response response = await get(url);
    var jsonResponse = jsonDecode(response.body);
    var topAlbums = TopAlbums.fromJson(jsonResponse);
    return topAlbums;
  }

  @override
  void initState() {
    super.initState();
    futureTopAlbums = makeGetRequest();
  }

  @override
  Widget build(BuildContext context) {
    var apiGetWidget = FutureBuilder(
      future: futureTopAlbums,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var albums = snapshot.data!.albums;
          var photos = GridView.builder(
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0,
            ),
            itemCount: albums.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Image.network(albums[index].images[3].text);
            },
          );
          // var names = snapshot.data!.albums.map((e) => Text(e.name)).toList();
          // return ListView(
          //   children: names,
          // );
          return photos;
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              primary: true,
              child: apiGetWidget,
            ),
          ],
        ),
      ),
    );
  }
}
