import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/widgets/reusable_widgets.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

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
                image: AssetImage('images/page01.jpeg'),
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
                height: 300.h,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15.h, left: 20.w),
                child: Text(
                  "Welcome to\nWander Mate",
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
                  "Discover the essence of Djerba with WanderMate! Explore its beauty, taste its flavors, and feel its warmth as you embark on your adventure across the island.",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22.sp,
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
