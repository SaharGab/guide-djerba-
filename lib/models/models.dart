import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  final String title;
  final String description;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String category;

  DataModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.category,
  });

  // Méthode pour créer un DataModel depuis un document Firestore
  factory DataModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return DataModel(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      startDate:
          (data['startDate'] as Timestamp).toDate(), // Conversion en DateTime
      endDate:
          (data['endDate'] as Timestamp).toDate(), // Conversion en DateTime
      location: data['location'] ?? '',
      category:
          data['categoryEvent'] ?? '', // ou categorySites selon votre structure
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'startDate':
          Timestamp.fromDate(startDate), // Conversion de DateTime à Timestamp
      'endDate':
          Timestamp.fromDate(endDate), // Conversion de DateTime à Timestamp
      'location': location,
      'categoryEvent': category, // ou 'categorySites' selon votre structure
    };
  }
}
