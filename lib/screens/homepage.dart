import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            SizedBox(height: 10.h),
            _buildEventsSection(),
            SizedBox(height: 2.h),
            _buildTitleSection("Places to Visit",
                _getTouristSiteCount("To Explore"), "To Explore"),
            SizedBox(height: 6.h),
            _buildPlacesToVisitSection(),
            _buildbox(),
            _buildTitleSection("Popular Hotels",
                _getTouristSiteCount("Accommodation"), "Accommodation"),
            SizedBox(height: 10.h),
            AccommodationSection(),
            SizedBox(height: 10.h),
            _buildTitleSection("Coffe shops and restaurants",
                _getTouristSiteCount("Cafe & Restaurant"), "Cafe & Restaurant"),
            SizedBox(height: 10.h),
            CafeRestaurantSection(),
            _buildTitleSection("Recommended plans for you",
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
      padding: EdgeInsets.only(top: 18.h, left: 20.w, right: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
                fontSize: 17.sp, fontWeight: FontWeight.w600),
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
                      fontSize: 16.sp, fontWeight: FontWeight.w600),
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
            height: 210.h,
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
          height: 290.h,
          child: Swiper(
            itemHeight: 290.h,
            itemWidth: 430.w,
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
                            height: 30.h,
                            width: 25.w,
                          ),
                          onPressed: () async {})),
                  Positioned(
                    bottom: 20.h,
                    left: 20.w,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDetailsScreen(
                              place: toExploreSites[index],
                            ),
                          ),
                        );
                      },
                      child: Text("More Details"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            Color.fromARGB(200, 18, 120, 171), // Text color
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 10.w),

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
      padding: EdgeInsets.all(15.h.w),
      margin: EdgeInsets.all(15.h.w),
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
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
        width: 120.w,
        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                data.imageUrl,
                height: 150.h,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Container(
                    height: 150.h,
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50.h.w,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.all(8.0.h.w),
              child: Text(
                data.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 17.sp, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceDetailsScreen extends StatelessWidget {
  final TouristSite place;

  PlaceDetailsScreen({required this.place});

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
              height: 300.h,
              child: PageView.builder(
                itemCount: place.imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    place.imageUrls[index],
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
                  // Place Name in Bold
                  Text(
                    place.name,
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
                          place.location,
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
                    place.description,
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // View Map Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement view map logic for 'place'
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.w, vertical: 12.h),
                      ),
                      child: Text(
                        'View map'.toUpperCase(),
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
