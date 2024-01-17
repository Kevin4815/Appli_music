import 'dart:convert';
import 'dart:io';

import 'package:appli_music/albums/album.dart';
import 'package:appli_music/audioPlayer/audioplayer.dart';
import 'package:appli_music/historical/history.dart';
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
                                          ])),
                                           Expanded(
                                                 child: IconButton(
                                                icon:
                                                    const Icon(Icons.download),
                                                tooltip: 'download',
                                                onPressed: () {
                                                  downloadMusic(album.audiodownload!, album.name!);
                                                }),
                                          )
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
      floatingActionButton: FloatingActionButton(
        onPressed: playerPause,
        tooltip: 'Pause',
        child:
            isPaused ? const Icon(Icons.play_arrow) : const Icon(Icons.pause),
      ),
    );
  }

  Future<List<String>> getStyles() async {
    // widget.id
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.id); // "IX82UsZ2DHZp9eIVllP5NUqzvu42"
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


Future<void> downloadMusic(String fileUrl, String fileName) async {
  try {
    var status = await Permission.storage.request();
    
    if (status.isDenied) {
      if (await Permission.manageExternalStorage.isPermanentlyDenied) {
        openAppSettings();
      } else {
        await Permission.manageExternalStorage.request();
      }
    }

    if (!status.isGranted) {
      print('Permission de stockage refusée.');
      return;
    }

    Directory? downloadsDirectory = await getDownloadsDirectory();

    if (downloadsDirectory == null) {
      print('Impossible d\'obtenir le répertoire "Téléchargements".');
      return;
    }

    String savePath = '${downloadsDirectory.path}/$fileName';

    var response = await http.get(Uri.parse(fileUrl));

    if (response.statusCode == 200) {
      File file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      print('Téléchargement réussi. Chemin du fichier : $savePath');
    } else {
      print('Échec du téléchargement. Code de statut : ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur lors du téléchargement : $e');
  }
}