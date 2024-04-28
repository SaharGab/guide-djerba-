import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projet_pfe/screens/screens.dart';

class Ques4 extends StatefulWidget {
  const Ques4({Key? key}) : super(key: key);

  @override
  State<Ques4> createState() => _Ques4State();
}

class _Ques4State extends State<Ques4> {
  String? _chosenValue;
  Future<void> saveAnswer(String answer) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Remplacez par l'ID de l'utilisateur réel

    // Référence à la collection où vous souhaitez enregistrer les réponses
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    // Enregistrer ou mettre à jour la réponse de l'utilisateur
    return users.doc(userId).set({
      'questionnaire': {
        'q4': answer
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
                  "What type of accommodations do you seek in Djerba?",
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
                    true, // Important pour que GridView n'occupe que l'espace nécessaire
                children: <Widget>[
                  activityButton('Luxury Hotels', Icons.hotel_class),
                  activityButton('Guesthouses', Icons.hotel),
                  activityButton('Medina Riads', Icons.holiday_village),
                  activityButton('Private Villas', Icons.villa_sharp),
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
            // Initiating navigation with a delay after selection
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false,
              );
            });
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
            Text(title,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: isSelected
                            ? Color.fromARGB(180, 237, 230, 230)
                            : Color.fromARGB(255, 82, 80, 80),
                        fontSize: 16,
                        fontWeight: FontWeight.w700))),
          ],
        ),
      ),
    );
  }
}
