import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Ques3 extends StatefulWidget {
  const Ques3({Key? key}) : super(key: key);

  @override
  State<Ques3> createState() => _Ques3State();
}

class _Ques3State extends State<Ques3> {
  // Initialiser un Map pour suivre les valeurs sélectionnées
  final Map<String, bool> _selectedValues = {
    'Lounge cafes': false,
    'Themed nightclubs': false,
    'Beach bars': false,
    'Live music restaurants': false,
    'Unique spots': false,
  };
  Future<void> saveAnswers() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("Aucun utilisateur connecté");
        return;
      }
      String userId = user.uid;

      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      await users.doc(userId).set({
        'questionnaire': {
          'q3': _selectedValues,
        }
      }, SetOptions(merge: true));
      print("Réponses multiples enregistrées pour q3");
    } catch (error) {
      print("Erreur lors de l'enregistrement des réponses : $error");
    }
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
                  "What kind of nightlife do you prefer in Djerba?",
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
              SizedBox(height: 15.h),
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedValues.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = _selectedValues.keys.elementAt(index);
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(160, 237, 230, 230),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          key,
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 82, 80, 80),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        value: _selectedValues[key],
                        onChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              _selectedValues[key] = value;
                            });
                            // Appeler saveAnswers pour enregistrer l'état actuel de toutes les sélections
                            saveAnswers();
                          }
                        },
                        activeColor: Color.fromARGB(255, 18, 120, 171),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
