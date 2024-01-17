
import 'package:appli_music/navbar_screens/favorite_page.dart';
import 'package:appli_music/navbar_screens/home_page.dart';
import 'package:appli_music/navbar_screens/profile_page.dart';
import 'package:appli_music/navbar_screens/search_page.dart';

import 'package:flutter/material.dart';

class NavTab extends StatefulWidget {
  const NavTab({super.key, required this.title, required this.id});
  final String title;
  final String id;
  
  @override
  State<NavTab> createState() => _NavTab();
}

class _NavTab extends State<NavTab> {

  int _selectedIndex = 0;

  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();

    _screens = [
       MyHomePage(title: 'Register', id: widget.id),
      const FavoritePage(title: 'Favorite'),
      const SearchPage(title: 'Search'),
      ProfilePage(title: 'Profile ', id: widget.id),
    ];
  }

  // Variables pour suivre la sélection actuelle
  String selectedAlbum = 'Album 1';
  String selectedSong = 'Chanson 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 211, 211, 211),
        // Plus de 3 éléments
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,       
      ),
      body: _screens[_selectedIndex],
    );
  }

    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}