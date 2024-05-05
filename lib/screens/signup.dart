import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/screens/screens.dart';
import 'package:projet_pfe/widgets/reusable_widgets.dart';
import 'package:projet_pfe/controllers/user_controller.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _fullnameTextController = TextEditingController();
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
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
                    height: 45.h,
                    width: 45.w,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Signin();
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
                  height: 40.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Wander Mate",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Welcome Back! ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Create your account ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      buildTextField("Full Name", false,
                          _fullnameTextController, Icons.person_2_outlined),
                      SizedBox(height: 15.h),
                      buildTextField("Email", false, _emailTextController,
                          Icons.email_outlined),
                      SizedBox(
                        height: 15.h,
                      ),
                      buildTextField("Password", true, _passwordTextController,
                          Icons.lock),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        String fullname = _fullnameTextController.text.trim();
                        String email = _emailTextController.text.trim();
                        String password = _passwordTextController.text.trim();

                        // Validation for empty fields
                        if (fullname.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty) {
                          showSnackbar("Please fill in all fields.");
                          return;
                        }

                        // Validation for a valid email
                        if (!RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
                            .hasMatch(email)) {
                          showSnackbar("Please enter a valid email address.");
                          return;
                        }

                        // Validation for password length
                        if (password.length < 6) {
                          showSnackbar(
                              "Password must be at least 6 characters long.");
                          return;
                        }

                        try {
                          User user = User(
                            fullname: fullname,
                            email: email,
                            password: password,
                          );
                          await user.registerUser(email, password);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoleSelectionScreen(),
                            ),
                          );
                        } catch (e) {
                          showSnackbar(
                              "Failed to create account: ${e.toString()}");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(195, 18, 120, 171),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Create Account",
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 21.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        width: 260,
                        height: 55,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          "Already have an account ? ",
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
                                return Signin();
                              },
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Text(
                            "Sign in",
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
          ),
        ),
      ],
    );
  }
}
