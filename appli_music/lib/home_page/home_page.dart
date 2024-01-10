import 'dart:convert';

import 'package:appli_music/home_page/album.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<List<Album>> getAllAlbum(final String musicType) async {
  final json = await http.get(Uri.parse(
      'https://api.jamendo.com/v3.0/tracks/?client_id=1e6fe79c&format=jsonpretty&limit=10&fuzzytags=$musicType&include=musicinfo'));

  List<Album> albums = [];

  final jsDecode = jsonDecode(json.body) as Map<String, dynamic>;
  for (var album in jsDecode['results']) {
    albums.add(Album.fromJson(album));
  }
  return albums;
}

class _MyHomePageState extends State<MyHomePage> {
  // Variables pour suivre la sélection actuelle
  String selectedAlbum = 'Album 1';
  String selectedSong = 'Chanson 1';
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: FutureBuilder<List<Album>>(
                future: getAllAlbum("jazz"),
                // snapshot contient l'état de la future (terminée ou non)
                builder: (context, snapshot) {
                  // True, si les données on bien été récupérer
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: snapshot.data!
                          .map((album) => GestureDetector(
                              onTap: () {
                                playerPlay(album.audio!);
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child:
                                              Image.network(album.albumImage!)),
                                      const Padding(
                                          padding: EdgeInsets.all(10)),
                                      Expanded(
                                          child: Column(children: [
                                        Text(album.albumName!),
                                        Text(album.artistName!)
                                      ]))
                                    ],
                                  ))))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: playerPause,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }

  void playerPause() {
    audioPlayer.stop();
  }

  void playerPlay(String url) {
    UrlSource source = UrlSource(url);
    audioPlayer.play(source);
  }
}
