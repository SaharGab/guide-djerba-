import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/pages.dart';
import 'package:projet_pfe/screens/screens.dart';

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);
  Future<void> _signOut(BuildContext context, Widget nextPage) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      print("Error signing out: $error");
    } finally {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
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
                  image: AssetImage('images/page4.jpeg'),
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
                            return Pages();
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
                height: 330.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  "Get the full Experience  ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  "Sign in to access personalized features, personalized feed and for a better experience.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22.sp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.h),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => _signOut(context, Signin()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(195, 18, 120, 171),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    width: 260.w,
                    height: 55.h,
                    child: Text(
                      "Sign in  ",
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
                child: GestureDetector(
                  onTap: () => _signOut(context, Home()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(146, 71, 71, 71),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    width: 260.w,
                    height: 55.h,
                    child: Text(
                      "Continue as a guest ",
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
            ],
          ),
        ),
      ],
    );
  }
}
