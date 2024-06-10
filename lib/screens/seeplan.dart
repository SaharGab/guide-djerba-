import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:projet_pfe/models/touristSites.dart';
import 'package:projet_pfe/screens/signup.dart';
import 'package:projet_pfe/widgets/comment.dart';
import 'package:projet_pfe/widgets/comment_button.dart';
import 'package:projet_pfe/widgets/helper_methods.dart';
import 'package:projet_pfe/widgets/rating_widget.dart';

class SeePlan extends StatefulWidget {
  final TouristSite activity;

  SeePlan({required this.activity});

  @override
  State<SeePlan> createState() => _SeePlanState();
}

class _SeePlanState extends State<SeePlan> {
  final _commentTextController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  void showLoginSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Create an account to leave a comment!'),
        action: SnackBarAction(
          label: 'Sign Up',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Signup()),
            );
          },
        ),
      ),
    );
  }

  void showLoginSnackbarForRating() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Create an account to rate this site!'),
        action: SnackBarAction(
          label: 'Sign Up',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Signup()),
            );
          },
        ),
      ),
    );
  }

  // add a comment
  void addComment(String commentText) {
    if (currentUser == null) {
      showLoginSnackbar();
      return;
    }
    // write the comment to firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection("touristSites")
        .doc(widget.activity.id)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser!.email,
      "CommentTime": Timestamp.now(),
    });
  }

  //show a dialog box for adding comment

  void showCommentDialog() {
    if (currentUser == null) {
      showLoginSnackbar();
      return;
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Add Comment"),
              content: TextField(
                controller: _commentTextController,
                decoration: InputDecoration(hintText: "Write a comment.."),
              ),
              actions: [
                //cancel button
                TextButton(
                  onPressed: () {
                    //pop box
                    Navigator.pop(context);
                    //clear controller
                    _commentTextController.clear();
                  },
                  child: Text("Cancel"),
                ),
                //post button
                TextButton(
                  onPressed: () {
                    //add comment
                    addComment(_commentTextController.text);
                    //pop box
                    Navigator.pop(context);
                    // clear controller
                    _commentTextController.clear();
                  },
                  child: Text("Post"),
                ),
              ],
            ));
  }

  void updateRating(double newRating) async {
    var cafeRef = FirebaseFirestore.instance
        .collection('touristSites')
        .doc(widget.activity.id);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      var cafeSnapshot = await transaction.get(cafeRef);

      if (!cafeSnapshot.exists) {
        throw Exception("plans does not exist!");
      }

      double oldRating = cafeSnapshot.data()?['rating'] ?? 0.0;
      int oldCount = cafeSnapshot.data()?['ratingCount'] ?? 0;

      double newAverage = ((oldRating * oldCount) + newRating) / (oldCount + 1);
      int newCount = oldCount + 1;

      transaction
          .update(cafeRef, {'rating': newAverage, 'ratingCount': newCount});
    });
  }

  void handleRatingClick() {
    if (currentUser == null) {
      showLoginSnackbarForRating();
    }
  }

  void showRatingFeedback(double rating) {
    String message;
    if (rating >= 4.5) {
      message = "You rated this tourist site as Excellent!";
    } else if (rating >= 3.5) {
      message = "You rated this tourist site as Good!";
    } else if (rating >= 2.5) {
      message = "You rated this tourist site as Average!";
    } else if (rating >= 1.5) {
      message = "You rated this tourist site as Below Average!";
    } else {
      message = "You rated this tourist site as Poor!";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              'icons/heart 1.png',
              color: Colors.black,
              width: 25.w,
              height: 30.h,
            ),
            onPressed: () {
              // Implement favorite logic for 'activity'
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Images Carousel
            Container(
              height: 300.h,
              child: PageView.builder(
                itemCount: widget.activity.imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.activity.imageUrls[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            // Description and Other Details
            Padding(
              padding: EdgeInsets.all(16.h.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // activity Name in Bold
                  Text(
                    widget.activity.name,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Location with Icon
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.black),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          widget.activity.location,
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Description Paragraph
                  Text(
                    widget.activity.description,
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {
                      if (currentUser == null) {
                        handleRatingClick();
                      }
                    },
                    child: AbsorbPointer(
                      absorbing: currentUser == null,
                      child: RatingWidget(
                        initialRating:
                            0, // Load this value from Firestore if already rated
                        onRatingChanged: (rating) {
                          updateRating(rating);
                          showRatingFeedback(
                              rating); // Show feedback based on rating
                        },
                      ),
                    ),
                  ),

                  Column(
                    children: [
                      CommentButton(onTap: showCommentDialog),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("touristSites")
                            .doc(widget.activity.id)
                            .collection("Comments")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // Display the count of documents in the Comments collection
                            return Text(
                              '${snapshot.data!.docs.length}', // Dynamically display the count
                              style: const TextStyle(color: Colors.grey),
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error', // Error handling if the stream throws an error
                              style: const TextStyle(color: Colors.red),
                            );
                          }
                          // Display loading or default text if the snapshot is still loading
                          return Text(
                            'Loading...',
                            style: const TextStyle(color: Colors.grey),
                          );
                        },
                      ),
                    ],
                    //comment count
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("touristSites")
                          .doc(widget.activity.id)
                          .collection("Comments")
                          .orderBy("CommentTime", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        // show loading circle if no data yet
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView(
                          shrinkWrap: true, //for nested lists
                          physics: const NeverScrollableScrollPhysics(),
                          children: snapshot.data!.docs.map((doc) {
                            // get the comment
                            final commentData =
                                doc.data() as Map<String, dynamic>;
                            // return the comment
                            return Comment(
                              text: commentData["CommentText"] ??
                                  "Texte non disponible",
                              user: commentData["CommentedBy"] ??
                                  "utilisateur anonyme ",
                              time: formatDate(commentData["CommentTime"]),
                            );
                          }).toList(),
                        );
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
