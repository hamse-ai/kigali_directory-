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
  String _address = ''; // Correctly initialized
  String _description = '';

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final provider = context.read<ListingsProvider>();
      final user = FirebaseAuth.instance.currentUser;

      final newPlace = PlaceModel(
        id: '', 
        name: _name,
        category: _category,
        address: _address, // Now populated from the form
        contact: '078-000-000', 
        description: _description,
        latitude: -1.9441, 
        longitude: 30.0619,
        createdBy: user?.uid ?? '',
        timestamp: DateTime.now(),
      );

      await provider.addPlace(newPlace);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch loading state to disable button
    final isLoading = context.watch<ListingsProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Kigali Listing')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Business Name'),
              validator: (v) => v!.isEmpty ? 'Enter a name' : null,
              onSaved: (v) => _name = v!,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: _category,
              items: ['Café', 'Pharmacy', 'Hospital', 'Hotel', 'Resturant', 'Supermarket']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v.toString()),
            ),
            const SizedBox(height: 12),
            // ADDED ADDRESS FIELD
            TextFormField(
              decoration: const InputDecoration(labelText: 'Physical Address (e.g., Kimironko Road)'),
              validator: (v) => v!.isEmpty ? 'Enter an address' : null,
              onSaved: (v) => _address = v!,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onSaved: (v) => _description = v ?? '',
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D1B3E),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                : const Text('Save to Directory', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}