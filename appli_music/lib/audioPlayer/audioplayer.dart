import 'package:audioplayers/audioplayers.dart';

class MyAudioPlayer extends AudioPlayer {

  static MyAudioPlayer? _instance;

  MyAudioPlayer._() : super();

  static MyAudioPlayer get instance {
    _instance ??=
        MyAudioPlayer._(); 
    return _instance!;
  }

  void playAudio(Source url) {
    play(url);
  }

  void pauseAudio() {
    pause();
  }

  void resumeAudio() {
    resume();
  }


}
