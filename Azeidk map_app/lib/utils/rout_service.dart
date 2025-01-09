import 'dart:convert';
import 'package:map_app/models/place_details_model/route_model/route_model.dart';
import 'package:http/http.dart' as http;
import 'package:map_app/models/route_modifiers.dart';
import '../models/location_info/location_info.dart';

class RouteService {
  final String baseUrl =
      'https://routes.googleapis.com/directions/v2:computeRoutes';
  final String apiKey = 'AIzaSyCE2jpewMGO4HPAPNZAD6KKXQeSbuOZKxE';
  Future<RoutesModel> fetchRoute({
    required LocationInfoModel origin,
    required LocationInfoModel destinations,
    RouteModifiers? routeModifiers,
  }) async {
    Uri url = Uri.parse(baseUrl);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
    };
    Map<String, dynamic> body = {
      "origin": origin.toJson(),
      "destination": destinations.toJson(),
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE",
      "computeAlternativeRoutes": false,
      "routeModifiers": routeModifiers != null
          ? routeModifiers.toJson()
          : RouteModifiers().toJson(),
      "languageCode": "en-US",
      "units": "IMPERIAL"
    };

    var response = await http.post(
      url,
      body: jsonEncode(body),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return RoutesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('not routs found ');
    }
  }
}
