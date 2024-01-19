//import 'package:appli_music/Auth/music_style.dart';
import 'package:appli_music/Auth/music_style.dart';
import 'package:appli_music/Auth/register.dart';
import 'package:appli_music/navbar_screens/home_page.dart';
//import 'package:appli_music/albums/home_page.dart';
import 'package:appli_music/navigation_bar/navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    routes: {
      '/login': (context) => const LoginPage(title: "Se connecter"),
      '/register': (context) => const RegisterPage(title: "S'inscrire"),
    },
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      useMaterial3: true,
    ),
    home: WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return snapshot.hasData
                ? NavTab(title: 'Home', id: snapshot.data!.uid)
                : const LoginPage(title: "Se connecter");
          }
        },
      ),
    ),
  );
}

}

