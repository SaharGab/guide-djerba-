import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/pages.dart';
import 'package:projet_pfe/screens/screens.dart';

class Ques0 extends StatelessWidget {
  const Ques0({Key? key}) : super(key: key);

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
                  image: AssetImage('images/mosque.jpeg'),
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
                padding: EdgeInsets.only(top: 50.h, left: 20.w),
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
                height: 350.h,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: Text(
                  "Your answers are important for us",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 24),
                child: Text(
                  "We are asking you for an Onboarding survey for a better personalized feed.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return QuesS();
                      },
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(195, 18, 120, 171),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Start ",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    width: 260,
                    height: 55,
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
