import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/screens/event_details_screen.dart';

import 'package:projet_pfe/screens/event_list_screen.dart';

import 'package:projet_pfe/screens/screens.dart';
import 'package:projet_pfe/widgets/firebase_notifications.dart';
import 'package:projet_pfe/widgets/reusable_widgets.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  Future<void> signInUser() async {
    String email = _emailTextController.text.trim();
    String password = _passwordTextController.text.trim();

    // Check if the email or password fields are empty
    if (email.isEmpty || password.isEmpty) {
      showSnackbar("Email and password cannot be empty.");
      return;
    }

    // Check for a valid email format
    if (!RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b').hasMatch(email)) {
      showSnackbar("Please enter a valid email address.");
      return;
    }

    // Check if the password is at least 6 characters long
    if (password.length < 6) {
      showSnackbar("Password must be at least 6 characters.");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await EventUtils.deleteExpiredEvents();

        final userId = userCredential.user!.uid;
        FirebaseNotifications().setupNotificationsForUser(userId);
        final docSnap = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();

        if (docSnap.exists) {
          final role = docSnap.data()?['role'];
          navigateBasedOnRole(role);
        } else {
          showSnackbar("Document with ID $userId does not exist");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackbar('Wrong password provided for that user.');
      } else {
        showSnackbar('Error signing in: ${e.message}');
      }
    } catch (e) {
      showSnackbar('Error signing in: ${e.toString()}');
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void navigateBasedOnRole(String? role) {
    switch (role) {
      case 'Explorer':
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
        break;
      case 'Provider':
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => EventListScreen()));
        break;
      default:
        print('Unknown user role or error fetching user role');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 20.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(146, 71, 71, 71),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    height: 40.h,
                    width: 40.w,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Page4();
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
                  height: 27.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Wander Mate  ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Welcome Back!",
                    style: GoogleFonts.roboto(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.h, top: 10.h),
                    child: Text(
                      "Sign in to your existent account ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      buildTextField("Email", false, _emailTextController,
                          Icons.email_outlined),
                      SizedBox(
                        height: 15.h,
                      ),
                      buildTextField(
                          "Password", true, _passwordTextController, Icons.key)
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10.h, left: 235.w, bottom: 25.h),
                  child: Text(
                    "Forgot password ?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 65.w),
                  child: GestureDetector(
                    onTap: () {
                      print("Button tapped");
                      signInUser().catchError((error) {
                        print("Error signing in: $error");
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(195, 18, 120, 171),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      width: 260.w,
                      height: 55.h,
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.h),
                  alignment: Alignment.center,
                  child: Text(
                    "Or connect with ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 68.w, top: 15.h),
                      child: Container(
                        width: 65.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(236, 158, 158, 158),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Image.asset(
                            'icons/google.png',
                            height: 45.h,
                            width: 45.w,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.w, top: 15.h),
                      child: Container(
                        width: 65.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(236, 158, 158, 158),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Image.asset(
                            'icons/twitter.png',
                            height: 45.h,
                            width: 45.w,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.w, top: 15.h),
                      child: Container(
                        width: 65.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(236, 158, 158, 158),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Image.asset(
                            'icons/facebook.png',
                            height: 45.h,
                            width: 45.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Text(
                              "Don't have an account ? ",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Signup();
                                  },
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20.h),
                              child: Text(
                                "Sign up",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromARGB(255, 18, 120, 171),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
