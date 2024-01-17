import 'dart:convert';

import 'package:appli_music/albums/album.dart';
import 'package:appli_music/audioPlayer/audioplayer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.id});
  final String title;
  final String id;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<List<Album>> getAllAlbum(final List<String> musicType) async {
  List<Album> albums = [];
  // Loop on the musicStyles list
  for (var i = 0; i < musicType.length; i++) {
    final encodedMusicType = Uri.encodeComponent(musicType[i]);
    final json = await http.get(Uri.parse(
        'https://api.jamendo.com/v3.0/tracks/?client_id=1e6fe79c&format=jsonpretty&limit=10&fuzzytags=$encodedMusicType&include=musicinfo'));

    final jsDecode = jsonDecode(json.body) as Map<String, dynamic>;
    for (var album in jsDecode['results']) {
      albums.add(Album.fromJson(album));
    }
  }
  return albums;
}

class _MyHomePageState extends State<MyHomePage> {
  // Variables pour suivre la sélection actuelle
  String selectedAlbum = 'Album 1';
  String selectedSong = 'Chanson 1';
  final MyAudioPlayer audioPlayer = MyAudioPlayer.instance;
  late Future<List<String>> musicStyles;
  String url = "";
  bool isPaused = false;

  void playerPause() {
    setState(() {
      if (isPaused) {
        audioPlayer.resumeAudio();
      } else {
        audioPlayer.pauseAudio();
      }
      isPaused = !isPaused;
    });
  }

  void playerPlay(String url) {
    setState(() {
      UrlSource source = UrlSource(url);
      audioPlayer.playAudio(source);
      isPaused = false;
    });
  }

  // Get playlist of favorites musics from database
  @override
  void initState() {
    super.initState();
    musicStyles = getStyles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            // List of musicStyles from database
            child: FutureBuilder<List<String>>(
              future: musicStyles,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> styles = snapshot.data!;
                  // List of albums
                  return FutureBuilder<List<Album>>(
                    future: getAllAlbum(styles),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: snapshot.data!
                              .map((album) => GestureDetector(
                                  onTap: () {
                                    url = album.audio!;
                                    playerPlay(album.audio!);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Image.network(
                                                  album.albumImage!)),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: playerPause,
            tooltip: 'Previous',
            child: const Icon(Icons.skip_previous),
          ),
          FloatingActionButton(
            onPressed: playerPause,
            tooltip: 'Pause',
            child: isPaused
                ? const Icon(Icons.play_arrow)
                : const Icon(Icons.pause),
          ),
          FloatingActionButton(
            onPressed: playerPause,
            tooltip: 'Next',
            child: const Icon(Icons.skip_next),
          )
        ],
      ),
    );
  }

  Future<List<String>> getStyles() async {
    // widget.id
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc("IX82UsZ2DHZp9eIVllP5NUqzvu42");
    try {
      final DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey("musicStyles")) {
          List<String> musicStyles = List<String>.from(data["musicStyles"]);
          return musicStyles;
        } else {
          print("musicStyles not found in document data.");
          return [];
        }
      } else {
        print("Document does not exist.");
        return [];
      }
    } catch (e) {
      print("Error getting document: $e");
      return [];
    }
  }
}
