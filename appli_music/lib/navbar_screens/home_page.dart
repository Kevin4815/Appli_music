import 'dart:convert';
import 'dart:io';

import 'package:appli_music/albums/album.dart';
import 'package:appli_music/audioPlayer/audioplayer.dart';
import 'package:appli_music/audioPlayer/downloader.dart';
import 'package:appli_music/history/history.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


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
  print(musicType.length);
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
  late Future<List<Album>> favoritesMusics;
  final History history = History.instance;
  final MyDownloader downloader = MyDownloader.instance;

  void playerPause() {
      if (isPaused) {
        audioPlayer.resumeAudio();
      } else {
        audioPlayer.pauseAudio();
      }
      isPaused = !isPaused;
  }

  void playerPlay(String url) {
      UrlSource source = UrlSource(url);
      audioPlayer.playAudio(source);
      isPaused = false;
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
    resizeToAvoidBottomInset: false,
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(
        widget.title,
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
    ),
    body: Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<String>>(
            future: musicStyles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<String> styles = snapshot.data!;
                return FutureBuilder<List<Album>>(
                  future: getAllAlbum(styles),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: snapshot.data!
                            .map((album) => InkWell(
                                  onTap: () {
                                    url = album.audio!;
                                    playerPlay(album.audio!);
                                    if (history.albums.isEmpty) {
                                      history.addToData(album);
                                    } else {
                                      if (history.albums.last.albumId !=
                                          album.albumId) {
                                        history.addToData(album);
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(8.0),
                                              child: Image.network(
                                                album.albumImage!,
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 16.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    capitalizeFirst(album.name!),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    capitalizeFirst(album.artistName!),
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.download),
                                              tooltip: 'Télécharger',
                                              onPressed: () {
                                                downloader.downloadMusic(album.audiodownload!, album.name!);
                                                _showToast(context, 'Musique téléchargée');
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Erreur: ${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    ),
    floatingActionButton: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return FloatingActionButton(
          onPressed: () {
            setState(() {
              playerPause();
            });
          },
          tooltip: isPaused ? 'Play' : 'Pause',
          child: isPaused ? const Icon(Icons.play_arrow) : const Icon(Icons.pause),
        );
      },
    ),
  );
}


  Future<List<String>> getStyles() async {
    // widget.id
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id);
        
    try {
      final DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey("musicStyles")) {
          List<String> musicStyles = List<String>.from(data["musicStyles"]);
          return musicStyles;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

 void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  String capitalizeFirst(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

  