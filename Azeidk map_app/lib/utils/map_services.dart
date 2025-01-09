import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/models/location_info/lat_lng.dart';
import 'package:map_app/models/location_info/location.dart';
import 'package:map_app/models/location_info/location_info.dart';
import 'package:map_app/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:map_app/models/place_details_model/place_details_model.dart';
import 'package:map_app/models/place_details_model/route_model/route_model.dart';
import 'package:map_app/utils/google_map_places_service.dart';
import 'package:map_app/utils/location_service.dart';
import 'package:map_app/utils/rout_service.dart';

class MapServices {
  PlacesService googleMapPlacesService = PlacesService();
  LocationService locationService = LocationService();
  RouteService routeService = RouteService();
  LatLng? currentPostion;
  Future<void> getProdiction({
    required String input,
    required String sestionTeken,
    required List<PlaceModel> places,
  }) async {
    if (input.isNotEmpty) {
      var result = await googleMapPlacesService.getProdiction(
        input: input,
        sestionTeken: sestionTeken,
      );
      places.clear();
      places.addAll(result);
    } else {
      places.clear();
    }
  }

  Future<List<LatLng>> getRouteData({
    required LatLng destinations,
  }) async {
    LocationInfoModel origin = LocationInfoModel(
      location: LocationModel(
        latLng: LatLngModel(
          latitude: currentPostion!.latitude,
          longitude: currentPostion!.longitude,
        ),
      ),
    );
    LocationInfoModel destination = LocationInfoModel(
      location: LocationModel(
        latLng: LatLngModel(
          latitude: destinations.latitude,
          longitude: destinations.longitude,
        ),
      ),
    );
    RoutesModel route = await routeService.fetchRoute(
        origin: origin, destinations: destination);
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> points = getDecodedRoute(polylinePoints, route);
    return points;
  }

  List<LatLng> getDecodedRoute(
      PolylinePoints polylinePoints, RoutesModel route) {
    List<PointLatLng> result = polylinePoints.decodePolyline(
      route.routes!.first.polyline!.encodedPolyline!,
    );
    List<LatLng> points =
        result.map((e) => LatLng(e.latitude, e.longitude)).toList();
    return points;
  }

  void displayRoute(
    List<LatLng> points, {
    required Set<Polyline> polyLine,
    required GoogleMapController googleMapController,
  }) {
    Polyline rout = Polyline(
      color: Colors.blue,
      width: 6,
      polylineId: PolylineId('route'),
      points: points,
    );
    polyLine.add(rout);
    LatLngBounds bounds = getLatLngBounds(points);
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  LatLngBounds getLatLngBounds(List<LatLng> points) {
    var southWestLatitude = points.first.latitude;
    var southWestLongtitde = points.first.longitude;
    var northEastLatitude = points.first.latitude;
    var northEastLongtitude = points.first.longitude;

    for (var point in points) {
      southWestLatitude = min(southWestLatitude, point.latitude);
      southWestLongtitde = min(southWestLongtitde, point.longitude);
      northEastLatitude = max(northEastLatitude, point.latitude);
      northEastLongtitude = max(northEastLongtitude, point.longitude);
    }
    return LatLngBounds(
      southwest: LatLng(southWestLatitude, southWestLongtitde),
      northeast: LatLng(northEastLatitude, northEastLongtitude),
    );
  }

  void updateCurrentLoction({
    required GoogleMapController googleMapController,
    required Set<Marker> markers,
    required Function onUpdateCurrentLocation,
  }) {
    locationService.getRealTimeLocationData(
      (locationData) {
        currentPostion =
            LatLng(locationData.latitude!, locationData.longitude!);
        Marker currentLocation = Marker(
          markerId: MarkerId('myMarker'),
          position: currentPostion!,
        );

        CameraPosition myCurrentCameraPostion = CameraPosition(
          target: currentPostion!,
          zoom: 17,
        );
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(myCurrentCameraPostion),
        );
        markers.add(currentLocation);
        onUpdateCurrentLocation();
      },
    );
  }

  Future<PlaceDetailsModel> getPlaceDetails({
    required String placeId,
  }) async {
    return await googleMapPlacesService.getPlaceDetails(placeId: placeId);
  }
}
