import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/screens/signup.dart';
import 'package:projet_pfe/widgets/comment.dart';
import 'package:projet_pfe/widgets/comment_button.dart';
import 'package:projet_pfe/widgets/helper_methods.dart';
import 'package:projet_pfe/widgets/rating_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_pfe/models/touristSites.dart';

class AccommodationSection extends StatefulWidget {
  @override
  State<AccommodationSection> createState() => _AccommodationSectionState();
}

class _AccommodationSectionState extends State<AccommodationSection> {
  Future<List<TouristSite>> fetchAccommodations() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('touristSites')
        .where('category', isEqualTo: 'Accommodation')
        .get();

    return snapshot.docs.map((doc) => TouristSite.fromFirestore(doc)).toList();
  }

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
    return Column(
      children: [
        // Add your header with the 'See all' button here
        FutureBuilder<List<TouristSite>>(
          future: fetchAccommodations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No accommodations found');
            } else {
              List<TouristSite> accommodations = snapshot.data!;
              return Container(
                height: 200, // Adjust as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: accommodations.length,
                  itemBuilder: (context, index) {
                    return AccommodationCard(
                        accommodation: accommodations[index]);
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class AccommodationCard extends StatelessWidget {
  final TouristSite accommodation;

  AccommodationCard({required this.accommodation});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // On tap, navigate to the details screen
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailsScreen(accommodation: accommodation),
        ));
      },
      child: Padding(
          padding: EdgeInsets.only(left: 15.w, bottom: 7.h),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 350.h,
              width: 160.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        accommodation.imageUrls.isNotEmpty
                            ? accommodation.imageUrls.first
                            : '',
                        height: 130.h,
                        width: 150.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                              child: Icon(Icons
                                  .error)); // Show error icon if image fails to load.
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0.h.w),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      accommodation.name,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0.h.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 203, 136, 49),
                          size: 20.h.w,
                        ),
                        Text(
                          "Djerba Island ",
                          style: GoogleFonts.montserrat(),
                        )
                      ],
                    ),
                  )
                  // Add a row for the stars here
                ],
              ),
            ),
          )),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  final TouristSite accommodation;

  DetailsScreen({required this.accommodation});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isFavorite = false;
  final _commentTextController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
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
        .doc(widget.accommodation.id)
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

  void _checkFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      _isFavorite = favorites.contains(widget.accommodation.id);
    });
  }

  void _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    if (favorites.contains(widget.accommodation.id)) {
      favorites.remove(widget.accommodation.id);
    } else {
      favorites.add(widget.accommodation.id);
    }
    await prefs.setStringList('favorites', favorites);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void updateRating(double newRating) async {
    var cafeRef = FirebaseFirestore.instance
        .collection('touristSites')
        .doc(widget.accommodation.id);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      var cafeSnapshot = await transaction.get(cafeRef);

      if (!cafeSnapshot.exists) {
        throw Exception("accommodation does not exist!");
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
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: _toggleFavorite,
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300.h,
              child: PageView.builder(
                itemCount: widget.accommodation.imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.accommodation.imageUrls[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.h.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget
                          .accommodation.name, // Display the accommodation name
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.black),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            widget
                                .accommodation.location, // Display the location
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
                      widget.accommodation.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
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

                    // Comment
                    Column(
                      children: [
                        CommentButton(onTap: showCommentDialog),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("touristSites")
                              .doc(widget.accommodation.id)
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
                            .doc(widget.accommodation.id)
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
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
