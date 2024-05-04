import 'package:cloud_firestore/cloud_firestore.dart';

class TouristSite {
  final String id;
  final String category;
  final String description;
  final List<String> imageUrls;
  final String location;
  final String name;

  TouristSite({
    required this.id,
    required this.category,
    required this.description,
    required this.imageUrls,
    required this.location,
    required this.name,
  });

  factory TouristSite.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return TouristSite(
      id: doc.id,
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      imageUrls: List.from(data['imageUrls'] ?? []),
      location: data['location'] ?? '',
      name: data['name'] ?? '',
    );
  }
}
