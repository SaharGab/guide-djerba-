import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projet_pfe/screens/aboutpage.dart';
import 'package:projet_pfe/screens/signin.dart';
import 'package:projet_pfe/screens/signup.dart'; // Assurez-vous d'importer la page d'inscription

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    bool isGuest = user == null; // Vérifie si l'utilisateur est un invité

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24.sp,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
          if (!isGuest) ...[
            // Si l'utilisateur n'est pas un invité
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Signin(),
                    ),
                  );
                } catch (error) {
                  print("Sign Out error $error");
                }
              },
            ),
          ] else ...[
            // Si l'utilisateur est un invité
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Create Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Signup(), // Redirige vers la page d'inscription
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
