import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:map_app/model/place_autocomplete_model/place_autocomplete_model.dart';

class GoogleMapPlacesService {
  final String baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String apiKey = 'AIzaSyCE2jpewMGO4HPAPNZAD6KKXQeSbuOZKxE';
  Future<List<PlaceAutocompleteModel>> getProdiction({
    required String input,
  }) async {
    var response = await http.get(Uri.parse(
      '$baseUrl/autocomplete/json?key=$apiKey&input=$input',
    ));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['predictions'];
      List<PlaceAutocompleteModel> places = [];
      for (var item in data) {
        places.add(PlaceAutocompleteModel.fromJson(item));
      }
      return places; 
    } else {
      throw Exception();
    }
  }
}
