import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String fullname;
  final String password;
  String role;

  User({
    required this.email,
    required this.fullname,
    required this.password,
    this.role = 'explorer', // Set 'explorer' as the default role
  });

  // Updated to accept parameters
  Future<void> registerUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await storeDetails(userCredential.user!.uid);
    } catch (error) {
      print('Error registering user $error');
    }
  }

  Future<void> storeDetails(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'email': this.email,
        'fullname': this.fullname,
        'role': this.role, // Store role in Firestore
      });
    } catch (e) {
      print('Error storing user details: $e');
    }
  }
}
