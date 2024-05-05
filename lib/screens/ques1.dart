import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ques1 extends StatefulWidget {
  const Ques1({Key? key}) : super(key: key);

  @override
  State<Ques1> createState() => _Ques1State();
}

class _Ques1State extends State<Ques1> {
  String? _chosenValue;

  // Fonction pour enregistrer la réponse de l'utilisateur dans Firestore
  Future<void> saveAnswer(String answer) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Remplacez par l'ID de l'utilisateur réel

    // Référence à la collection où vous souhaitez enregistrer les réponses
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    // Enregistrer ou mettre à jour la réponse de l'utilisateur
    return users.doc(userId).set({
      'questionnaire': {
        'q1': answer
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
                padding: EdgeInsets.only(top: 45.h, left: 15.w),
                child: Text(
                  "What type of traveler are you?",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 53, 53, 53),
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    buildRadioListTile('Adventure Seeker'),
                    buildRadioListTile('Relaxation Enthusiast'),
                    buildRadioListTile('Cultural Explorer'),
                    buildRadioListTile('Nature Lover'),
                    buildRadioListTile('Other'),
                    // Ajoutez d'autres options si nécessaire
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRadioListTile(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Color.fromARGB(160, 237, 230, 230),
        borderRadius: BorderRadius.circular(20),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 82, 80, 80),
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        value: title,
        groupValue: _chosenValue,
        onChanged: (value) {
          setState(() {
            _chosenValue = value;
          });
          saveAnswer(value!); // Appelez saveAnswer avec la valeur sélectionnée
        },
        activeColor: Color.fromARGB(255, 18, 120, 171),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.all(1),
      ),
    );
  }
}
