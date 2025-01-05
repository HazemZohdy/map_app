import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  Future<void> checkAndRequestLocationService() async {
    var isServiceEnable = await location.serviceEnabled();
    if (!isServiceEnable) {
      isServiceEnable = await location.requestService();
      if (!isServiceEnable) {
        throw LocationServiceException();
      }
    }
  }

  Future<void> checkAndRequestLocationPermission() async {
    var permissoinStatus = await location.hasPermission();
    if (permissoinStatus == PermissionStatus.deniedForever) {
      throw LocationPremissionException();
    }
    if (permissoinStatus == PermissionStatus.denied) {
      permissoinStatus = await location.requestPermission();
      if (permissoinStatus != PermissionStatus.granted) {
        throw LocationPremissionException();
      }
    }
  }

  void getRealTimeLocationData(void Function(LocationData)? onData) async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    location.onLocationChanged.listen(onData);
  }

  Future<LocationData> getLocation() async {
    await checkAndRequestLocationService();
    await checkAndRequestLocationPermission();
    return await location.getLocation();
  }
}

class LocationServiceException implements Exception {}

class LocationPremissionException implements Exception {}

// create textfeild
// listen to the textfeild
// search places
// display results
