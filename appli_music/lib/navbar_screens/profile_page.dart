import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late ImageProvider<Object> _profileImage = const AssetImage('assets/profil_vide.jpg');
  
  final ImagePicker picker = ImagePicker();

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget title = Container(
      alignment: Alignment.topCenter,
      constraints: const BoxConstraints(maxHeight: 170.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Column(
            children: [
              //ElevatedButton(onPressed: onPressed, child: "Se déconnecter")
            ],
          ),
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
}
