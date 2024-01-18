//import 'package:appli_music/Auth/music_style.dart';
import 'package:appli_music/Auth/register.dart';
//import 'package:appli_music/albums/home_page.dart';
import 'package:appli_music/navigation_bar/navigationbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:appli_music/Auth/login.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(title: "Se connecter"),
        '/register': (context) => const RegisterPage(title: "S'inscrire"),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
