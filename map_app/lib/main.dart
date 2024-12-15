import 'package:flutter/material.dart';
import 'package:map_app/ui/views/home_view.dart';

void main() {
  runApp(MapApp());
}

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
