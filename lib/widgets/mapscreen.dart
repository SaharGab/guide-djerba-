import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String placeName;

  MapScreen(
      {required this.latitude,
      required this.longitude,
      required this.placeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeName),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId(placeName),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: placeName,
            ),
          ),
        },
      ),
    );
  }
}
