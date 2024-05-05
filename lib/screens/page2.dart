import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/widgets/reusable_widgets.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

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
                image: AssetImage('images/sunset.jpeg'),
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
                  "Dive into Djerba's\nWonders !",
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
                  "Discover diverse experiences,  From serene beaches to the authentic charm of Djerba's ancient medina, WANDER MATE  is your passport to unforgettable exploration.",
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
