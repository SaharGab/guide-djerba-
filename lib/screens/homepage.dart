import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet_pfe/models/models.dart';
import 'package:projet_pfe/models/touristSites.dart';
import 'package:projet_pfe/screens/accommodationsection.dart';
import 'package:projet_pfe/screens/autourdemoi.dart';
import 'package:projet_pfe/screens/caferestaurantsection.dart';
import 'package:projet_pfe/screens/categorydetailsscreen.dart';
import 'package:projet_pfe/screens/data_base_service.dart';
import 'package:projet_pfe/screens/recommendedplans.dart';
import 'package:projet_pfe/screens/storyscreen.dart';
import 'package:projet_pfe/widgets/comment.dart';
import 'package:projet_pfe/widgets/comment_button.dart';
import 'package:projet_pfe/widgets/helper_methods.dart';
import 'package:projet_pfe/widgets/rating_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  Future<List<TouristSite>> fetchToExploreSites() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('touristSites')
        .where('category', isEqualTo: 'To Explore')
        .get();

    return snapshot.docs.map((doc) => TouristSite.fromFirestore(doc)).toList();
  }

  Future<int> _getTouristSiteCount(String category) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('touristSites')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs.length;
  }

  Future<int> _getEventCount() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('events').get();
    return snapshot.docs.length;
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTitleSection("Upcoming Events", _getEventCount(), "Events"),
            SizedBox(height: 10),
            _buildEventsSection(),
            SizedBox(height: 2),
            _buildTitleSection("Places to Visit",
                _getTouristSiteCount("To Explore"), "To Explore"),
            SizedBox(height: 6),
            _buildPlacesToVisitSection(),
            _buildbox(),
            _buildTitleSection("Popular Hotels",
                _getTouristSiteCount("Accommodation"), "Accommodation"),
            SizedBox(height: 10),
            AccommodationSection(),
            SizedBox(height: 10),
            _buildTitleSection("Coffe shops and restaurants",
                _getTouristSiteCount("Cafe & Restaurant"), "Cafe & Restaurant"),
            SizedBox(height: 10),
            CafeRestaurantSection(),
            _buildTitleSection("Recommended plans",
                _getTouristSiteCount("Activities"), "Activities"),
            RecommendedPlans(context: context),
            // Adjusted section
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(
      String title, Future<int> itemCountFuture, String category) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
                fontSize: 17, fontWeight: FontWeight.w600),
          ),
          FutureBuilder<int>(
            future: itemCountFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryDetailsScreen(category: category),
                    ),
                  );
                },
                child: Text(
                  'See all (${snapshot.data})',
                  style: GoogleFonts.montserrat(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection() {
    return StreamBuilder<List<DataModel>>(
      stream: _databaseService.getEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return storyCard(snapshot.data!, index);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildPlacesToVisitSection() {
    return FutureBuilder<List<TouristSite>>(
      future: fetchToExploreSites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No places to explore found.'));
        }
        var toExploreSites = snapshot.data!;
        return Container(
          height: 290,
          child: Swiper(
            itemHeight: 290,
            itemWidth: 430,
            layout: SwiperLayout.TINDER,
            loop: true,
            itemBuilder: (context, index) {
              TouristSite site = toExploreSites[index];
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(site.imageUrls.last),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                          icon: Image.asset(
                            'icons/heart 1.png',
                            color: Colors.white,
                            height: 30,
                            width: 25,
                          ),
                          onPressed: () async {})),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlaceDetailsScreen(
                                      place: toExploreSites[index],
                                    )));
                      },
                      child: Text("More Details"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            Color.fromARGB(200, 18, 120, 171), // Text color
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                        // Button styling
                      ),
                    ),
                  ), // ... other Stack children, like the favorite icon and the button
                ],
              );
            },
            itemCount: toExploreSites.length,
          ),
        );
      },
    );
  }

  Widget _buildbox() {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.purple,
            ],
          )
          // Adjust the color to match your design

          ),
      child: Column(
        children: [
          Text(
            'Discover Nearby Events & Places and see what’s happening around you',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AutourDeMoi()));
            },
            child: Text('Allow access to location'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent, // Button text color
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget storyCard(List<DataModel> allStories, int index) {
    DataModel data = allStories[index];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                StoryScreen(stories: allStories, initialStoryIndex: index),
          ),
        );
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                data.imageUrl,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 17, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceDetailsScreen extends StatefulWidget {
  final TouristSite place;

  PlaceDetailsScreen({required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final _commentTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  // add a comment
  void addComment(String commentText) {
    final email = FirebaseAuth.instance.currentUser!.email;
    // write the comment to firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection("touristSites")
        .doc(widget.place.id)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": email,
      "CommentTime": Timestamp.now(),
    });
  }

  //show a dialog box for adding comment

  void showCommentDialog() {
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
        .doc(widget.place.id);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      var cafeSnapshot = await transaction.get(cafeRef);

      if (!cafeSnapshot.exists) {
        throw Exception("Café does not exist!");
      }

      double oldRating = cafeSnapshot.data()?['rating'] ?? 0.0;
      int oldCount = cafeSnapshot.data()?['ratingCount'] ?? 0;

      double newAverage = ((oldRating * oldCount) + newRating) / (oldCount + 1);
      int newCount = oldCount + 1;

      transaction
          .update(cafeRef, {'rating': newAverage, 'ratingCount': newCount});
    });
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
              width: 25,
              height: 30,
            ),
            onPressed: () {
              // Implement favorite logic for 'place'
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
              height: 300,
              child: PageView.builder(
                itemCount: widget.place.imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.place.imageUrls[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            // Description and Other Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Place Name in Bold
                  Text(
                    widget.place.name,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Location with Icon
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.black),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.place.location,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Description Paragraph
                  Text(
                    widget.place.description,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16),
                  RatingWidget(
                    initialRating:
                        0, // Charger cette valeur depuis Firestore si déjà noté
                    onRatingChanged: (rating) {
                      updateRating(rating);
                      showRatingFeedback(
                          rating); // Afficher le feedback basé sur la note
                    },
                  ),

                  // View Map Button
                  Column(
                    children: [
                      CommentButton(onTap: showCommentDialog),
                      Text(
                        '0',
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                    //comment count
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("touristSites")
                          .doc(widget.place.id)
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
