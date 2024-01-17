import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
 late ImageProvider<Object> _profileImage =
      const AssetImage('assets/profil_vide.jpg');

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  _loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = File('${directory.path}/profile_image.jpg');

    if (imagePath.existsSync()) {
      setState(() {
        _profileImage = FileImage(imagePath);
      });
    }
  }

  _chooseImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final File destinationFile = File('${directory.path}/profile_image.jpg');

      await File(pickedFile.path).copy(destinationFile.path);

      setState(() {
        _profileImage = FileImage(destinationFile);
      });
    }
  }

  _pickImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final File destinationFile = File('${directory.path}/profile_image.jpg');

      await File(pickedFile.path).copy(destinationFile.path);

      setState(() {
        _profileImage = FileImage(destinationFile);
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
}

