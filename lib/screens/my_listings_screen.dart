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
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final provider = context.watch<ListingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: StreamBuilder<List<PlaceModel>>(
        stream: provider.filteredListings,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          // Filter only the ones I created
          final myDocs = snapshot.data!.where((p) => p.createdBy == uid).toList();

          if (myDocs.isEmpty) return const Center(child: Text('You haven\'t added any places yet.'));

          return ListView.builder(
            itemCount: myDocs.length,
            itemBuilder: (context, index) {
              final place = myDocs[index];
              return ListTile(
                title: Text(place.name),
                subtitle: Text(place.category),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => provider.deletePlace(place.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPlaceScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}