
//import 'package:appli_music/navbar_screens/home_page.dart';
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

    Widget title = Container(
      alignment: Alignment.topCenter,
      constraints: const BoxConstraints(maxHeight: 170.0),
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
    );

    Widget form = Column(
      children: [
        Container(
        margin: const EdgeInsets.only(top: 30.0),
        padding: const EdgeInsets.all(16.0),
        child:  Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              validateStyles(widget.id);
            },
            child: const Text('Valider'),
          ),
        ),
        ),
      ]
    );

   return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            title,
            for (var item in styleList)
              GestureDetector(
                onTap: () {
                  handleStyleClick(item);
                },
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxHeight: 50.0, minWidth: 150),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: selectedStyles.contains(item)
                              ? const Color.fromARGB(255, 172, 123, 236)
                              : null,
                        ),
                        child: Text(
                          item,
                          style: const TextStyle( 
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            form
          ],
        ),
      ),
    );
  }

   void handleStyleClick(String clickedStyle) {
    setState(() {
      if (selectedStyles.contains(clickedStyle)) {
        selectedStyles.remove(clickedStyle);
        print(selectedStyles);
        
      } else {
        selectedStyles.add(clickedStyle);
        print(selectedStyles);
      }
    });
  }

  Future<void> addFavorite(String userId) async {
    
    CollectionReference user = FirebaseFirestore.instance.collection('users');

    await user.doc(userId).set({
      'musicStyles': selectedStyles,
    });
  }








//   Future<void> addFavorite(String userId, String newStyle) async {
//   CollectionReference user = FirebaseFirestore.instance.collection('users');

//   // Récupérer la liste actuelle depuis la base de données
//   DocumentSnapshot userSnapshot = await user.doc(userId).get();
//   List<String> currentStyles = List<String>.from(userSnapshot['musicStyles'] ?? []);

//   // Ajouter le nouvel élément à la liste  
//   currentStyles.add(newStyle);

//   // Mettre à jour le document dans la base de données avec la nouvelle liste
//   await user.doc(userId).set({
//     'musicStyles': currentStyles,
//   });
// }







  void navigation(userId){
    Navigator.push( 
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
