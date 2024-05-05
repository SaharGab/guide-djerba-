import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:projet_pfe/models/touristSites.dart';

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
                  ? _buildHotelItemCard(snapshot.data![index])
                  : _buildItemCard(snapshot.data![index]);
            },
          );
        },
      ),
    );
  }

  // Fonction pour récupérer des données spécifiques à une catégorie
  Future<List<TouristSite>> _fetchItemsForCategory(String category) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('touristSites')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) => TouristSite.fromFirestore(doc)).toList();
  }

  Widget _buildHotelItemCard(TouristSite site) {
    return Card(
      margin: EdgeInsets.all(10.h.w),
      elevation: 4,
      clipBehavior: Clip.antiAlias, // Pour une belle bordure arrondie
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
                // Icônes d'étoiles pour la notation
                Row(
                  children: List.generate(
                      4,
                      (index) =>
                          Icon(Icons.star, color: Colors.amber, size: 20.h.w)),
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'More Info',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemCard(TouristSite site) {
    return Card(
      margin: EdgeInsets.all(10.h.w),
      elevation: 4,
      clipBehavior: Clip.antiAlias, // Pour une belle bordure arrondie
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
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Ajouter une action spécifique pour plus d'informations
                      },
                      child: Text(
                        'More Info',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ]))
        ],
      ),
    );
  }
}
