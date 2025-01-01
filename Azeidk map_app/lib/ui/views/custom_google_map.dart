import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_app/models/place_model.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late Location location;

  @override
  void initState() {
    initialCameraPosition = CameraPosition(
      zoom: 12,
      target: LatLng(
        21.582224110306452,
        39.207531034350446,
      ),
    );
    initMarker();
    initPolyLine();
    initPolygon();
    initCircle();
    location = Location();
    chackAndRequestLocationService();
    super.initState();
  }

  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circle = {};
  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              circles: circle,
              polygons: polygons,
              polylines: polyLines,
              markers: markers,
              onMapCreated: (controller) {
                googleMapController = controller;
                initMapStyle();
              },
              // cameraTargetBounds: CameraTargetBounds(
              //   LatLngBounds(
              //     northeast:  LatLng(21.80390298432393, 39.22974747066939),
              //     southwest: LatLng(21.446113992842637, 39.234989016380155),
              //   ),
              // ),
              initialCameraPosition: initialCameraPosition),
          Positioned(
              bottom: 12,
              left: 22,
              right: 22,
              child: ElevatedButton(
                onPressed: () {
                  googleMapController.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(21.42389822075623, 39.82664447807192),
                    ),
                  );
                },
                child: Text('Change Location'),
              )),
        ],
      ),
    );
  }

  void initMapStyle() async {
    var mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/map_styles.json');
    googleMapController.setMapStyle(mapStyle);
  }

  Future<Uint8List> getImgaeFromData(String image, double width) async {
    var imageData = await rootBundle.load(image);
    var imageCodec = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
        targetWidth: width.round());
    var imageFrame = await imageCodec.getNextFrame();
    var imageByteData =
        await imageFrame.image.toByteData(format: ui.ImageByteFormat.png);
    return imageByteData!.buffer.asUint8List();
  }

  void initMarker() async {
    var iconMarker = BitmapDescriptor.bytes(
        await getImgaeFromData('assets/images/location (1).png', 35));
    var myMarkers = places
        .map(
          (placeMarker) => Marker(
            icon: iconMarker,
            infoWindow: InfoWindow(title: placeMarker.name),
            markerId: MarkerId(
              placeMarker.id.toString(),
            ),
            position: placeMarker.latLng,
          ),
        )
        .toSet();
    markers.addAll(myMarkers);
    setState(() {});
  }

  void initPolyLine() {
    Polyline polyline = Polyline(
      width: 5,
      zIndex: 1,
      polylineId: PolylineId('1'),
      points: [
        LatLng(21.577188301319357, 39.19990517143799),
        LatLng(21.5820234359817, 39.18837458286137),
        LatLng(21.594102927616728, 39.22807934051989),
        LatLng(21.621125685703074, 39.195484959810884),
      ],
      startCap: Cap.roundCap,
      color: Colors.greenAccent,
    );
    Polyline polyline2 = Polyline(
      width: 5,
      zIndex: 1,
      polylineId: PolylineId('2'),
      points: [
        LatLng(21.507230441558388, 39.18204981629627),
        LatLng(21.649984014023907, 39.23050319376302),
      ],
      startCap: Cap.roundCap,
      color: Colors.amber,
    );
    Polyline polyline3 = Polyline(
      width: 5,
      zIndex: 2,
      polylineId: PolylineId('3'),
      points: [
        LatLng(21.566666796901938, 39.36833156092226),
        LatLng(21.642956259378, 39.10500300567779),
      ],
      startCap: Cap.roundCap,
      color: Colors.redAccent,
    );
    polyLines.add(polyline);
    polyLines.add(polyline2);
    polyLines.add(polyline3);
  }

  void initPolygon() {
    Polygon polygon = Polygon(
      polygonId: PolygonId('1'),
      strokeWidth: 5,
      holes: [
        [
          LatLng(21.691975364460685, 39.17544147112033),
          LatLng(21.675821735945064, 39.15672049210501),
          LatLng(21.679549657091833, 39.17469857512766),
          LatLng(21.68907612859373, 39.17202414955404),
        ]
      ],
      points: [
        LatLng(21.71330959268793, 39.114710237056116),
        LatLng(21.637716596718867, 39.149997866111256),
        LatLng(21.63920754576963, 39.210490944491504),
        LatLng(21.735234784006288, 39.189410023237784),
      ],
      fillColor: Colors.black.withValues(alpha: .5),
    );
    polygons.add(polygon);
  }

  void initCircle() {
    Circle elsafaBlaza = Circle(
        center: LatLng(21.577017438655528, 39.20015466380389),
        radius: 1000,
        fillColor: Colors.black.withAlpha(05),
        circleId: CircleId('1'));
    circle.add(elsafaBlaza);
  }

  void chackAndRequestLocationService() async {
    var isServiceEnable = await location.serviceEnabled();
    if (!isServiceEnable) {
      isServiceEnable = await location.requestService();
      if (!isServiceEnable) {
        throw Exception('lol');
      }
    }
    chackAndRequestLocationPermission();
  }

  void chackAndRequestLocationPermission() async {
    var permissoinStatus = await location.hasPermission();
    if (permissoinStatus == PermissionStatus.denied) {
      permissoinStatus = await location.requestPermission();
      if (permissoinStatus != PermissionStatus.granted) {
        //TODO:
      }
    }
  }
}


// world view 0 -> 3 
// country view  4 -> 6 
//city view 9 -> 12
// street view -> 13 -> 17 
// building view -> 18 -> 20




      // this is requests for map app 
// inquire about location serviece 
// request permissions from user 
// get location 
// desplay location 