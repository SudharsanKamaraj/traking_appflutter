import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class MapController extends GetxController {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  // final RxBool shouldRefresh = false.obs;
  // final String key = 'AIzaSyDxB2sKz-esRgcRO-KbxapmuqwaT0UoZ58';
  // double startLat = 0;
  // double startLng = 0;
  // double endLat = 0;
  // double endLng = 0;
  // Map<String, dynamic>? directionData;
  // double distance = 0.0;
  // Set<Marker> markers = <Marker>{};
  // Set<Polygon> polygons = <Polygon>{};
  // Set<Polyline> polylines = <Polyline>{};
  // List<LatLng> polygonLatLngs = <LatLng>[];
  //
  // int polygonIdCounter = 1;
  // int polylineIdCounter = 1;
  //
  // LatLng startPoint = LatLng(0, 0); // Starting point coordinates
  // LatLng endPoint = LatLng(0, 0); // Ending point coordinates
  //
  // List<Marker> getMarkers() {
  //   return [
  //     Marker(
  //       markerId: MarkerId("starting point"),
  //       position: startPoint,
  //     ),
  //     Marker(
  //       markerId: MarkerId("end point"),
  //       position: endPoint,
  //       icon: BitmapDescriptor.defaultMarker,
  //     ),
  //   ];
  // }
  //
  // void setPolyline(List<PointLatLng> points) {
  //   final String polylineIdVal = 'polyline_$polylineIdCounter';
  //   polylineIdCounter++;
  //
  //   List<LatLng> latLngPoints = points
  //       .map(
  //         (point) => LatLng(point.latitude, point.longitude),
  //       )
  //       .toList();
  //
  //   polylines.add(
  //     Polyline(
  //       polylineId: PolylineId(polylineIdVal),
  //       width: 5,
  //       color: Colors.blue,
  //       points: latLngPoints,
  //     ),
  //   );
  //
  //   // Store the first and last points as local variables
  //   if (latLngPoints.isNotEmpty) {
  //     startPoint = latLngPoints.first;
  //     endPoint = latLngPoints.last;
  //     // Now you can use `startPoint` and `endPoint` as needed
  //   }
  //
  //   update(); // Notify GetX that the state has changed
  // }
  //
  // Future<void> goToThePlace(
  //   double lat,
  //   double lng,
  //   Map<String, dynamic> boundsNe,
  //   Map<String, dynamic> boundsSw,
  //   // Map<String, dynamic> place
  // ) async {
  //   // final double lat = place['geometry']['location']['lat'];
  //   // final double lng = place['geometry']['location']['lng'];
  //
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: LatLng(lat, lng), zoom: 12),
  //     ),
  //   );
  //
  //   await getDirection(
  //       startPoint.latitude.toString() + ',' + startPoint.longitude.toString(),
  //       endPoint.latitude.toString() + ',' + endPoint.longitude.toString());
  //
  //   // String distance = getDistance() ?? 'N/A';
  //   // String time = getTime() ?? 'N/A';
  //   //
  //   // print('Distance: $distance');
  //   // print('Time: $time');
  //
  //   controller.animateCamera(
  //     CameraUpdate.newLatLngBounds(
  //       LatLngBounds(
  //         southwest: LatLng(boundsSw[lat], boundsSw[lng]),
  //         northeast: LatLng(boundsNe[lat], boundsNe[lng]),
  //       ),
  //       25,
  //     ),
  //   );
  //
  //   // setMarker(LatLng(lat, lng));
  // }
  //
  // void setController(GoogleMapController controller) {
  //   _controller.complete(controller);
  // }
  //
  // Future<String> getPlaceId(String input) async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
  //
  //   var response = await http.get(Uri.parse(url));
  //   var json = convert.jsonDecode(response.body);
  //   var placeId = json['candidates'][0]['place_id'] as String;
  //
  //   print("===> place Id: $placeId");
  //
  //   return placeId;
  // }
  //
  // Future<Map<String, dynamic>> getDirection(
  //     String origin, String destination) async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';
  //   List<LatLng> polylineCoordinates = [];
  //
  //   // print("===> getDirection origin: $origin");
  //   // print("===> getDirection destination: $destination");
  //   var response = await http.get(Uri.parse(url));
  //   var json = convert.jsonDecode(response.body);
  //   var result = {
  //     'bounds_ne': json['routes'][0]['bounds']['northeast'],
  //     'bounds_sw': json['routes'][0]['bounds']['southwest'],
  //     'start_location': json['routes'][0]['legs'][0]['start_location'],
  //     'end_location': json['routes'][0]['legs'][0]['end_location'],
  //     'polyline': json['routes'][0]['overview_polyline']['points'],
  //     'polyline_decoded': PolylinePoints()
  //         .decodePolyline(json['routes'][0]['overview_polyline']['points']),
  //   };
  //
  //   if (result != null) {
  //     Map<String, dynamic> startLocation = result['start_location'];
  //     startLat = startLocation['lat'];
  //     startLng = startLocation['lng'];
  //
  //     // Now you can use 'startLatitude' and 'startLongitude' as needed
  //     print('Start Latitude: $startLat');
  //     print('Start Longitude: $startLng');
  //
  //     Map<String, dynamic> endLocation = result['end_location'];
  //     endLat = endLocation['lat'];
  //     endLng = endLocation['lat'];
  //
  //     // Now you can use 'startLatitude' and 'startLongitude' as needed
  //     print('Start Latitude: $endLat');
  //     print('Start Longitude: $endLng');
  //
  //     polylineCoordinates.add(startPoint);
  //     polylineCoordinates.add(endPoint);
  //   }
  //
  //   print("polylineCoordinates: $polylineCoordinates");
  //
  //   double totalDistance = 0;
  //   for (var i = 0; i < polylineCoordinates.length - 1; i++) {
  //     totalDistance += calculateDistance(
  //         polylineCoordinates[i].latitude,
  //         polylineCoordinates[i].longitude,
  //         polylineCoordinates[i + 1].latitude,
  //         polylineCoordinates[i + 1].longitude);
  //   }
  //   print("totalDistance: $totalDistance");
  //
  //   distance = totalDistance;
  //
  //   print("===> getDirection result: $result");
  //   return result;
  // }
  //
  // double calculateDistance(lat1, lon1, lat2, lon2) {
  //   var p = 0.017453292519943295;
  //   var a = 0.5 -
  //       cos((lat2 - lat1) * p) / 2 +
  //       cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  //   return 12742 * asin(sqrt(a));
  // }

  final Location location = Location();
  LatLng _initialPosition = LatLng(0, 0); // Initial map location

  RxList<LatLng> latLngList = <LatLng>[].obs;
  RxSet<Marker> markers = <Marker>{}.obs;

  GoogleMapController? _mapController; // Use nullable type here

  RxBool isLocationPermissionDenied = false.obs; // Add this line

  @override
  void onInit() {
    super.onInit();
    // _requestLocationPermission();
  }

  // void saveNewLatLng(LatLng latLng) {
  //   latLngList.add(latLng);
  //   dataStorage.saveLatLngList(latLngList);
  //   markers.add(
  //     Marker(
  //       markerId: MarkerId("userLocation_${latLngList.length}"),
  //       position: latLng,
  //     ),
  //   );
  //   if (_mapController != null) {
  //     _mapController!.animateCamera(CameraUpdate.newCameraPosition(
  //       CameraPosition(target: latLng, zoom: 16.0),
  //     ));
  //   }
  // }
  //
  // void _requestLocationPermission() async {
  //   var status = await location.requestPermission();
  //   isLocationPermissionDenied.value =
  //       status == PermissionStatus.denied; // Update the value here
  //
  //   if (!isLocationPermissionDenied.value) {
  //     // Add listener only if permission is granted
  //     location.onLocationChanged.listen((LocationData? currentLocation) {
  //       if (currentLocation != null) {
  //         _initialPosition =
  //             LatLng(currentLocation.latitude!, currentLocation.longitude!);
  //         latLngList.add(_initialPosition);
  //         dataStorage.saveLatLngList(latLngList);
  //         print("===> latLngList: $latLngList");
  //         markers.add(
  //           Marker(
  //             markerId: MarkerId("userLocation_${latLngList.length}"),
  //             position: _initialPosition,
  //           ),
  //         );
  //         if (_mapController != null) {
  //           _mapController!.animateCamera(CameraUpdate.newCameraPosition(
  //             CameraPosition(target: _initialPosition, zoom: 16.0),
  //           ));
  //         }
  //       } else {
  //         print("===> it is not working");
  //       }
  //     });
  //   }
  // }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void requestLocationPermission() async {
    var status = await location.requestPermission();
    isLocationPermissionDenied.value = status == PermissionStatus.denied;
  }

  void disableLocationPermission() {
    isLocationPermissionDenied.value = true;
    // Additional logic if needed when disabling the permission
  }
}

class dataStorage {
  static Future<void> saveLatLngList(List<LatLng> latLngList) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'lat_lng_list_key';
    final jsonList = latLngList
        .map((latLng) =>
            {'latitude': latLng.latitude, 'longitude': latLng.longitude})
        .toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(key, jsonString);
  }

  static Future<List<LatLng>> getLatLngList() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'lat_lng_list_key';
    final jsonString = prefs.getString(key);

    if (jsonString != null && jsonString.isNotEmpty) {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final latLngList = jsonList
          .map((json) => LatLng(json['latitude'], json['longitude']))
          .toList();

      return latLngList;
    } else {
      return [];
    }
  }

  static Future<int> _getNextId() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'next_latlng_id';

    int nextId = prefs.getInt(key) ?? 1;
    await prefs.setInt(key, nextId + 1);

    return nextId;
  }

  static final ValueNotifier<List<List<LatLng>>> _latLngListsNotifier =
      ValueNotifier<List<List<LatLng>>>([]);

  static Future<void> storeLatLngList(List<LatLng> latLngList) async {
    int id = await _getNextId();
    final prefs = await SharedPreferences.getInstance();
    final key = 'latlng_list_$id';
    print("===> latLngList : $latLngList");

    final jsonList = latLngList
        .map((latLng) => {
              'latitude': latLng.latitude,
              'longitude': latLng.longitude,
            })
        .toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(key, jsonString);
    _latLngListsNotifier.value = await getAllLatLngLists();
  }

  static Future<List<List<LatLng>>> getAllLatLngLists() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    List<List<LatLng>> allLatLngLists = [];

    for (String key in keys) {
      if (key.startsWith('latlng_list_')) {
        String jsonString = prefs.getString(key) ?? '';
        List<Map<String, dynamic>> mapsList =
            List<Map<String, dynamic>>.from(jsonDecode(jsonString));
        List<LatLng> latLngList = mapsList
            .map((map) => LatLng(map['latitude'], map['longitude']))
            .toList();
        allLatLngLists.add(latLngList);
      }
    }

    return allLatLngLists;
  }

  static ValueNotifier<List<List<LatLng>>> get latLngListsNotifier =>
      _latLngListsNotifier;
}

// class LatLng {
//   final double latitude;
//   final double longitude;
//
//   LatLng(this.latitude, this.longitude);
//
//   // Convert LatLng to a Map for JSON encoding
//   Map<String, dynamic> toJson() =>
//       {'latitude': latitude, 'longitude': longitude};
//
//   // Convert Map to LatLng
//   factory LatLng.fromJson(Map<String, dynamic> json) =>
//       LatLng(json['latitude'], json['longitude']);
// }
