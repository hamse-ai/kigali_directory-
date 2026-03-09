import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/place_model.dart';
import '../providers/listings_provider.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _category = 'Café';
  String _address = '';
  String _description = '';
  final double _lat = -1.9441; // Default Kigali Lat
  final double _lng = 30.0619; // Default Kigali Lng

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final newPlace = PlaceModel(
        id: '', // Firestore generates this
        name: _name,
        category: _category,
        address: _address,
        contact: '0780000000', // Placeholder
        description: _description,
        latitude: _lat,
        longitude: _lng,
        createdBy: FirebaseAuth.instance.currentUser!.uid,
        timestamp: DateTime.now(),
      );

      await context.read<ListingsProvider>().addPlace(newPlace);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Place')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Place Name'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
              onSaved: (v) => _name = v!,
            ),
            DropdownButtonFormField(
              initialValue: _category,
              items: ['Café', 'Pharmacy', 'Hospital', 'Hotel']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v.toString()),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Address'),
              onSaved: (v) => _address = v!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onSaved: (v) => _description = v!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Save Listing')),
          ],
        ),
      ),
    );
  }
}