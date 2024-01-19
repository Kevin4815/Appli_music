import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MyDownloader extends AudioPlayer {
  // Instance unique de la classe
  static MyDownloader? _instance;

  // Constructeur privé
  MyDownloader._() : super();

  static MyDownloader get instance {
    _instance ??= MyDownloader._();
    return _instance!;
  }

  static http.Client? _httpClient;

  static http.Client get httpClient {
    _httpClient ??= http.Client();
    return _httpClient!;
  }

  Future<void> downloadMusic(String fileUrl, String fileName) async {
    print(fileUrl);
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

      var response = await httpClient.get(Uri.parse(fileUrl));

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

  static void closeHttpClient() {
    if (_httpClient != null) {
      _httpClient!.close();
      _httpClient = null;
    }
  }
}
