import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projet_pfe/models/touristSites.dart';
import 'package:projet_pfe/screens/accommodationsection.dart';
import 'package:projet_pfe/screens/detailscaferestau.dart';
import 'package:projet_pfe/screens/homepage.dart';
import 'package:projet_pfe/screens/seeplan.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<TouristSite> searchResults = [];
  String selectedCategory = 'All categories';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      search(_searchController.text);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void search(String query) async {
    query = query.toLowerCase(); // Convert the query to lower case
    var collection = FirebaseFirestore.instance.collection('touristSites');
    try {
      QuerySnapshot querySnapshot;
      if (selectedCategory == 'All categories') {
        querySnapshot = await collection.get();
      } else {
        querySnapshot = await collection
            .where('category', isEqualTo: selectedCategory)
            .get();
      }
      List<TouristSite> sites = querySnapshot.docs
          .map((doc) => TouristSite.fromFirestore(doc))
          .where((site) {
        // Assumes 'name' is a direct field of TouristSite
        return site.name.toLowerCase().contains(query);
      }).toList();

      setState(() {
        searchResults = sites;
      });
    } catch (e) {
      debugPrint('Error searching Firestore: $e');
    }
  }

  Widget buildChips() {
    List<String> categories = [
      'All categories',
      'Accommodation',
      'Cafe & Restaurant',
      'Activities',
      'To Explore'
    ];
    return Container(
      height: 50.h, // Hauteur fixe pour le conteneur
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 4.w), // Espacement entre les chips
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: selectedCategory == categories[index],
              onSelected: (bool selected) {
                setState(() {
                  selectedCategory = categories[index];
                  search(_searchController
                      .text); // Met à jour la recherche en fonction de la catégorie
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Color.fromARGB(255, 18, 120, 171),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Search',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              search('');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.h.w),
            child: TextField(
              focusNode: _focusNode,
              controller: _searchController,
              decoration: InputDecoration(
                labelText:
                    _searchController.text.isEmpty && !_focusNode.hasFocus
                        ? 'Search for hotels, places, bars...'
                        : '',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) => _onSearchChanged(),
            ),
          ),
          buildChips(),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                TouristSite site = searchResults[
                    index]; // Assurez-vous que searchResults contient des objets TouristSite
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                  margin: EdgeInsets.all(8.h.w),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.w),
                    leading: site.imageUrls.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              site.imageUrls.first,
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons
                                    .error); // Shows an error icon if the image fails to load
                              },
                            ),
                          )
                        : SizedBox(
                            width: 50.w,
                            height: 50.h), // Empty box if no image URL
                    title: Text(
                      site.name,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      site.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp),
                    ),
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
                                  body: Center(
                                      child: Text(
                                          'No page found for this category')));
                          }
                        }),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
