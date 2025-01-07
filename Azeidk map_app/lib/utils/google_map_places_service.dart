import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:map_app/model/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:map_app/model/place_details_model/place_details_model.dart';

class GoogleMapPlacesService {
  final String baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String apiKey = 'AIzaSyCE2jpewMGO4HPAPNZAD6KKXQeSbuOZKxE';
  Future<List<PlaceModel>> getProdiction({
    required String input,
    required String sestionTeken,
  }) async {
    var response = await http.get(Uri.parse(
      '$baseUrl/autocomplete/json?key=$apiKey&input=$input&sessiontoken=$sestionTeken',
    ));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['predictions'];
      List<PlaceModel> places = [];
      for (var item in data) {
        places.add(PlaceModel.fromJson(item));
      }
      return places;
    } else {
      throw Exception();
    }
  }

  Future<PlaceDetailsModel> getPlaceDetails({
    required String placeId,
  }) async {
    var response = await http.get(Uri.parse(
      '$baseUrl/details/json?key=$apiKey&place_id=$placeId',
    ));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['result'];

      return PlaceDetailsModel.fromJson(data);
    } else {
      throw Exception();
    }
  }
}
