import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ques2 extends StatefulWidget {
  const Ques2({Key? key}) : super(key: key);

  @override
  State<Ques2> createState() => _Ques2State();
}

class _Ques2State extends State<Ques2> {
  String? _chosenValue;
  Future<void> saveAnswer(String answer) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Remplacez par l'ID de l'utilisateur réel

    // Référence à la collection où vous souhaitez enregistrer les réponses
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    // Enregistrer ou mettre à jour la réponse de l'utilisateur
    return users.doc(userId).set({
      'questionnaire': {
        'q2': answer
      } // Modifiez ceci selon votre structure de données
    }, SetOptions(merge: true)).then((_) {
      print("Answer saved");
    }).catchError((error) {
      print("Failed to save answer: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45, left: 15, right: 10),
                child: Text(
                  "Which activities do you enjoy during your travels?",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 53, 53, 53),
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                shrinkWrap:
                    true, // Important pour s'assurer que le GridView n'occupe que l'espace nécessaire
                children: <Widget>[
                  activityButton(
                      'Beach Relaxation', Icons.beach_access_rounded),
                  activityButton('Sightseeing', Icons.account_balance_rounded),
                  activityButton('Shopping', Icons.shopping_cart),
                  activityButton('Hiking', Icons.terrain),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget activityButton(String title, IconData icon) {
    bool isSelected = _chosenValue == title;
    return Card(
      color: isSelected
          ? Color.fromARGB(255, 18, 120, 171)
          : Color.fromARGB(160, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          setState(() {
            _chosenValue = title;
          });
          saveAnswer(title);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 48,
                color: isSelected
                    ? Color.fromARGB(180, 237, 230, 230)
                    : Color.fromARGB(255, 82, 80, 80)),
            Text(
              title,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: isSelected
                      ? Color.fromARGB(180, 237, 230, 230)
                      : Color.fromARGB(255, 82, 80, 80),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
