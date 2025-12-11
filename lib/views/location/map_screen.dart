import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';

class CustomMapScreen extends StatefulWidget {
  final LatLng initialPosition;

  const CustomMapScreen({super.key, required this.initialPosition});

  @override
  _CustomMapScreenState createState() => _CustomMapScreenState();
}

class _CustomMapScreenState extends State<CustomMapScreen> {
  late GoogleMapController mapController;
  BitmapDescriptor? customMarker;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
  customMarker = await BitmapDescriptor.asset(
    const ImageConfiguration(size: Size(48, 48)), // Specify the size
    'images/icons8-marker-48.png', // Make sure the path is correct
  );
  setState(() {});
}

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setCustomMapStyle();
  }

  void _setCustomMapStyle() async {
    String style = await DefaultAssetBundle.of(context).loadString('assets/map_style.json');
    mapController.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    return SmartScaffold(
      body: customMarker == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.initialPosition,
                zoom: 13.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: widget.initialPosition,
                  icon: customMarker!,
                ),
              },
            ),
    );
  }
}
