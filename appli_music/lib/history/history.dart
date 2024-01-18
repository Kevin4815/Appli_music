import 'package:appli_music/albums/album.dart';

class History {
  static History? _instance;
  List<Album> albums = [];

  History._(); // Constructeur privé

  static History get instance {
    _instance ??= History._(); // Crée l'instance si elle n'existe pas encore
    return _instance!;
  }

  void addToData(Album item) {
    albums.add(item);
  }

  List<Album> getData() {
    return albums;
  }
}
