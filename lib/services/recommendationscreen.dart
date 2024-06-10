import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projet_pfe/models/models.dart';
import 'package:projet_pfe/screens/detailsscreen.dart';
import 'package:projet_pfe/services/recommendationservice.dart';

class RecommendationsScreen extends StatefulWidget {
  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder(
      future: RecommendationService().getUserPreferences(userId),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        debugPrint(
            "FutureBuilder for getUserPreferences: ConnectionState = ${snapshot.connectionState}");
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            debugPrint("Data retrieved for user preferences: ${snapshot.data}");
            return FutureBuilder(
              future:
                  RecommendationService().getRecommendedEvents(snapshot.data!),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DocumentSnapshot>> eventSnapshot) {
                debugPrint(
                    "FutureBuilder for getRecommendedEvents: ConnectionState = ${eventSnapshot.connectionState}");
                if (eventSnapshot.connectionState == ConnectionState.done) {
                  if (eventSnapshot.hasData) {
                    debugPrint(
                        "Data retrieved for recommended events: ${eventSnapshot.data!.length} events found");
                    return ListView.builder(
                      itemCount: eventSnapshot.data!.length,
                      itemBuilder: (context, index) {
                        var doc = eventSnapshot.data![index];
                        var data = doc.data() as Map<String, dynamic>;

                        // Convert Map<String, dynamic> to DataModel
                        DataModel currentStory = DataModel.fromFirestore(doc);

                        return Card(
                          elevation: 5,
                          child: ListTile(
                            leading: Image.network(currentStory.imageUrl,
                                width: 100.w, height: 100.h, fit: BoxFit.cover),
                            title: Text(currentStory.title),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(dataModel: currentStory),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    debugPrint("No data available for events");
                    return Center(child: Text("No events found"));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            debugPrint("No data available for user preferences");
            return Center(child: Text("No preferences found"));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
