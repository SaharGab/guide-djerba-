import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:typed_data';

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
  List<Marker> _markers = [];

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
        zoom: 13);
    _initLocation();
    await getTouristSites();
    setState(
      () {
        _markers.add(
          Marker(
              markerId: MarkerId("initial_position"),
              position: LatLng(33.8370616, 10.9970700),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet),
              infoWindow: InfoWindow(title: "Initial Position")),
        );
      },
    );
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
        CameraPosition(target: latLng, zoom: 8)));
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

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          markers: Set<Marker>.from(_markers),
          onMapCreated: (GoogleMapController controller) {
            // now we need a variable to get the controller of google map
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
        ),
      ],
    );
  }

  Future<void> getTouristSites() async {
    FirebaseFirestore.instance
        .collection('touristSites')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('position') &&
            data['position'] is GeoPoint &&
            data['position'].latitude != null &&
            data['position'].longitude != null &&
            data.containsKey('imageUrls') &&
            data['imageUrls'].isNotEmpty) {
          GeoPoint pos = data['position'];
          var imageUrl =
              data['imageUrls'][0]; // Assuming 'imageUrls' is a List of Strings

          try {
            var markerIcon = await getMarkerIconFromUrl(imageUrl);
            setState(() {
              _markers.add(
                Marker(
                  markerId: MarkerId(doc.id),
                  position: LatLng(pos.latitude, pos.longitude),
                  infoWindow: InfoWindow(title: data['name']),
                  icon: markerIcon,
                ),
              );
            });
            print('Marker added with custom image');
          } catch (e) {
            print('Failed to load custom marker image: $e');
          }
        }
      });
    }).catchError((error) {
      print('Error retrieving tourist sites: $error');
    });
  }

  Future<BitmapDescriptor> getMarkerIconFromUrl(String imageUrl,
      {int width = 65, int height = 65}) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;

    ui.Codec codec = await ui.instantiateImageCodec(bytes);
    ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);

    // Prepare a canvas to draw the image with decoration
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(
        recorder,
        Rect.fromPoints(
            ui.Offset.zero, ui.Offset(width.toDouble(), height.toDouble())));
    final Paint paint = Paint()..isAntiAlias = true;
    final ui.Image image =
        await decodeImageFromList(byteData!.buffer.asUint8List());
    final Rect imageRect =
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    final Rect srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());

    // Draw shadow
    final Path shadowPath = Path()..addOval(imageRect);
    canvas.drawShadow(shadowPath, Colors.grey, 6, false);

    // Clip the image to an oval (rounded corners)
    canvas.clipPath(Path()..addOval(imageRect));

    // Draw the image
    canvas.drawImageRect(image, srcRect, imageRect, paint);

    // Draw a white border around the image
    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawOval(imageRect, paint);

    // Convert canvas to image, then to bytes
    final ui.Image markerAsImage =
        await recorder.endRecording().toImage(width, height);
    final ByteData? markerByteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List markerImageBytes = markerByteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(markerImageBytes);
  }
}
