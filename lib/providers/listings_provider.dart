import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/place_model.dart';

class ListingsProvider with ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // This will be called by the UI to add a place
  Future<bool> createPlace(PlaceModel place) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.addPlace(place);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Real-time Stream for the Directory
  Stream<List<PlaceModel>> get allListings => _service.getListings();
}