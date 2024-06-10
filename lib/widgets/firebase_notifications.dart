import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:projet_pfe/main.dart'; // Assurez-vous que cette importation est correcte pour votre projet

class FirebaseNotifications {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initNotifications(String userId) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Supprimer l'ancien token pour forcer la génération d'un nouveau
      await _firebaseMessaging.deleteToken();

      // Obtenir et stocker le nouveau token
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        _updateUserToken(userId, token);
      }

      // Écouter les mises à jour du token
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        _updateUserToken(userId, newToken);
      });

      handleBackgroundNotification();
    } else {
      print('Permission non accordée');
    }
  }

  void _updateUserToken(String userId, String token) {
    _firestore
        .collection('Users')
        .doc(userId)
        .update({'fcmToken': token}).catchError((error) {
      print("Erreur lors de la mise à jour du token : $error");
    });
  }

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
