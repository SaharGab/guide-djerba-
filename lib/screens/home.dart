import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projet_pfe/screens/homepage.dart';
import 'package:projet_pfe/screens/saves.dart';
import 'package:projet_pfe/screens/search.dart';
import 'package:projet_pfe/screens/settings_page.dart';
import 'package:projet_pfe/screens/translation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:badges/badges.dart' as badges;
import 'package:projet_pfe/screens/signup.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  List<RemoteMessage> notifications = [];
  int _notificationCount = 0;

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
  ];

  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
    initializeFirebaseMessaging();
  }

  void requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void initializeFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging
        .subscribeToTopic('all'); // Abonner les utilisateurs au topic 'all'

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        notifications.add(message);
        _notificationCount++;
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NotificationScreen(notifications: notifications)),
      );
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  NotificationScreen(notifications: notifications)),
        );
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 2 && user == null) {
      // Show Snackbar for guest user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Create an account for a personalized experience!'),
          action: SnackBarAction(
            label: 'Sign Up',
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Signup()));
            },
          ),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

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
                badges.Badge(
                  badgeContent: Text(
                    _notificationCount.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    icon: Image.asset('icons/bell.png', height: 25, width: 25),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen(
                                notifications: notifications)),
                      );
                      setState(() {
                        _notificationCount = 0;
                      });
                    },
                  ),
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
            label: 'For You',
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
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  final List<RemoteMessage> notifications;

  const NotificationScreen({Key? key, required this.notifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          RemoteMessage message = notifications[index];
          return ListTile(
            title: Text(message.notification?.title ?? 'No Title'),
            subtitle: Text(message.notification?.body ?? 'No Body'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotificationDetailScreen(message: message),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  final RemoteMessage message;

  const NotificationDetailScreen({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.notification?.title ?? 'No Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              message.notification?.body ?? 'No Body',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Data:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              message.data.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
