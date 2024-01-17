import 'dart:io';

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
    String? imageLocal = await getStoredImageUrl();
    
    if (imageLocal != null && imageLocal.isNotEmpty) {
      // Si une image locale est présente, utilisez-la
      setState(() {
        _profileImage = FileImage(File(imageLocal));
      });
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      // Sinon, utilisez l'image de la base de données
      setState(() {
        _profileImage = FileImage(File(imageUrl));
      });
    }
  }

  _chooseImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery); 

    if (pickedFile != null) {
      setState(() {
        _profileImage = FileImage(File(pickedFile.path));
        //addProfilePicture(widget.id);
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
        storeImageUrlLocally(pickedFile.path);
      });
    }
  }

  Future<String?> getStoredImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imageUrl = prefs.getString('profileImageUrl');

    // Vérifier si l'image existe
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return imageUrl;
    } else {
      // L'image n'existe pas
      return null;
    }
  }

  Future<void> storeImageUrlLocally(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profileImageUrl', imageUrl);
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(widget.title),
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

    try {
      final DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey("profilePicture")) {
          String musicStyles = data["profilePicture"] as String;
          return musicStyles;
        } else {
          print(" not found in document data.");
          return null;
        }
      } else {
        print("Document does not exist.");
        return null;
      }
    } catch (e) {
      print("Error getting document: $e");
      return null;
    }
  }


}

