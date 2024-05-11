import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projet_pfe/screens/homepage.dart';
import 'package:projet_pfe/screens/saves.dart';
import 'package:projet_pfe/screens/search.dart';
import 'package:projet_pfe/screens/settings_page.dart';
import 'package:projet_pfe/screens/translation.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    SavesPage(),
    FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text("Error"),
            );
          }
          final cameras = snapshot.data!.first;
          return TranslationPage(
            camera: cameras,
          );
        }),
    // Assurez-vous que ces pages sont bien définies et importées
  ];

  @override
  Widget build(BuildContext context) {
    // Vérifie si l'utilisateur est un invité (pas connecté)
    bool isGuest = user == null;

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              title: isGuest
                  ? Text("Welcome Guest")
                  : FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(user?.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        String name = snapshot.data!.get('fullname');
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage('images/djerbaa.png'),
                            ),
                            SizedBox(width: 15),
                            Column(
                              children: [
                                Text(
                                  "Hello, ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
              actions: [
                IconButton(
                  icon: Image.asset('icons/bell.png', height: 25, width: 25),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Image.asset('icons/settings 1.png',
                      height: 25, width: 25),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage()));
                  },
                ),
              ],
              elevation: 0,
              backgroundColor: Colors.transparent,
            )
          : null,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 0
                  ? 'icons/house-blank.png'
                  : 'icons/house-blank 1.png',
              width: 30,
              height: 35,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 1 ? 'icons/search.png' : 'icons/search 1.png',
              width: 30,
              height: 35,
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 2 ? 'icons/heart.png' : 'icons/heart 1.png',
              width: 30,
              height: 35,
            ),
            label: 'Saves',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 3 ? 'icons/qr-scann.png' : 'icons/qr-scan.png',
              width: 30,
              height: 35,
            ),
            label: 'Traduction',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 18, 120, 171),
        unselectedItemColor: Color.fromARGB(255, 27, 27, 27),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
