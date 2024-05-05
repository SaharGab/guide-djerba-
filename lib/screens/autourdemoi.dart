import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AutourDeMoi extends StatefulWidget {
  const AutourDeMoi({Key? key}) : super(key: key);

  @override
  State<AutourDeMoi> createState() => _AutourDeMoiState();
}

class _AutourDeMoiState extends State<AutourDeMoi> {
  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    _location = Location();
    _cameraPosition = CameraPosition(
        target: LatLng(33.8370616,
            10.9970700), // this is just the example lat and lng for initializing
        zoom: 15);
    _initLocation();
    getTouristSites();
  }

  //function to listen when we move position
  _initLocation() {
    //use this to go to current location instead
    _location?.getLocation().then((location) {
      _currentLocation = location;
    });
    _location?.onLocationChanged.listen((newLocation) {
      _currentLocation = newLocation;
      moveToPosition(LatLng(_currentLocation?.latitude ?? 33.8370616,
          _currentLocation?.longitude ?? 10.9970700));
    });
  }

  moveToPosition(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 13)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMarker() {
    return Container(
      width: 40.w,
      height: 40.h,
      padding: EdgeInsets.all(2.h.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 6)
          ]),
      child: ClipOval(child: Image.asset("images/djerbaa.png")),
    );
  }

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          markers: Set.from(_markers),
          onMapCreated: (GoogleMapController controller) {
            // now we need a variable to get the controller of google map
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
        ),
        Positioned.fill(
            child: Align(alignment: Alignment.center, child: _getMarker()))
      ],
    );
  }

  void getTouristSites() async {
    List<Marker> _markers = [];
    FirebaseFirestore.instance
        .collection('touristSites')
        .where('location', isEqualTo: 'Djerba')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _markers.clear();
        querySnapshot.docs.forEach((doc) {
          GeoPoint pos = doc[
              'position']; // Assurez-vous que vous stockez des GeoPoint dans Firestore
          _markers.add(Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(pos.latitude, pos.longitude),
            infoWindow: InfoWindow(title: doc['name']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
          ));
        });
      });
    });
  }
}
