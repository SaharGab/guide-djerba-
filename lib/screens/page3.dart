import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/screens/page4.dart';

import '../widgets/reusable_widgets.dart';

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcOver,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/page3.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Skip_button(context),
              SizedBox(
                height: 240.h,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.h, left: 20.w),
                child: Text(
                  "Personnalized \nRecommendations ",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.w, right: 24.w),
                child: Text(
                  "Let us be your travel companion! With personalized recommandations tailored to your interests and preferences, WANDER MATE helps you uncover hidden gems.",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22.sp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 25.h),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Page4();
                      },
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(190, 18, 120, 171),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    alignment: Alignment.center,
                    width: 190.w,
                    height: 55.h,
                    child: Text(
                      "Get Started ",
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
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
