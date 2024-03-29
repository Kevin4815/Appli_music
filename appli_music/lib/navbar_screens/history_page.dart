import 'package:appli_music/audioPlayer/audioplayer.dart';
import 'package:appli_music/audioPlayer/downloader.dart';
import 'package:appli_music/history/history.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  State<HistoryPage> createState() => _HistoryPage();
}

class _HistoryPage extends State<HistoryPage> {
  final History history = History.instance;
  final MyAudioPlayer audioPlayer = MyAudioPlayer.instance;
  final MyDownloader downloader = MyDownloader.instance;
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

  @override
  Widget build(BuildContext context) {
    Widget title = Container(
      alignment: Alignment.topCenter,
      constraints: const BoxConstraints(maxHeight: 170.0),
      padding: const EdgeInsets.all(16.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pages des favories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: history.getData().length,
        itemBuilder: (BuildContext context, int index) {
          // Récupérez l'élément à l'index donné
          var album = history.getData()[index];
          return GestureDetector(
            onTap: () {
              MyAudioPlayer audio = MyAudioPlayer.instance;
              audio.pauseAudio(); // Stop l'audio précédent
              url = album.audio!;
              playerPlay(album.audio!);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(child: Image.network(album.albumImage!)),
                  const Padding(padding: EdgeInsets.all(10)),
                  Expanded(
                    child: Column(
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
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.download),
                      tooltip: 'Télécharger',
                      onPressed: () {
                         downloader.downloadMusic(album.audiodownload!, album.name!);
                        _showToast(context, 'Musique téléchargée');
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: playerPause,
        tooltip: 'Pause',
        child:
            isPaused ? const Icon(Icons.play_arrow) : const Icon(Icons.pause),
      ),
    );
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
