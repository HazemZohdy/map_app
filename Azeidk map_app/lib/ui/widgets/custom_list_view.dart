import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:map_app/model/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:map_app/model/place_details_model/place_details_model.dart';

import '../../utils/google_map_places_service.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.googleMapPlacesService,
    required this.places,
    required this.onSelectPlaces,
  });
  final GoogleMapPlacesService googleMapPlacesService;
  final List<PlaceModel> places;
  final Function(PlaceDetailsModel) onSelectPlaces;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(FontAwesomeIcons.faceDizzy),
            title: Text(places[index].description!),
            trailing: IconButton(
              onPressed: () async {
                var placeDetails = await googleMapPlacesService.getPlaceDetails(
                    placeId: places[index].placeId.toString());
                onSelectPlaces(placeDetails);
              },
              icon: Icon(
                FontAwesomeIcons.arrowRight,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
          );
        },
        itemCount: places.length,
      ),
    );
  }
}
