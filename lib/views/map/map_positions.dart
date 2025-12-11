import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hiatunisie/map_box_constants.dart';
import 'package:hiatunisie/viewmodels/establishement_viewmodel.dart';
import 'package:hiatunisie/views/home/exports/export_homescreen.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {

  final pageController = PageController();
  int selectedIndex = 0;
  


  late final MapController mapController;
    late UserViewModel userViewModel;


  @override
  void initState() {
    super.initState();
    mapController = MapController();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
          final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
      var currentLocation = AppConstants.myLocation ; 
    return Scaffold(
      
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              initialZoom: 11.5,
              initialCenter: currentLocation,
            ),
            children: [
             TileLayer(
                    urlTemplate: "https://api.mapbox.com/styles/v1/boogeyy/clyg8q8e500uv01qv8bb8bftb/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYm9vZ2V5eSIsImEiOiJjbHlnNmpoYmEwN3k1MmlwbzB0NHZvdXg4In0.puEqRDXeCxmqCQkCEOUEUg",
                    additionalOptions: const {
                      'accessToken': "pk.eyJ1IjoiYm9vZ2V5eSIsImEiOiJjbHlnNmpoYmEwN3k1MmlwbzB0NHZvdXg4In0.puEqRDXeCxmqCQkCEOUEUg",
                      'id': 'mapbox.mapbox-streets-v8',
                    },
                  ),

              MarkerLayer(
                markers: [
                  for (int i = 0; i < establishmentViewModel.markers.length; i++)
                    Marker(
  point: establishmentViewModel.markers[i].location ?? currentLocation,
  width: 40,
  height: 40,
  child: GestureDetector(
    onTap: () {
      pageController.animateToPage(
        i,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      selectedIndex = i;
      currentLocation = establishmentViewModel.markers[i].location ?? currentLocation;
      _animatedMapMove(currentLocation, 12.5);
      setState(() {});
    },
    child: AnimatedScale(
      duration: const Duration(milliseconds: 500),
      scale: selectedIndex == i ? 1 : 0.7,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: selectedIndex == i ? 1 : 0.5,
        child: SvgPicture.asset(
          'images/map_marker.svg',
        ),
      ),
    ),
  ),
)

                ],
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 2,
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (value) {
                selectedIndex = value;
                currentLocation =
                    establishmentViewModel.markers[value].location ?? currentLocation;
                _animatedMapMove(currentLocation, 12.5);
                setState(() {});
              },
              itemCount: establishmentViewModel.markers.length,
              itemBuilder: (_, index) {
                final item = establishmentViewModel.markers[index];
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: const Color.fromARGB(255, 30, 29, 29),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: item.rating,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title ?? '',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      item.address ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: item.image == null || item.image!.isEmpty
                                  ? Image.asset(
                                      'images/placeholder.png',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      item.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Image.asset(
                                        'images/placeholder.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: AppConstants.myLocation.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: AppConstants.myLocation.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: 11.5, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }


}

