import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projet_pfe/models/touristSites.dart';
import 'package:projet_pfe/screens/accommodationsection.dart';
import 'package:projet_pfe/screens/detailscaferestau.dart';
import 'package:projet_pfe/screens/homepage.dart';
import 'package:projet_pfe/screens/seeplan.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String category;

  CategoryDetailsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Color.fromARGB(234, 16, 132, 155),
      ),
      body: FutureBuilder<List<TouristSite>>(
        future: _fetchItemsForCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text("No data found"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return category == "Accommodation"
                  ? _buildHotelItemCard(context, snapshot.data![index])
                  : _buildItemCard(context, snapshot.data![index]);
            },
          );
        },
      ),
    );
  }

  // Function to fetch items specific to a category
  Future<List<TouristSite>> _fetchItemsForCategory(String category) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('touristSites')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) => TouristSite.fromFirestore(doc)).toList();
  }

  Widget _buildHotelItemCard(BuildContext context, TouristSite site) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            switch (site.category) {
              case 'Accommodation':
                return DetailsScreen(accommodation: site);
              case 'Cafe & Restaurant':
                return CafeDetailScreen(cafe: site);
              case 'Activities':
                return SeePlan(activity: site);
              case 'To Explore':
                return PlaceDetailsScreen(place: site);
              default:
                return Scaffold(
                    body:
                        Center(child: Text('No page found for this category')));
            }
          }),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10.h.w),
        elevation: 4,
        clipBehavior: Clip.antiAlias, // For a nice rounded border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              site.imageUrls.isNotEmpty
                  ? site.imageUrls.first
                  : 'https://via.placeholder.com/400x200',
              height: 200.h,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.all(10.h.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    site.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, TouristSite site) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            switch (site.category) {
              case 'Accommodation':
                return DetailsScreen(accommodation: site);
              case 'Cafe & Restaurant':
                return CafeDetailScreen(cafe: site);
              case 'Activities':
                return SeePlan(activity: site);
              case 'To Explore':
                return PlaceDetailsScreen(place: site);
              default:
                return Scaffold(
                    body:
                        Center(child: Text('No page found for this category')));
            }
          }),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10.h.w),
        elevation: 4,
        clipBehavior: Clip.antiAlias, // For a nice rounded border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              site.imageUrls.isNotEmpty
                  ? site.imageUrls.first
                  : 'https://via.placeholder.com/400x200',
              height: 200.h,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.all(10.h.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    site.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    site.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
