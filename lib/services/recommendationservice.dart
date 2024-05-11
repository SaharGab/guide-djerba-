import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecommendationService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer les préférences de l'utilisateur
  Future<Map<String, dynamic>> getUserPreferences(String userId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('Users').doc(userId).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      return data['questionnaire'] ?? {};
    } else {
      debugPrint("No user document found for userId: $userId");
      return {}; // Retourner un dictionnaire vide si aucun document utilisateur n'est trouvé
    }
  }

  // Obtenir les événements recommandés basés sur les préférences
  Future<List<DocumentSnapshot>> getRecommendedEvents(
      Map<String, dynamic> preferences) async {
    List<String> categories = determineCategories(preferences);
    QuerySnapshot query = await _firestore
        .collection('events')
        .where('categoryEvent', whereIn: categories)
        .get();

    return query.docs;
  }

  Future<List<DocumentSnapshot>> getRecommendedTouristSites(
      Map<String, dynamic> preferences) async {
    List<String> subcategories = determineActivityCategories(preferences);
    QuerySnapshot query = await _firestore
        .collection('touristSites')
        .where('category', isEqualTo: 'Activities')
        .where('subcategory', whereIn: subcategories)
        .get();

    return query.docs;
  }

// Déterminer les sous-catégories basées sur les préférences pour les touristSites
  List<String> determineActivityCategories(Map<String, dynamic> preferences) {
    List<String> subcategories = [];

    // Mapping basé sur le type de voyageur (q1)
    const Map<String, String> travelTypeToActivitySubcategory = {
      'Adventure Seeker': 'Entertainment',
      'Relaxation Enthusiast': 'Relaxation',
      'Cultural Explorer': 'Cultural',
      'Nature Lover': 'Entertainment',
      'other': 'Entertainment'
    };

    // Mapping basé sur les activités préférées (q2)
    const Map<String, String> activityPreferenceToSubcategory = {
      'Beach Relaxation': 'Relaxation',
      'Sightseeing': 'Cultural',
      'Shopping': 'Entertainment',
      'Hiking': 'Entertainment'
    };

    // Utilisez q1 pour déterminer la première suggestion de sous-catégorie
    if (preferences.containsKey('q1')) {
      String travelType = preferences['q1'];
      subcategories
          .add(travelTypeToActivitySubcategory[travelType] ?? 'Entertainment');
    }

    // Utilisez q2 pour ajouter une autre sous-catégorie pertinente
    if (preferences.containsKey('q2')) {
      String activityPreference = preferences['q2'];
      subcategories.add(activityPreferenceToSubcategory[activityPreference] ??
          'Entertainment');
    }

    // Éliminez les doublons éventuels
    subcategories = subcategories.toSet().toList();

    debugPrint("Mapped activity subcategories: $subcategories");
    return subcategories;
  }

  // Déterminer les catégories basées sur les préférences
  List<String> determineCategories(Map<String, dynamic> preferences) {
    List<String> categories = [];
    // Mapping basé sur le type de voyageur (q1)
    const Map<String, List<String>> travelTypeToCategories = {
      'Adventure Seeker': [
        'Sporting Events - Tournaments',
        'Educational and Environmental Activities - Wildlife Tours'
      ],
      'Relaxation Enthusiast': [
        'Food and Beverage Events - Wine Tastings',
        'Family-Friendly Events - Carnivals'
      ],
      'Cultural Explorer': [
        'Cultural Events - Music Festivals',
        'Cultural Events - Theater Productions'
      ],
      'Nature Lover': [
        'Educational and Environmental Activities - Wildlife Tours'
      ],
      'other': ['Fairs - Craft Fairs', 'Fairs - Trade Fairs']
    };

    if (preferences.containsKey('q1')) {
      String travelType = preferences['q1'];
      categories.addAll(travelTypeToCategories[travelType] ?? []);
    }

    // Mapping basé sur les préférences de vie nocturne (q3)
    if (preferences.containsKey('q3') &&
        preferences['q3'] is Map<String, dynamic>) {
      Map<String, dynamic> nightlifePreferences = preferences['q3'];
      if (nightlifePreferences['Lounge cafes'] == true) {
        categories.add('Nightlife and Entertainment - DJ Nights');
      }
      if (nightlifePreferences['Themed nightclubs'] == true) {
        categories.add('Nightlife and Entertainment - Themed Parties');
      }
      if (nightlifePreferences['Beach bars'] == true) {
        categories.add('Nightlife and Entertainment - DJ Nights');
      }
      if (nightlifePreferences['Live music restaurants'] == true) {
        categories.add('Nightlife and Entertainment - DJ Nights');
      }
      if (nightlifePreferences['Unique spots'] == true) {
        categories.add('Nightlife and Entertainment - Themed Parties');
      }
    }

    debugPrint("Mapped categories: $categories");
    return categories;
  }
}
