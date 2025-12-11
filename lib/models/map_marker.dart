import 'package:latlong2/latlong.dart';
class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location; // Use LatLng from latlong2
  final int? rating;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.rating,
  });
}


