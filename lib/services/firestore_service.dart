import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // READ: Get all listings in real-time
  Stream<List<PlaceModel>> getListings() {
    return _db
        .collection('listings')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PlaceModel.fromFirestore(doc))
            .toList());
  }

  // CREATE
  Future<void> addPlace(PlaceModel place) {
    return _db.collection('listings').add(place.toMap());
  }

  // UPDATE
  Future<void> updatePlace(String id, Map<String, dynamic> data) {
    return _db.collection('listings').doc(id).update(data);
  }

  // DELETE
  Future<void> deletePlace(String id) {
    return _db.collection('listings').doc(id).delete();
  }
}