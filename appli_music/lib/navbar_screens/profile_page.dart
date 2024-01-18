import 'dart:io';

import 'package:appli_music/audioPlayer/audioplayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title, required this.id}) : super(key: key);

  final String title;
  final String id;

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late ImageProvider<Object> _profileImage = const AssetImage('assets/profil_vide.jpg');

  var image = "";
  
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  loadImage() async {
    String? imageUrl = await getProfilePicture();
    
    setState(() {

      if(imageUrl != ""){
        _profileImage = FileImage(File(imageUrl!));
      }
      else{
        _profileImage = const AssetImage('assets/profil_vide.jpg');
      }
    });
  
  }

  _chooseImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery); 

    if (pickedFile != null) {
      setState(() {
        _profileImage = FileImage(File(pickedFile.path));
      });
    }
  }

  _pickImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera); 

    if (pickedFile != null) {
      setState(() {
        _profileImage = FileImage(File(pickedFile.path));
        image = pickedFile.path;
        addProfilePicture(widget.id, image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget title = Container(
      alignment: Alignment.topCenter,
      constraints: const BoxConstraints(maxHeight: 50.0),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 100.0,
            backgroundImage: _profileImage,
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: _chooseImage,
            child: const Text('Ajouter une photo'),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Prendre une photo'),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: ElevatedButton(
                onPressed: signOut,
                child: const Text('Se déconnecter'),
              ),
            ),
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
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: title,
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    MyAudioPlayer audio = MyAudioPlayer.instance;
    audio.pauseAudio();
    Navigator.pushNamed(context, '/login');
  }

  Future<void> addProfilePicture(String userId, String image) async {
    
    CollectionReference user = FirebaseFirestore.instance.collection('users');

    await user.doc(userId).update({
      'profilePicture': image,
    });
  }

   Future<String?> getProfilePicture() async {
    final docRef = FirebaseFirestore.instance.collection("users").doc(widget.id);
    String message = "";

    try {
      final DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey("profilePicture")) {
          String profilePicture = data["profilePicture"] as String;
          message = profilePicture;
        } else {
          print(" not found in document data.");
          message = "";
        }
      } else {
        print("Document does not exist.");
        message = "Document does not exist.";
      }
    } catch (e) {
      print("Error getting document: $e");
      message = "Error getting document: $e";
    }

    return message;
  }


}

