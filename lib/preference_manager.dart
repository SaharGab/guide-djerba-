import 'package:cloud_firestore/cloud_firestore.dart';

class PreferenceManager {
  static List<String> determinePreferences(Map<String, dynamic> responses) {
    List<String> preferences = [];

    // Q1: Type of Traveler
    if (responses.containsKey('q1')) {
      switch (responses['q1']) {
        case 'Adventure Seeker':
          preferences.addAll([
            'Sporting Events - Tournaments',
            'Nightlife and Entertainment - DJ Nights',
            'Food and Beverage Events - Food Festivals',
            'Family-Friendly Events - Carnivals'
          ]);
          break;
        case 'Relaxation Enthusiast':
          preferences.addAll(['Food and Beverage Events - Wine Tastings']);
          break;
        case 'Cultural Explorer':
          preferences.addAll([
            'Cultural Events - Music Festivals',
            'Cultural Events - Theater Productions'
          ]);
          break;
        case 'Nature Lover':
          preferences.addAll(
              ['Educational and Environmental Activities - Wildlife Tours']);
          break;
        case 'Other':
          preferences.addAll(['Family-Friendly Events - Carnivals']);
          break;
      }
    }

    // Q2: Activities Enjoyed
    if (responses.containsKey('q2')) {
      if (responses['q2'].contains('Beach Relaxation')) {
        preferences.add('Nightlife and Entertainment - DJ Nights');
      }
      if (responses['q2'].contains('Sightseeing')) {
        preferences.add('Cultural Events - Theater Productions');
      }
      if (responses['q2'].contains('Shopping')) {
        preferences.add('Fairs - Craft Fairs');
      }
      if (responses['q2'].contains('Hiking')) {
        preferences
            .add('Educational and Environmental Activities - Wildlife Tours');
      }
    }

    // Q3: Nightlife Preferences
    if (responses.containsKey('q3')) {
      responses['q3'].forEach((nightlifePreference) {
        switch (nightlifePreference) {
          case 'Lounge cafes':
            preferences.add('Nightlife and Entertainment - Themed Parties');
            break;
          case 'Themed nightclubs':
            preferences.add('Nightlife and Entertainment - Themed Parties');
            break;
          case 'Beach bars':
            preferences.add('Nightlife and Entertainment - DJ Nights');
            break;
          case 'Live music restaurants':
            preferences.add('Cultural Events - Music Festivals');
            break;
          case 'Unique spots':
            preferences.add('Fairs - Trade Fairs');
            break;
        }
      });
    }

    // Q4: Type of Accommodations
    if (responses.containsKey('q4')) {
      switch (responses['q4']) {
        case 'Luxury Hotels':
          preferences.add('Food and Beverage Events - Wine Tastings');
          break;
        case 'Guesthouses':
          preferences.add('Fairs - Craft Fairs');
          break;
        case 'Medina Riads':
          preferences.add('Cultural Events - Theater Productions');
          break;
        case 'Private Villas':
          preferences.add('Food and Beverage Events - Food Festivals');
          break;
      }
    }

    return preferences;
  }
}

Future<void> updateUserPreferences(
    String userId, Map<String, dynamic> questionnaireResponses) async {
  // Détermine les préférences basées sur les réponses au questionnaire
  List<String> preferences =
      PreferenceManager.determinePreferences(questionnaireResponses);

  // Vérifie que nous avons des préférences à stocker
  if (preferences.isNotEmpty) {
    // Crée ou met à jour le champ preferences dans le document de l'utilisateur
    await FirebaseFirestore.instance.collection('Users').doc(userId).set(
        {
          'preferences': preferences,
        },
        SetOptions(
            merge:
                true)); // Utilisez merge pour ne pas écraser les autres champs
  }
  try {
    await updateUserPreferences(userId, questionnaireResponses);
    print('Preferences updated successfully.');
  } catch (e) {
    print('Error updating preferences: $e');
  }
}

Future<List<Map<String, dynamic>>> fetchAndSortEvents(String userId) async {
  // Récupération des données utilisateur
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userId).get();
  Map<String, dynamic>? userData = userDoc.data()
      as Map<String, dynamic>?; // Cast sûr avec vérification de nullité

  if (userData == null) {
    throw Exception('User data is null for user $userId');
  }

  if (!userData.containsKey('questionnaire')) {
    throw Exception('No questionnaire data available for user $userId');
  }

  Map<String, dynamic> questionnaire = userData['questionnaire']
      as Map<String, dynamic>; // Cast sûr, assumant que le questionnaire existe

  List<String> preferences =
      PreferenceManager.determinePreferences(questionnaire);

  // Récupération des événements
  var querySnapshot =
      await FirebaseFirestore.instance.collection('events').get();
  List<Map<String, dynamic>> events = [];
  for (var doc in querySnapshot.docs) {
    var event = doc.data();
    event['id'] = doc.id;
    int score = 0;
    List<dynamic> tags = event['tags'];
    for (var tag in tags) {
      if (preferences.contains(tag)) {
        score++;
      }
    }
    event['score'] = score;
    events.add(event);
  }

  // Trier les événements par score en ordre décroissant
  events.sort((a, b) => b['score'].compareTo(a['score']));
  return events;
}
