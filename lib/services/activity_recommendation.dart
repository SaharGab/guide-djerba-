import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projet_pfe/models/touristSites.dart';
import 'package:projet_pfe/services/recommendationservice.dart';
import 'package:projet_pfe/screens/seeplan.dart';

class ActivitiesRecommendationScreen extends StatefulWidget {
  @override
  State<ActivitiesRecommendationScreen> createState() =>
      _ActivitiesRecommendationScreenState();
}

class _ActivitiesRecommendationScreenState
    extends State<ActivitiesRecommendationScreen> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RecommendationService().getUserPreferences(userId),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return FutureBuilder(
            future: RecommendationService()
                .getRecommendedTouristSites(snapshot.data!),
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentSnapshot>> sitesSnapshot) {
              if (sitesSnapshot.connectionState == ConnectionState.done &&
                  sitesSnapshot.hasData) {
                return ListView.builder(
                  itemCount: sitesSnapshot.data!.length,
                  itemBuilder: (context, index) {
                    var doc = sitesSnapshot.data![index];
                    var data = doc.data() as Map<String, dynamic>;
                    List<dynamic> imageUrls = data['imageUrls'] ?? [];

                    String firstImageUrl = imageUrls.isNotEmpty
                        ? imageUrls[0]
                        : 'default_image.jpg';
                    TouristSite site = TouristSite.fromFirestore(doc);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeePlan(activity: site),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              firstImageUrl,
                              height: 200.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            ListTile(
                              title: Text(data['name']),
                              subtitle: Text(
                                data['description'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
