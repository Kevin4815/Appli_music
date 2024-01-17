import 'package:audioplayers/audioplayers.dart';

class MyAudioPlayer extends AudioPlayer {
  // Instance unique de la classe
  static MyAudioPlayer? _instance;

  // Constructeur privé
  MyAudioPlayer._() : super();

  // Méthode statique pour obtenir l'instance unique
  static MyAudioPlayer get instance {
    _instance ??=
        MyAudioPlayer._(); // Crée l'instance si elle n'existe pas encore
    return _instance!;
  }

  // Votre logique métier ici

  void playAudio(Source url) {
    play(url);
  }

  void pauseAudio() {
    pause();
  }

  void resumeAudio() {
    resume();
  }

  // Ajoutez d'autres méthodes selon vos besoins
}
