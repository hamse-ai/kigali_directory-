import 'package:flutter/material.dart';
import '../models/place_model.dart';

class ServiceCard extends StatelessWidget {
  final PlaceModel place;
  const ServiceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 70, height: 70,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.storefront, color: Color(0xFF0D1B3E)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(place.category, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      const Text('4.3', style: TextStyle(fontWeight: FontWeight.bold)), // Simulated rating
                      const Spacer(),
                      const Text('0.6 km', style: TextStyle(color: Colors.grey)), // Simulated distance
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}