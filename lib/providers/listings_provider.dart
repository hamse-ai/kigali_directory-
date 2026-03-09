import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/place_model.dart';

class ListingsProvider with ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  
  bool _isLoading = false;
  String _searchQuery = "";
  String _selectedCategory = "All";

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  Stream<List<PlaceModel>> get filteredListings {
    return _service.getListings().map((list) {
      return list.where((place) {
        final matchesSearch = place.name.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCat = _selectedCategory == "All" || place.category == _selectedCategory;
        return matchesSearch && matchesCat;
      }).toList();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addPlace(PlaceModel place) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.addPlace(place);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ADD THIS METHOD TO FIX THE ERROR IN MY_LISTINGS_SCREEN
  Future<void> deletePlace(String id) async {
    await _service.deletePlace(id);
    notifyListeners();
  }
}