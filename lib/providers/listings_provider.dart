import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/place_model.dart';

class ListingsProvider with ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  
  

  List<PlaceModel> _allPlaces = [];
  bool _isLoading = false;
  String _searchQuery = "";
  String _selectedCategory = "All"; // Fix to use correct category name later

  ListingsProvider() {
    _listenToPlaces();
  }

  void _listenToPlaces() {
    _isLoading = true;
    notifyListeners();
    
    _service.getListings().listen((places) {
      _allPlaces = places;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint("Error loading places: $e");
      _isLoading = false;
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;

  List<PlaceModel> get filteredPlaces {
    return _allPlaces.where((place) {
      final matchesSearch = place.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == "All" || place.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

// lib/providers/listings_provider.dart
Future<void> addPlace(PlaceModel place) async {
  _isLoading = true;
  notifyListeners(); // This disables the button
  try {
    await _service.addPlace(place);
  } catch (e) {
    debugPrint("Error saving: $e");
  } finally {
    _isLoading = false;
    notifyListeners(); // This re-enables the button!
  }
}

  Future<void> deletePlace(String id) async {
    await _service.deletePlace(id);
    notifyListeners();
  }
}