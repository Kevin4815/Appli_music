
import 'package:appli_music/navigation_bar/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MusicStyle extends StatefulWidget {
  const MusicStyle({Key? key, required this.title, required this.id})  : super(key: key);

  final String title;
  final String id;

  @override
  State<MusicStyle> createState() => _MusicStyle();
}

class _MusicStyle extends State<MusicStyle> {

  List<String> styleList = ["Jazz", "Pop", "Rock", "Rap"];
  List<String> selectedStyles = [];

  @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    ),
    body: Center(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            constraints: const BoxConstraints(maxHeight: 140.0),
            margin: const EdgeInsets.only(top: 40.0),
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Quel est ton style',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          for (var item in styleList)
            GestureDetector(
              onTap: () {
                handleStyleClick(item);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        handleStyleClick(item);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                        backgroundColor: (item == 'Jazz' || item == 'Pop' || item == 'Rock' || item == 'Rap')
                            ? selectedStyles.contains(item)
                                ? const Color.fromARGB(255, 172, 123, 236)
                                : Colors.grey // Fond en gris
                            : selectedStyles.contains(item)
                                ? const Color.fromARGB(255, 172, 123, 236)
                                : Theme.of(context).colorScheme.inversePrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(top: 30.0),
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  validateStyles(widget.id);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 50), // Ajusté la taille du bouton "Valider"
                  primary: Theme.of(context).colorScheme.inversePrimary,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text('Valider'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

   void handleStyleClick(String clickedStyle) {
    setState(() {
      if (selectedStyles.contains(clickedStyle)) {
        selectedStyles.remove(clickedStyle);
        
      } else {
        selectedStyles.add(clickedStyle);
      }
    });
  }

  Future<void> addFavorite(String userId) async {
    
    CollectionReference user = FirebaseFirestore.instance.collection('users');

    await user.doc(userId).set({
      'musicStyles': selectedStyles,
    });
  }

  void navigation(userId){
    Navigator.pushReplacement( 
        context, 
        MaterialPageRoute( 
          builder: (context) => 
              NavTab(title: 'Styles', id: userId), 
        ), 
     );
  } 
  
  void validateStyles(userId) async{
    await addFavorite(userId);
    navigation(userId);
  }
}
