import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/listings_provider.dart';
import '../models/place_model.dart';

class MapFullViewScreen extends StatefulWidget {
  const MapFullViewScreen({super.key});

  @override
  State<MapFullViewScreen> createState() => _MapFullViewScreenState();
}

class _MapFullViewScreenState extends State<MapFullViewScreen> {
  // Centering the map on Kigali coordinates
  static const LatLng _kigaliCenter = LatLng(-1.9441, 30.0619);
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final listingsProvider = context.watch<ListingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kigali Directory Map', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D1B3E))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<PlaceModel>>(
        stream: listingsProvider.filteredListings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final places = snapshot.data ?? [];

          // Convert PlaceModel data into Map Markers
          Set<Marker> markers = places.map((place) {
            return Marker(
              markerId: MarkerId(place.id),
              position: LatLng(place.latitude, place.longitude),
              infoWindow: InfoWindow(
                title: place.name,
                snippet: '${place.category} - ${place.address}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            );
          }).toSet();

          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _kigaliCenter,
              zoom: 13.0,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: markers,
            myLocationEnabled: true,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
          );
        },
      ),
    );
  }
}