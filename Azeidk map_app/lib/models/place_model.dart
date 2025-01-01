import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;

  PlaceModel({
    required this.id,
    required this.name,
    required this.latLng,
  });
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: 'حسن يمانى ',
    latLng: LatLng(
      21.527135798219078,
      39.15716541432177,
    ),
  ),
  PlaceModel(
    id: 2,
    name: ' مكتب المحامى إبراهيم حكمى ',
    latLng: LatLng(21.503395555748803, 39.183143048192065),
  ),
  PlaceModel(
    id: 2,
    name: 'المطار',
    latLng: LatLng(
      21.683515126539316,
      39.16624320210299,
    ),
  ),
];
