import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:map_app/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:map_app/models/place_details_model/place_details_model.dart';
import 'package:map_app/utils/map_services.dart';

 

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.mapServices,
    required this.places,
    required this.onSelectPlaces,
  });
  final MapServices mapServices;
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
                var placeDetails = await mapServices.getPlaceDetails(placeId: places[index].placeId!);
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
