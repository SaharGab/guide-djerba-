import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet_pfe/models/models.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<DataModel>> getEvents() {
    return _db
        .collection('events')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              return DataModel.fromFirestore(doc);
            } catch (e) {
              print('Error converting data: $e');
              return null;
            }
          })
          .where((item) => item != null)
          .cast<DataModel>()
          .toList();
    });
  }
}
