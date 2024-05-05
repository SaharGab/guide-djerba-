import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projet_pfe/models/touristSites.dart';
import 'package:projet_pfe/screens/detailscaferestau.dart';

class CafeRestaurantSection extends StatefulWidget {
  @override
  State<CafeRestaurantSection> createState() => _CafeRestaurantSectionState();
}

class _CafeRestaurantSectionState extends State<CafeRestaurantSection> {
  Future<List<TouristSite>> fetchCafesAndRestaurants() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('touristSites')
          .where('category', isEqualTo: 'Cafe & Restaurant')
          .get();

      List<TouristSite> sites =
          snapshot.docs.map((doc) => TouristSite.fromFirestore(doc)).toList();

      // Ajouter des logs pour vérifier les données récupérées
      print('Cafe & Restaurant data retrieved successfully: $sites');

      return sites;
    } catch (error) {
      // Gérer les erreurs et afficher un message de log
      print('Error fetching Cafe & Restaurant data: $error');
      throw error;
    }
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
        FutureBuilder<List<TouristSite>>(
          future: fetchCafesAndRestaurants(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No cafes or restaurants found');
            } else {
              List<TouristSite> sites = snapshot.data!;
              return Container(
                height: 200.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sites.length,
                  itemBuilder: (context, index) {
                    return CafeRestaurantCard(site: sites[index]);
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

class CafeRestaurantCard extends StatelessWidget {
  final TouristSite site;

  CafeRestaurantCard({required this.site});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CafeDetailScreen(cafe: site)));
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
                      site.imageUrls.isNotEmpty ? site.imageUrls.first : '',
                      height: 130.h,
                      width: 150.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Icons.error));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.h.w),
                  child: Text(
                    site.name,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.h.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 203, 136, 49),
                        size: 20.sp,
                      ),
                      Text(
                        "Djerba Island", // Adjust location display
                        style: GoogleFonts.montserrat(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
