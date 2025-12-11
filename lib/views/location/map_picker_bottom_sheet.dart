import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hiatunisie/constant.dart';
import 'package:hiatunisie/services/user_service.dart';
import 'package:hiatunisie/viewmodels/user_viewmodel.dart';
import 'package:hiatunisie/views/foodPreference/food_preferences_screen.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:hiatunisie/widgets/custom_toast.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerBottomSheet extends StatefulWidget {
  final Function(latLng.LatLng) onLocationPicked;
  
  final latLng.LatLng initialLocation;

  const MapPickerBottomSheet({super.key, 
    required this.onLocationPicked,
    required this.initialLocation,
  });

  @override
  _MapPickerBottomSheetState createState() => _MapPickerBottomSheetState();
}

class _MapPickerBottomSheetState extends State<MapPickerBottomSheet> {
  latLng.LatLng? pickedLocation;
  late MapController _mapController;
  bool showValidationButton = false;
  final TextEditingController _searchController = TextEditingController();
  List<Location> _suggestions = [];
  bool _isSearching = false;

  bool _isLoading =false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    pickedLocation = widget.initialLocation;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() async {
    if (_searchController.text.length > 2) {
      setState(() => _isSearching = true);
      try {
        final locations = await locationFromAddress(_searchController.text);
        setState(() {
          _suggestions = locations;
          _isSearching = false;
        });
      } catch (e) {
        setState(() {
          _suggestions = [];
          _isSearching = false;
        });
      }
    } else {
      setState(() => _suggestions = []);
    }
  }

  void _selectLocation(Location location) {
    final newLatLng = latLng.LatLng(location.latitude, location.longitude);
    setState(() {
      pickedLocation = newLatLng;
      showValidationButton = true;
      _suggestions = []; // Clear suggestions
      _searchController.text = ''; // Clear search
    });
    _mapController.move(newLatLng, 15);
    widget.onLocationPicked(newLatLng);
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final UserService userService = UserService();
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9, // Make it taller
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Search Bar with Suggestions
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search TextField
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Chercher une adresse',
                      hintStyle: const TextStyle(color: Colors.blueGrey),
                      prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.blueGrey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _suggestions = []);
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                
                // Loading indicator
                if (_isSearching)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: CircularProgressIndicator(color: kMainColor),
                  ),
                
                // Suggestions List
                if (_suggestions.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final location = _suggestions[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on, color: kMainColor),
                          title: FutureBuilder<List<Placemark>>(
                            future: placemarkFromCoordinates(
                              location.latitude,
                              location.longitude,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final placemark = snapshot.data!.first;
                                return Text(
                                  '${placemark.street}, ${placemark.locality}, ${placemark.country}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                              return const Text('En cours ...');
                            },
                          ),
                          onTap: () => _selectLocation(location),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          
          // Map takes remaining space
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(36.79250953369267, 10.190117943816045),
                    initialZoom: 11.0,
                    onTap: (tapPosition, latLng) {
                      setState(() {
                        pickedLocation = latLng;
                        showValidationButton = true;
                      });
                      widget.onLocationPicked(latLng);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://api.mapbox.com/styles/v1/boogeyy/clyg8q8e500uv01qv8bb8bftb/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYm9vZ2V5eSIsImEiOiJjbHlnNmpoYmEwN3k1MmlwbzB0NHZvdXg4In0.puEqRDXeCxmqCQkCEOUEUg",
                      additionalOptions: const {
                        'accessToken': "pk.eyJ1IjoiYm9vZ2V5eSIsImEiOiJjbHlnNmpoYmEwN3k1MmlwbzB0NHZvdXg4In0.puEqRDXeCxmqCQkCEOUEUg",
                      },
                    ),
                    MarkerLayer(
                      markers: pickedLocation != null
                          ? [
                              Marker(
                                point: pickedLocation!,
                                width: 40,
                                height: 40,
                                child: GestureDetector(
                                  child: SvgPicture.asset(
                                    'images/map_marker.svg',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                            ]
                          : [],
                    ),
                  ],
                ),
                
                // Validation button
                if (showValidationButton)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: GestureDetector(

                      onTap: () async {
                        try {
                          Position position = Position(
                            latitude: pickedLocation!.latitude,
                            longitude: pickedLocation!.longitude,
                            timestamp: DateTime.now(),
                            accuracy: 1.0,
                            altitude: 1.0,
                            heading: 1.0,
                            speed: 1.0,
                            speedAccuracy: 1.0,
                            altitudeAccuracy: 1.0,
                            headingAccuracy: 1.0,
                          );

                          setState(() {
                            _isLoading = true;
                          });
                          
                          String? address = await userViewModel.getAddressFromCoordinates(
                            position.latitude, position.longitude);

                          await userService.updateUserLocation(
                            userViewModel.userId!,
                            address!,
                            position.longitude,
                            position.latitude
                          );

                          setState(() {
                            _isLoading = false;
                          });
                          
                          if (context.mounted) {
                            showCustomToast(context, 'Location updated successfully');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const FoodPreferencePage()),
                            );
                          }

                        } catch (e) {
                          setState(() {
                            _isLoading = false;
                          });
                          if (context.mounted) {
                            showCustomToast(context, 'Failed to update location', isError: true);
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: kMainColor,
                          shape: BoxShape.circle,
                        ),
                        child:
                        _isLoading ? const CircularProgressIndicator(
                          color: Colors.white,

                        ) :
                        const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
}
