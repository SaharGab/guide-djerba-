import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
  @override
  void initState() {
    super.initState();
    _checkFavorite();
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
                    widget.accommodation.name, // Display the accommodation name
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
                          widget.accommodation.location, // Display the location
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),

                  // Accommodation Name in bold

                  SizedBox(height: 16.h),
                  // Description Paragraph
                  Text(
                    widget.accommodation.description,
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // "View Map" Button
                  Padding(
                    padding: EdgeInsets.only(left: 100.w),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement view map logic
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
                        'View map'.toUpperCase(), // Button text
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
