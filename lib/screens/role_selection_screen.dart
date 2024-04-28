import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/screens/screens.dart';
import 'package:projet_pfe/screens/category_selection_screen.dart'; // Assurez-vous que le chemin d'importation est correct

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcOver,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/blurry.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment(0.6, 0)),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(146, 71, 71, 71),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 40,
                  width: 40,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Signup();
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 90,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Are You a Provider or Explorer ?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rubik(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (user != null) {
                        try {
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(user.uid)
                              .update({
                            'role': 'Explorer',
                          });
                          await user.reload();
                          Navigator.push(
                            (context),
                            MaterialPageRoute(
                              builder: (context) => Ques0(),
                            ),
                          );
                        } catch (e) {
                          print('error adding the role: $e');
                        }
                      } else {
                        print('No user signed in!');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, top: 70),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(99, 213, 221, 225)
                                      .withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 2,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              color: Color.fromARGB(100, 184, 181, 181),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 10, bottom: 22),
                                  child: Image.asset(
                                    'icons/map.png',
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                                Text(
                                  "Explorer ",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.aBeeZee(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            width: 160,
                            height: 200,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (user != null) {
                        try {
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(user.uid)
                              .update({
                            'role':
                                'Provider', // Assurez-vous que le champ est correct pour votre base de données
                          });
                          await user
                              .reload(); // Cela met à jour l'instance utilisateur avec les dernières données de Firestore
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategorySelectionScreen(), // Redirection vers le sélecteur de catégorie
                            ),
                          );
                        } catch (e) {
                          print('error adding the role: $e');
                        }
                      } else {
                        print('No user signed in!');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, top: 70),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(99, 213, 221, 225)
                                  .withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ],
                          color: const Color.fromARGB(100, 185, 181, 181),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 10, bottom: 15),
                              child: Image.asset(
                                'icons/provider.png',
                                height: 80,
                                width: 80,
                              ),
                            ),
                            Text(
                              "Provider ",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        width: 160,
                        height: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
