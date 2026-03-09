import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/listings_provider.dart';
import '../models/place_model.dart';
import '../widgets/service_card.dart';

class DirectoryScreen extends StatelessWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listingsProvider = context.watch<ListingsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Kigali City', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. Category Chips (Cafes, Pharmacies, etc.)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Cafés', 'Pharmacies', 'Hospitals'].map((cat) {
                final isSelected = listingsProvider.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => listingsProvider.setCategory(cat),
                    selectedColor: const Color(0xFF0D1B3E),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // 2. Search Bar
            // Inside directory_screen.dart -> build method
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  // This sends the text to your provider in real-time
                  context.read<ListingsProvider>().setSearchQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search for shops, cafes...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Near You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          // 3. The Real-time List
          Expanded(
            child: StreamBuilder<List<PlaceModel>>(
              stream: listingsProvider.filteredListings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data ?? [];
                if (docs.isEmpty) return const Center(child: Text('No places found.'));

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) => ServiceCard(place: docs[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}