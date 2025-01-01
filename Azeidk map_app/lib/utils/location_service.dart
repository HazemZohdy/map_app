import 'package:location/location.dart';

class LocationService {
  Location location = Location();
  Future<bool> checkAndRequestLocationService() async {
    var isServiceEnable = await location.serviceEnabled();
    if (!isServiceEnable) {
      isServiceEnable = await location.requestService();
      if (!isServiceEnable) {
        return false;
      }
    }
    return true;
  }

  Future<bool> checkAndRequestLocationPermission() async {
    var permissoinStatus = await location.hasPermission();
    if (permissoinStatus == PermissionStatus.deniedForever) {
      return false;
    }
    if (permissoinStatus == PermissionStatus.denied) {
      permissoinStatus = await location.requestPermission();
      return permissoinStatus == PermissionStatus.granted;
    }

    return true;
  }

  void getRealTimeLocationData(void Function(LocationData)? onData) {
    location.onLocationChanged.listen(onData);
  }
}
