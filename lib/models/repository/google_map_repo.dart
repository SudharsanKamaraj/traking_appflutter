import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tracking_app/controller/map_conteoller.dart';
import 'package:tracking_app/util/image_const.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late MapController mapController;
  late Timer _refreshTimer;

  @override
  void initState() {
    super.initState();
    mapController = Get.put(MapController());
    _startRefreshTimer();
  }

  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(Duration(seconds: 5), (_) {
      mapController.refreshScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset(AppImages.APP_NAME),
        leading: Icon(
          Icons.menu,
          color: Colors.black45,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            // Existing GoogleMap properties
            initialCameraPosition: _kGooglePlex,
            markers: mapController.markers,
            polygons: mapController.polygons,
            polylines: mapController.polylines,
            onMapCreated: (GoogleMapController controller) {
              // Existing onMapCreated code
              mapController.setController(controller); // Update the controller
            },
            onTap: (point) {
              setState(() {
                mapController.polygonLatLngs
                    .add(point); // Access polygonLatLngs from MapController
                mapController
                    .setPolygon(); // Use setPolygon method from MapController
              });
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.01,
              left: size.width * 0.02,
              right: size.width * 0.2,
            ),
            child: TextFormField(
              controller: _originController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Origin",
                hintStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black26,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color(0xFFF5F5F5),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value) {
                print("===> search value: $value");
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.1,
              left: size.width * 0.02,
              right: size.width * 0.2,
            ),
            child: TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Destination",
                hintStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black26,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color(0xFFF5F5F5),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value) {
                print("===> search value: $value");
              },
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(
              top: size.height * 0.015,
              left: size.width * 0.84,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: () async {
                var direction = await LocationService().getDirection(
                    _originController.text, _destinationController.text);
                mapController.goToThePlace(
                  direction['start_location']['lat'],
                  direction['start_location']['lng'],
                  direction['bounds_ne'],
                  direction['bounds_sw'],
                );
                mapController.setPolyline(direction['polyline_decoded']);
              },
              icon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationService {
  final String key = 'AIzaSyDxB2sKz-esRgcRO-KbxapmuqwaT0UoZ58';

  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;

    print("===> place Id: $placeId");

    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print("===> getPlace results: $results");

    return results;
  }

  Future<Map<String, dynamic>> getDirection(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var result = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };

    print("===> getDirection result: $result");
    return result;
  }
}

// class MapSample extends StatefulWidget {
//   const MapSample({super.key});
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller =
//   Completer<GoogleMapController>();
//   TextEditingController _originController = TextEditingController();
//   TextEditingController _destinationController = TextEditingController();
//
//   Set<Marker> _markers = Set<Marker>();
//   Set<Polygon> _polygons = Set<Polygon>();
//   Set<Polyline> _polylines = Set<Polyline>();
//   List<LatLng> polygonLatLngs = <LatLng>[];
//
//   int _polygonIdCounter = 1;
//   int _polylineIdCounter = 1;
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     _setMarker(LatLng(37.42796133580664, -122.085749655962));
//   }
//
//   void _setMarker(LatLng point) {
//     setState(() {
//       _markers.add(Marker(
//         markerId: MarkerId('marker'),
//         position: point,
//       ));
//     });
//   }
//
//   void _setPolygon() {
//     final String polygonIdVal = 'polygon_$_polygonIdCounter';
//     _polygonIdCounter++;
//
//     _polygons.add(
//       Polygon(
//         polygonId: PolygonId(polygonIdVal),
//         points: polygonLatLngs,
//         strokeWidth: 2,
//         strokeColor: Colors.transparent,
//       ),
//     );
//   }
//
//   void _setPolyline(List<PointLatLng> points) {
//     final String polylineIdVal = 'polyline_$_polylineIdCounter';
//     _polygonIdCounter++;
//
//     _polylines.add(
//       Polyline(
//         polylineId: PolylineId(polylineIdVal),
//         width: 4,
//         color: Colors.blue,
//         points: points
//             .map(
//               (point) => LatLng(point.latitude, point.longitude),
//         )
//             .toList(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: Image.asset(AppImages.APP_NAME),
//         leading: Icon(
//           Icons.menu,
//           color: Colors.black45,
//         ),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             mapType: MapType.normal,
//             initialCameraPosition: _kGooglePlex,
//             markers: _markers,
//             polygons: _polygons,
//             polylines: _polylines,
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//             },
//             onTap: (point) {
//               setState(() {
//                 polygonLatLngs.add(point);
//                 _setPolygon();
//               });
//             },
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//               top: size.height * 0.01,
//               left: size.width * 0.02,
//               right: size.width * 0.2,
//             ),
//             child: TextFormField(
//               controller: _originController,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white,
//                 hintText: "Destination",
//                 hintStyle: const TextStyle(
//                   fontSize: 15,
//                   color: Colors.black26,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(
//                     width: 1,
//                     color: Color(0xFFF5F5F5),
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//               onChanged: (value) {
//                 print("===> search value: $value");
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(
//               top: size.height * 0.1,
//               left: size.width * 0.02,
//               right: size.width * 0.2,
//             ),
//             child: TextFormField(
//               controller: _destinationController,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: Colors.white,
//                 hintText: "Origin",
//                 hintStyle: const TextStyle(
//                   fontSize: 15,
//                   color: Colors.black26,
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(
//                     width: 1,
//                     color: Color(0xFFF5F5F5),
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//               onChanged: (value) {
//                 print("===> search value: $value");
//               },
//             ),
//           ),
//           IconButton(
//             onPressed: () async {
//               var direction = await LocationService().getDirection(
//                   _originController.text, _destinationController.text);
//               _goToThePlace(
//                 direction['start_location']['lat'],
//                 direction['start_location']['lng'],
//                 direction['bounds_ne'],
//                 direction['bounds_sw'],
//               );
//               _setPolyline(direction['polyline_decoded']);
//             },
//             icon: Icon(Icons.search),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _goToThePlace(
//       double lat,
//       double lng,
//       Map<String, dynamic> boundsNe,
//       Map<String, dynamic> boundsSw,
//       // Map<String, dynamic> place
//       ) async {
//     // final double lat = place['geometry']['location']['lat'];
//     // final double lng = place['geometry']['location']['lng'];
//
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(target: LatLng(lat, lng), zoom: 12),
//     ));
//
//     controller.animateCamera(
//       CameraUpdate.newLatLngBounds(
//           LatLngBounds(
//             southwest: LatLng(boundsSw[lat], boundsSw[lng]),
//             northeast: LatLng(boundsNe[lat], boundsNe[lng]),
//           ),
//           25),
//     );
//
//     _setMarker(LatLng(lat, lng));
//   }
// }
//
// class LocationService {
//   final String key = 'AIzaSyDxB2sKz-esRgcRO-KbxapmuqwaT0UoZ58';
//
//   Future<String> getPlaceId(String input) async {
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
//
//     var response = await http.get(Uri.parse(url));
//     var json = convert.jsonDecode(response.body);
//     var placeId = json['candidates'][0]['place_id'] as String;
//
//     print("===> place Id: $placeId");
//
//     return placeId;
//   }
//
//   Future<Map<String, dynamic>> getPlace(String input) async {
//     final placeId = await getPlaceId(input);
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
//
//     var response = await http.get(Uri.parse(url));
//     var json = convert.jsonDecode(response.body);
//     var results = json['result'] as Map<String, dynamic>;
//
//     print("===> getPlace results: $results");
//
//     return results;
//   }
//
//   Future<Map<String, dynamic>> getDirection(
//       String origin, String destination) async {
//     final String url =
//         'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$key';
//
//     var response = await http.get(Uri.parse(url));
//     var json = convert.jsonDecode(response.body);
//     var result = {
//       'bounds_ne': json['routes'][0]['bounds']['northeast'],
//       'bounds_sw': json['routes'][0]['bounds']['southwest'],
//       'start_location': json['routes'][0]['legs'][0]['start_location'],
//       'end_location': json['routes'][0]['legs'][0]['end_location'],
//       'polyline': json['routes'][0]['overview_polyline']['points'],
//       'polyline_decoded': PolylinePoints()
//           .decodePolyline(json['routes'][0]['overview_polyline']['points']),
//     };
//
//     print("===> getDirection result: $result");
//     return result;
//   }
// }

// class MapSample extends StatefulWidget {
//   const MapSample({super.key});
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   final TextEditingController _searchController = TextEditingController();
//
//   static const Marker _kGooglePlexMarker = Marker(
//       markerId: MarkerId('_kGooglePlex'),
//       infoWindow: InfoWindow(title: 'Google Plex'),
//       icon: BitmapDescriptor.defaultMarker,
//       position: LatLng(37.42796133580664, -122.085749655962));
//
//   static final Marker _kLakeMarker = Marker(
//       markerId: const MarkerId('_kLakeMarker'),
//       infoWindow: const InfoWindow(title: 'Lake'),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//       position: const LatLng(37.43296265331129, -122.08832357078792));
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   static const Polyline _kPolyline = Polyline(
//     polylineId: PolylineId(('_kPolyline')),
//     points: [
//       LatLng(37.42796133580664, -122.085749655962),
//       LatLng(37.43296265331129, -122.08832357078792)
//     ],
//     width: 5,
//   );
//
//   static const Polygon _kPolygon = Polygon(
//     polygonId: PolygonId('_kPolygon'),
//     points: [
//       LatLng(37.43296265331129, -122.08832357078792),
//       LatLng(37.42796133580664, -122.085749655962),
//       LatLng(37.418, -122.092),
//       LatLng(37.435, -122.092),
//     ],
//     strokeWidth: 5,
//     fillColor: Colors.transparent,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.transparent,
//         title: Text("Hello"),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: <Color>[Colors.black, Colors.transparent]),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   controller: _searchController,
//                   textCapitalization: TextCapitalization.words,
//                   decoration: const InputDecoration(hintText: "Search by City"),
//                   onChanged: (value) {
//                     debugPrint("===> value : $value");
//                   },
//                 ),
//               ),
//               IconButton(
//                   onPressed: () async {
//                     var place = await LocationService()
//                         .getPlace(_searchController.text);
//                     _goToPlace(place);
//                   },
//                   icon: Icon(Icons.search))
//             ],
//           ),
//           Expanded(
//             child: GoogleMap(
//               mapType: MapType.normal,
//               markers: {
//                 _kGooglePlexMarker,
//                 // _kLakeMarker,
//               },
//               initialCameraPosition: _kGooglePlex,
//               // polylines: {_kPolyline},
//               // polygons: {_kPolygon},
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }
//
//   Future<void> _goToPlace(Map<String, dynamic> place) async {
//     final double lat = place['geometry']['location']['lat'];
//     final double lng = place['geometry']['location']['lng'];
//
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: LatLng(lat, lng), zoom: 12),
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
//
// class LocationService {
//   final String key =
//       "AIzaSyDxB2sKz-esRgcRO-KbxapmuqwaT0UoZ58"; // Google API key
//
//   Future<String> getPlaceId(String input) async {
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
//
//     print("===> url: $url");
//
//     var response = await http.get(Uri.parse(url));
//     print("===> response: ${response.body}");
//     var json = convert.jsonDecode(response.body);
//     print("===> json: $json");
//     var candidates = json['candidates'] as List<dynamic>;
//     print("===> candidates: $candidates");
//
//     if (candidates.isNotEmpty) {
//       var placeID = candidates[0]['place_id'] as String;
//       print("===> placeID: $placeID");
//       return placeID;
//     } else {
//       throw Exception('No place found for the given input.');
//     }
//   }
//
//   Future<Map<String, dynamic>> getPlace(String input) async {
//     final placeId = await getPlaceId(input);
//
//     if (placeId.isNotEmpty) {
//       final String url =
//           'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
//
//       var response = await http.get(Uri.parse(url));
//       var json = convert.jsonDecode(response.body);
//       var results = json['result'] as Map<String, dynamic>;
//       print("===> results: $results");
//
//       return results;
//     } else {
//       throw Exception('No place found for the given input.');
//     }
//   }
// }

// class MapRepo extends StatefulWidget {
//   const MapRepo({Key? key}) : super(key: key);
//
//   @override
//   State<MapRepo> createState() => MapRepoState();
// }
//
// class MapRepoState extends State<MapRepo> {
//   GoogleMapController? myMapController;
//   PolylinePoints polylinePoints = PolylinePoints();
//
//   String googleAPIKey = "AIzaSyAknPEENU__YRfnsBmp6ASfb3NqwkAl1Rs";
//
//   Set<Marker> markers = Set();
//   Map<PolylineId, Polyline> polylines = {};
//
//   static const LatLng sourceLocation = LatLng(11.302687, 76.938239);
//   static const LatLng destination = LatLng(11.016975, 76.968602);
//
//   @override
//   void initState() {
//     super.initState();
//
//     markers.add(Marker(
//       markerId: MarkerId(sourceLocation.toString()),
//       position: sourceLocation,
//       infoWindow: const InfoWindow(
//         title: 'Starting Point',
//         snippet: 'Start Marker',
//       ),
//       icon: BitmapDescriptor.defaultMarker,
//     ));
//
//     markers.add(Marker(
//       markerId: MarkerId(destination.toString()),
//       position: destination,
//       infoWindow: const InfoWindow(
//         title: 'Destination Point',
//         snippet: 'Destination Marker',
//       ),
//       icon: BitmapDescriptor.defaultMarker,
//     ));
//
//     getDirections();
//   }
//
//   Future<void> getDirections() async {
//     List<LatLng> polylineCoordinates = [];
//
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleAPIKey,
//       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//       travelMode: TravelMode.driving,
//     );
//
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//
//     addPolyLine(polylineCoordinates);
//   }
//
//   void addPolyLine(List<LatLng> polylineCoordinates) {
//     PolylineId id = const PolylineId("poly");
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.deepPurpleAccent,
//       points: polylineCoordinates,
//       width: 8,
//     );
//     polylines[id] = polyline;
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: const Padding(
//             padding: EdgeInsets.only(
//                 left: Dimensions.PADDING_SIZE_LARGE,
//                 right: Dimensions.PADDING_SIZE_SMALL,
//                 top: Dimensions.PADDING_SIZE_LARGE,
//                 bottom: Dimensions.PADDING_SIZE_LARGE),
//             child: Icon(
//               Icons.menu,
//               color: Colors.black,
//             )),
//         title: Image.asset(AppImages.APP_NAME),
//       ),
//       body: GoogleMap(
//         zoomControlsEnabled: false,
//         initialCameraPosition: const CameraPosition(
//           target: sourceLocation,
//           zoom: 16.0,
//         ),
//         markers: markers,
//         polylines: Set<Polyline>.of(polylines.values),
//         mapType: MapType.normal,
//         onMapCreated: (controller) {
//           setState(() {
//             myMapController = controller;
//           });
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: getDirections,
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }
// }
//
// class LocationSearchWidget extends StatefulWidget {
//   @override
//   _LocationSearchWidgetState createState() => _LocationSearchWidgetState();
// }
//
// class _LocationSearchWidgetState extends State<LocationSearchWidget> {
//   final TextEditingController _searchController = TextEditingController();
//   List<String> _suggestions = [];
//
//   void _fetchSuggestions(String input) async {
//     final apiKey =
//         'AIzaSyAknPEENU__YRfnsBmp6ASfb3NqwkAl1Rs'; // Replace with your API key
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&key=$apiKey';
//
//     var response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       var json = convert.jsonDecode(response.body);
//       var predictions = json['predictions'] as List<dynamic>;
//       var suggestions = predictions.map((prediction) {
//         return prediction['description'] as String;
//       }).toList();
//
//       setState(() {
//         _suggestions = suggestions;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: _searchController,
//           decoration: InputDecoration(
//             hintText: 'Search for a location',
//             suffixIcon: IconButton(
//               onPressed: () {
//                 _searchController.clear();
//               },
//               icon: const Icon(Icons.clear),
//             ),
//           ),
//           onChanged: (value) {
//             _fetchSuggestions(value);
//           },
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           itemCount: _suggestions.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(_suggestions[index]),
//               onTap: () {
//                 // Handle location selection
//                 print('Selected location: ${_suggestions[index]}');
//               },
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// class MapRepo extends StatefulWidget {
//   const MapRepo({super.key});
//
//   @override
//   State<MapRepo> createState() => MapRepoState();
// }
//
// class MapRepoState extends State<MapRepo> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   final MapController mapController = Get.put(MapController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.normal,
//         zoomControlsEnabled: false,
//         compassEnabled: false,
//         initialCameraPosition: MapController.kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         markers: mapController.thisLocation != null
//             ? {
//                 Marker(
//                   markerId: const MarkerId('currentLocation'),
//                   position: LatLng(
//                     mapController.thisLocation!.latitude!,
//                     mapController.thisLocation!.longitude!,
//                   ),
//                   icon: mapController.customIcon,
//                 ),
//                 const Marker(
//                   markerId: MarkerId("source"),
//                   position: MapController.sourceLocation,
//                 ),
//                 const Marker(
//                   markerId: MarkerId("destination"),
//                   position: MapController.destination,
//                 ),
//               }
//             : {},
//       ),
//     );
//   }
// }
