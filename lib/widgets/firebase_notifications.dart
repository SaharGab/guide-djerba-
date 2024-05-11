import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:projet_pfe/main.dart'; // Assurez-vous que cette importation est correcte pour votre projet

class FirebaseNotifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialiser les notifications pour cet appareil ou cette application
  Future<void> initNotifications(String userId) async {
    await _firebaseMessaging.requestPermission();

    // Obtenir et stocker le token initial
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      _updateUserToken(userId, token);
    }

    // Écouter les mises à jour du token
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _updateUserToken(userId, newToken);
    });

    handleBackgroundNotification();
  }

  void _updateUserToken(String userId, String token) {
    _firestore
        .collection('Users')
        .doc(userId)
        .update({'fcmToken': token}).catchError((error) {
      print("Error updating token: $error");
    });
  }

  // Gérer les notifications reçues quand l'application est en arrière-plan
  Future<void> handleBackgroundNotification() async {
    FirebaseMessaging.onMessage.listen(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        handleMessage(message);
      }
    });
  }

  // Gérer les notifications quand elles sont reçues
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState!.pushNamed(
      '/notifications',
      arguments: message,
    );
  }

  void setupNotificationsForUser(String userId) {
    initNotifications(userId);
  }
}