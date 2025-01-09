import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/models/place_autocomplete_model/place_autocomplete_model.dart';
import 'package:map_app/utils/location_service.dart';
import 'package:map_app/utils/map_services.dart';
import 'package:uuid/uuid.dart';
import '../widgets/cusotm_text_feild.dart';
import '../widgets/custom_list_view.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

late TextEditingController textEditingController;
late CameraPosition initialCameraPostion;
late MapServices mapServices;
late GoogleMapController googleMapController;

Set<Marker> markers = {};
List<PlaceModel> places = [];
Set<Polyline> polyLine = {};
late Uuid uuid;
String? sesstionToken;
late LatLng currentPostion;
late LatLng destinations;

class _GoogleMapViewState extends State<GoogleMapView> {
  @override
  void initState() {
    uuid = Uuid();
    mapServices = MapServices();
    textEditingController = TextEditingController();
    initialCameraPostion = CameraPosition(
        target: LatLng(
      21.557368883761093,
      39.19959691722625,
    ));

    updateCurrentLoction();

    super.initState();
    fetchPrediction();
  }

  void fetchPrediction() {
    textEditingController.addListener(() async {
      sesstionToken ??= uuid.v4();
      await mapServices.getProdiction(
          input: textEditingController.text,
          sestionTeken: sesstionToken!,
          places: places);
      setState(() {});
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              polylines: polyLine,
              markers: markers,
              onMapCreated: (controller) {
                googleMapController = controller;
                updateCurrentLoction();
              },
              initialCameraPosition: initialCameraPostion,
            ),
            Positioned(
              top: 16,
              right: 12,
              left: 12,
              child: Column(
                spacing: 12,
                children: [
                  CustomTextFeild(
                    textEditingController: textEditingController,
                  ),
                  CustomListView(
                    onSelectPlaces: (placeDetailsModle) async {
                      textEditingController.clear();
                      places.clear();
                      sesstionToken = null;
                      setState(() {});
                      destinations = LatLng(
                          placeDetailsModle.geometry!.location!.lat!,
                          placeDetailsModle.geometry!.location!.lng!);
                      var points = await mapServices.getRouteData(
                        currentPostion: currentPostion,
                        destinations: destinations,
                      );
                      mapServices.displayRoute(points,
                          polyLine: polyLine,
                          googleMapController: googleMapController);
                      setState(() {});
                    },
                    places: places,
                    mapServices: mapServices,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateCurrentLoction() async {
    try {
      currentPostion = await mapServices.updateCurrentLoction(
        googleMapController: googleMapController,
        markers: markers,
      );
      setState(() {});
    } on LocationServiceException catch (e) {
      //
    } on LocationPremissionException catch (e) {
      //
    } catch (e) {
      //
    }
  }

  // Future<List<LatLng>> getRouteData() async {
  //   LocationInfoModel origin = LocationInfoModel(
  //     location: LocationModel(
  //       latLng: LatLngModel(
  //         latitude: currentPostion.latitude,
  //         longitude: currentPostion.longitude,
  //       ),
  //     ),
  //   );
  //   LocationInfoModel destination = LocationInfoModel(
  //     location: LocationModel(
  //       latLng: LatLngModel(
  //         latitude: destinations.latitude,
  //         longitude: destinations.longitude,
  //       ),
  //     ),
  //   );
  //   RoutesModel route = await routeService.fetchRoute(
  //       origin: origin, destinations: destination);
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   List<LatLng> points = getDecodedRoute(polylinePoints, route);
  //   return points;
  // }

  // List<LatLng> getDecodedRoute(
  //     PolylinePoints polylinePoints, RoutesModel route) {
  //   List<PointLatLng> result = polylinePoints.decodePolyline(
  //     route.routes!.first.polyline!.encodedPolyline!,
  //   );
  //   List<LatLng> points =
  //       result.map((e) => LatLng(e.latitude, e.longitude)).toList();
  //   return points;
  // }

  // void displayRoute(List<LatLng> points) {
  //   Polyline rout = Polyline(
  //     color: Colors.blue,
  //     width: 8,
  //     polylineId: PolylineId('rout'),
  //     points: points,
  //   );
  //   polyLine.add(rout);
  //   LatLngBounds bounds = getLatLngBounds(points);
  //   googleMapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  //   setState(() {});
  // }

  // LatLngBounds getLatLngBounds(List<LatLng> points) {
  //   var southWestLatitude = points.first.latitude;
  //   var southWestLongtitde = points.first.longitude;
  //   var northEastLatitude = points.first.latitude;
  //   var northEastLongtitude = points.first.longitude;

  //   for (var point in points) {
  //     southWestLatitude = min(southWestLatitude, point.latitude);
  //     southWestLongtitde = min(southWestLongtitde, point.longitude);
  //     northEastLatitude = max(northEastLatitude, point.latitude);
  //     northEastLongtitude = max(northEastLongtitude, point.longitude);
  //   }
  //   return LatLngBounds(
  //     southwest: LatLng(southWestLatitude, southWestLongtitde),
  //     northeast: LatLng(northEastLatitude, northEastLongtitude),
  //   );
  // }
}

// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:map_app/models/place_model.dart';
// import '../../utils/location_service.dart';

// class CustomGoogleMap extends StatefulWidget {
//   const CustomGoogleMap({super.key});

//   @override
//   State<CustomGoogleMap> createState() => _CustomGoogleMapState();
// }

// class _CustomGoogleMapState extends State<CustomGoogleMap> {
//   late CameraPosition initialCameraPosition;
//   late Location location;
//   late LocationService locationService;
//   @override
//   void initState() {
//     initialCameraPosition = CameraPosition(
//       zoom: 1,
//       target: LatLng(
//         21.582224110306452,
//         39.207531034350446,
//       ),
//     );

//     locationService = LocationService();
//     updateMyLocation();
//     super.initState();
//   }

//   bool isFirstCall = true;
//   GoogleMapController? googleMapController;
//   Set<Marker> markers = {};
//   Set<Polyline> polyLines = {};
//   Set<Polygon> polygons = {};
//   Set<Circle> circle = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//               circles: circle,
//               polygons: polygons,
//               polylines: polyLines,
//               markers: markers,
//               onMapCreated: (controller) {
//                 googleMapController = controller;
//                 initMapStyle();
//               },
//               // cameraTargetBounds: CameraTargetBounds(
//               //   LatLngBounds(
//               //     northeast:  LatLng(21.80390298432393, 39.22974747066939),
//               //     southwest: LatLng(21.446113992842637, 39.234989016380155),
//               //   ),
//               // ),
//               initialCameraPosition: initialCameraPosition),
//           // Positioned(
//           //     bottom: 12,
//           //     left: 22,
//           //     right: 22,
//           //     child: ElevatedButton(
//           //       onPressed: () {
//           //         googleMapController!.animateCamera(
//           //           CameraUpdate.newLatLng(
//           //             LatLng(21.42389822075623, 39.82664447807192),
//           //           ),
//           //         );
//           //       },
//           //       child: Text('Change Location'),
//           //     )),
//         ],
//       ),
//     );
//   }

//   void initMapStyle() async {
//     var mapStyle = await DefaultAssetBundle.of(context)
//         .loadString('assets/map_styles/map_styles.json');
//     googleMapController!.setMapStyle(mapStyle);
//   }

//   Future<Uint8List> getImgaeFromData(String image, double width) async {
//     var imageData = await rootBundle.load(image);
//     var imageCodec = await ui.instantiateImageCodec(
//         imageData.buffer.asUint8List(),
//         targetWidth: width.round());
//     var imageFrame = await imageCodec.getNextFrame();
//     var imageByteData =
//         await imageFrame.image.toByteData(format: ui.ImageByteFormat.png);
//     return imageByteData!.buffer.asUint8List();
//   }

//   void initMarker() async {
//     var iconMarker = BitmapDescriptor.bytes(
//         await getImgaeFromData('assets/images/location (1).png', 35));
//     var myMarkers = places
//         .map(
//           (placeMarker) => Marker(
//             icon: iconMarker,
//             infoWindow: InfoWindow(title: placeMarker.name),
//             markerId: MarkerId(
//               placeMarker.id.toString(),
//             ),
//             position: placeMarker.latLng,
//           ),
//         )
//         .toSet();
//     markers.addAll(myMarkers);
//     setState(() {});
//   }

//   void initPolyLine() {
//     Polyline polyline = Polyline(
//       width: 5,
//       zIndex: 1,
//       polylineId: PolylineId('1'),
//       points: [
//         LatLng(21.577188301319357, 39.19990517143799),
//         LatLng(21.5820234359817, 39.18837458286137),
//         LatLng(21.594102927616728, 39.22807934051989),
//         LatLng(21.621125685703074, 39.195484959810884),
//       ],
//       startCap: Cap.roundCap,
//       color: Colors.greenAccent,
//     );
//     Polyline polyline2 = Polyline(
//       width: 5,
//       zIndex: 1,
//       polylineId: PolylineId('2'),
//       points: [
//         LatLng(21.507230441558388, 39.18204981629627),
//         LatLng(21.649984014023907, 39.23050319376302),
//       ],
//       startCap: Cap.roundCap,
//       color: Colors.amber,
//     );
//     Polyline polyline3 = Polyline(
//       width: 5,
//       zIndex: 2,
//       polylineId: PolylineId('3'),
//       points: [
//         LatLng(21.566666796901938, 39.36833156092226),
//         LatLng(21.642956259378, 39.10500300567779),
//       ],
//       startCap: Cap.roundCap,
//       color: Colors.redAccent,
//     );
//     polyLines.add(polyline);
//     polyLines.add(polyline2);
//     polyLines.add(polyline3);
//   }

//   void initPolygon() {
//     Polygon polygon = Polygon(
//       polygonId: PolygonId('1'),
//       strokeWidth: 5,
//       holes: [
//         [
//           LatLng(21.691975364460685, 39.17544147112033),
//           LatLng(21.675821735945064, 39.15672049210501),
//           LatLng(21.679549657091833, 39.17469857512766),
//           LatLng(21.68907612859373, 39.17202414955404),
//         ]
//       ],
//       points: [
//         LatLng(21.71330959268793, 39.114710237056116),
//         LatLng(21.637716596718867, 39.149997866111256),
//         LatLng(21.63920754576963, 39.210490944491504),
//         LatLng(21.735234784006288, 39.189410023237784),
//       ],
//       fillColor: Colors.black.withValues(alpha: .5),
//     );
//     polygons.add(polygon);
//   }

//   void initCircle() {
//     Circle elsafaBlaza = Circle(
//         center: LatLng(21.577017438655528, 39.20015466380389),
//         radius: 1000,
//         fillColor: Colors.black.withAlpha(05),
//         circleId: CircleId('1'));
//     circle.add(elsafaBlaza);
//   }

//   void updateMyLocation() async {
//     await locationService.checkAndRequestLocationService();
//     bool hasPermision =
//         await locationService.checkAndRequestLocationPermission();
//     if (hasPermision) {
//       locationService.getRealTimeLocationData((locationData) {
//         setMyLocationMarker(locationData);
//         setMyCameraPosition(locationData);
//       });
//     } else {}
//   }

//   void setMyCameraPosition(LocationData locationData) {
//     if (isFirstCall) {
//       CameraPosition cameraPosition = CameraPosition(
//         target: LatLng(locationData.latitude!, locationData.longitude!),
//         zoom: 17,
//       );
//       googleMapController?.animateCamera(
//         CameraUpdate.newCameraPosition(cameraPosition),
//       );
//       isFirstCall = false;
//     } else {
//       googleMapController?.animateCamera(CameraUpdate.newLatLng(
//         LatLng(locationData.latitude!, locationData.longitude!),
//       ));
//     }
//   }

//   void setMyLocationMarker(LocationData locationData) {
//     var myLocationMarker = Marker(
//         markerId: MarkerId('My_Location_marker'),
//         position: LatLng(locationData.latitude!, locationData.longitude!));
//     markers.add(myLocationMarker);
//     setState(() {});
//   }
// }

//       // this is requests for map app
// // inquire about location serviece
// // request permissions from user
// // get location
// // desplay location

// // world view 0 -> 3
// // country view  4 -> 6
// //city view 9 -> 12
// // street view -> 13 -> 17
// // building view -> 18 -> 20
