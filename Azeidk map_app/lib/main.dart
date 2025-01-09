import 'package:flutter/material.dart';
import 'package:map_app/ui/views/google_map_view.dart';

void main() {
  runApp(const RoutTrackerMap());
}

class RoutTrackerMap extends StatelessWidget {
  const RoutTrackerMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoogleMapView(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:map_app/ui/views/custom_google_map.dart';

// void main() {
//   runApp(MapApp());
// }

// class MapApp extends StatelessWidget {
//   const MapApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: CustomGoogleMap(),
//     );
//   }
// }
