import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;

  @override
  void initState() {
    initialCameraPosition = CameraPosition(
      zoom: 11,
      target: LatLng(
        21.582224110306452,
        39.207531034350446,
      ),
    );
    super.initState();
  }

  late GoogleMapController googleMapController;

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              
              onMapCreated: (controller) {
                googleMapController = controller;
              },
              // cameraTargetBounds: CameraTargetBounds(
              //   LatLngBounds(
              //     northeast:  LatLng(21.80390298432393, 39.22974747066939),
              //     southwest: LatLng(21.446113992842637, 39.234989016380155),
              //   ),
              // ),
              initialCameraPosition: initialCameraPosition),
          Positioned(
              bottom: 12,
              left: 22,
              right: 22,
              child: ElevatedButton(
                onPressed: () {
                  googleMapController.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(21.42389822075623, 39.82664447807192),
                    ),
                  );
                },
                child: Text('Change Location'),
              )),
        ],
      ),
    );
  }
}


// world view 0 -> 3 
// country view  4 -> 6 
//city view 9 -> 12
// street view -> 13 -> 17 
// building view -> 18 -> 20