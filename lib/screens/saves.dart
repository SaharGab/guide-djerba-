import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/services/activity_recommendation.dart';
import 'package:projet_pfe/services/recommendationscreen.dart';

class SavesPage extends StatefulWidget {
  const SavesPage({super.key});

  @override
  State<SavesPage> createState() => _SavesPageState();
}

class _SavesPageState extends State<SavesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Recommendations',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24.sp,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Aligns the Column to the center
          children: [
            Container(
              width: 350.w,
              height: 250.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent,
                    Color.fromARGB(255, 185, 50, 135),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecommendationsScreen()),
                  );
                },
                icon: Icon(Icons.nightlife, size: 35.sp), // Adding an icon
                label: Text('Events',
                    style: GoogleFonts.aboreto(fontSize: 30.sp)), // Bigger text
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 12.h), // Larger padding
                  minimumSize: Size(350.w, 250.h),
                ),
              ),
            ),
            SizedBox(height: 30.h), // Increased space between buttons
            Container(
              width: 350.w,
              height: 250.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 185, 50, 135),
                    Colors.blueAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActivitiesRecommendationScreen()),
                  );
                },
                icon: Icon(Icons.surfing_sharp, size: 35.sp), // Adding an icon
                label: Text('Activities',
                    style: GoogleFonts.aboreto(fontSize: 30.sp)), // Bigger text
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 12.h), // Larger padding
                  minimumSize: Size(350.w, 250.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
