import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/listings_provider.dart';
import '../models/place_model.dart';
import 'add_place_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // We watch the provider to rebuild when a listing is deleted
    final provider = context.watch<ListingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<List<PlaceModel>>(
        stream: provider.filteredListings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Filter to show only listings created by the current user
          final myPlaces = snapshot.data?.where((p) => p.createdBy == uid).toList() ?? [];

          if (myPlaces.isEmpty) {
            return const Center(
              child: Text('You haven\'t added any bookmarks yet.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: myPlaces.length,
            itemBuilder: (context, index) {
              final place = myPlaces[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(place.category),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    onPressed: () async {
                      // Show a quick confirmation dialog (Good for the "Excellent" grade!)
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Listing?'),
                          content: const Text('This will permanently remove it from Kigali City.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        provider.deletePlace(place.id);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      // FAB to navigate to the Add Place screen
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0D1B3E),
        onPressed: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => const AddPlaceScreen())
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}