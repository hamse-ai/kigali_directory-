import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/listings_provider.dart';
import '../models/place_model.dart'; 
import '../widgets/service_card.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using watch to rebuild when filters change
    final listingsProvider = context.watch<ListingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kigali City', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // 1. Horizontal Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Cafés', 'Pharmacies', 'Hospitals'].map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: listingsProvider.selectedCategory == cat,
                    onSelected: (selected) => listingsProvider.setCategory(cat),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // 2. Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) => listingsProvider.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Search for a service',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // 3. The List (Fixed the "Object" error by adding <List<PlaceModel>>)
          Expanded(
            child: StreamBuilder<List<PlaceModel>>(
              stream: listingsProvider.filteredListings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // Fixed: Check snapshot.data directly
                final docs = snapshot.data ?? [];
                
                if (docs.isEmpty) {
                  return const Center(child: Text('No results found in Kigali'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return ServiceCard(place: docs[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}