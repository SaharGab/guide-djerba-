import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_pfe/models/touristSites.dart';
import 'package:projet_pfe/screens/seeplan.dart';

class RecommendedPlans extends StatefulWidget {
  final BuildContext context;
  RecommendedPlans({required this.context});

  @override
  State<RecommendedPlans> createState() => _RecommendedPlansState();
}

class _RecommendedPlansState extends State<RecommendedPlans> {
  void _toggleFavorite(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(itemId)) {
      favorites.remove(itemId);
    } else {
      favorites.add(itemId);
    }

    await prefs.setStringList('favorites', favorites);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('touristSites')
          .where('category', isEqualTo: 'Activities')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<TouristSite> activities = snapshot.data!.docs
            .map((doc) => TouristSite.fromFirestore(doc))
            .toList();

        return Column(
          children: activities.map((activity) {
            return _buildActivityBox(activity);
          }).toList(),
        );
      },
    );
  }

  Widget _buildActivityBox(TouristSite activity) {
    return Container(
      height: 210.h,
      margin: EdgeInsets.all(15.h.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(activity.imageUrls.last),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10.h.w),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Image.asset(
                  'icons/heart 1.png',
                  color: Colors.white,
                  width: 25.w,
                  height: 30.h,
                ),
                onPressed: () {
                  // Handle favorite button tap
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.h.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    activity.name,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    activity.description,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      _navigateToSeePlan(widget.context, activity);
                    },
                    child: Text('See the plan'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color.fromARGB(207, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _navigateToSeePlan(BuildContext context, TouristSite activity) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SeePlan(activity: activity),
    ),
  );
}
