// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:tracking_app/controller/map_conteoller.dart'; // import 'package:get/get.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:tracking_app/controller/map_conteoller.dart';
// // import 'package:tracking_app/util/image_const.dart';
// //
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late MapController mapController;
//   GoogleMapController? _mapController;
//
//   @override
//   void initState() {
//     super.initState();
//     mapController = Get.put(MapController());
//     // _startRefreshTimer();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Map Screen')),
//       body: Obx(() {
//         final markers = mapController.markers.toList();
//         return GoogleMap(
//           onMapCreated: (controller) {
//             mapController.onMapCreated(controller);
//           },
//           initialCameraPosition: CameraPosition(
//             target: LatLng(0, 0),
//             zoom: 15.0,
//           ),
//           markers: markers.toSet(),
//         );
//       }),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 if (mapController.isLocationPermissionDenied.value) {
//                   mapController.requestLocationPermission();
//                 } else {
//                   mapController.disableLocationPermission();
//                 }
//               },
//               child: Obx(() {
//                 return Text(
//                   mapController.isLocationPermissionDenied.value
//                       ? "Turn On Location"
//                       : "Turn Off Location",
//                 );
//               }),
//             ),
//           ),
//           FloatingActionButton(
//             onPressed: () {
//               // Save a new LatLng to the list
//               final newLatLng = LatLng(
//                   37.7749, -122.4194); // Replace with your desired LatLng
//               mapController.saveNewLatLng(newLatLng);
//             },
//             child: Icon(Icons.add),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // class HomePage extends StatefulWidget {
// //   const HomePage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   late MapController mapController;
// //   TextEditingController _originController = TextEditingController();
// //   TextEditingController _destinationController = TextEditingController();
// //   // late Timer _refreshTimer;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     mapController = Get.put(MapController());
// //     // _startRefreshTimer();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _originController.dispose();
// //     _destinationController.dispose();
// //     // _refreshTimer?.cancel();
// //     super.dispose();
// //   }
// //
// //   static const CameraPosition _kGooglePlex = CameraPosition(
// //     target: LatLng(37.42796133580664, -122.085749655962),
// //     zoom: 14.4746,
// //   );
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     Size size = MediaQuery.of(context).size;
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         automaticallyImplyLeading: false,
// //         centerTitle: true,
// //         title: new Image.asset(AppImages.APP_NAME),
// //       ),
// //       body: Stack(
// //         children: [
// //           GoogleMap(
// //             // Existing GoogleMap properties
// //             initialCameraPosition: _kGooglePlex,
// //             markers: Set<Marker>.of(mapController.getMarkers()),
// //             zoomControlsEnabled: false,
// //             polygons: mapController.polygons,
// //             polylines: mapController.polylines,
// //             onMapCreated: (GoogleMapController controller) {
// //               // Existing onMapCreated code
// //               mapController.setController(controller); // Update the controller
// //             },
// //             onTap: (point) {
// //               setState(() {
// //                 mapController.polygonLatLngs
// //                     .add(point); // Access polygonLatLngs from MapController
// //               });
// //             },
// //           ),
// //           Padding(
// //             padding: EdgeInsets.only(
// //               top: size.height * 0.01,
// //               left: size.width * 0.02,
// //               right: size.width * 0.2,
// //             ),
// //             child: TextFormField(
// //               controller: _originController,
// //               decoration: InputDecoration(
// //                 filled: true,
// //                 fillColor: Colors.white,
// //                 hintText: "Origin",
// //                 hintStyle: const TextStyle(
// //                   fontSize: 15,
// //                   color: Colors.black26,
// //                 ),
// //                 border: InputBorder.none,
// //                 enabledBorder: OutlineInputBorder(
// //                   borderSide: const BorderSide(
// //                     width: 1,
// //                     color: Color(0xFFF5F5F5),
// //                   ),
// //                   borderRadius: BorderRadius.circular(15),
// //                 ),
// //               ),
// //               // onChanged: (value) {
// //               //   print("===> search value: $value");
// //               // },
// //             ),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.only(
// //               top: size.height * 0.1,
// //               left: size.width * 0.02,
// //               right: size.width * 0.2,
// //             ),
// //             child: TextFormField(
// //               controller: _destinationController,
// //               decoration: InputDecoration(
// //                 filled: true,
// //                 fillColor: Colors.white,
// //                 hintText: "Destination",
// //                 hintStyle: const TextStyle(
// //                   fontSize: 15,
// //                   color: Colors.black26,
// //                 ),
// //                 border: InputBorder.none,
// //                 enabledBorder: OutlineInputBorder(
// //                   borderSide: const BorderSide(
// //                     width: 1,
// //                     color: Color(0xFFF5F5F5),
// //                   ),
// //                   borderRadius: BorderRadius.circular(15),
// //                 ),
// //               ),
// //               // onChanged: (value) {
// //               //   print("===> search value: $value");
// //               // },
// //             ),
// //           ),
// //           Container(
// //             height: 50,
// //             margin: EdgeInsets.only(
// //               top: size.height * 0.015,
// //               left: size.width * 0.84,
// //             ),
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               color: Colors.white,
// //             ),
// //             child: IconButton(
// //               onPressed: () async {
// //                 var direction = await mapController.getDirection(
// //                     _originController.text, _destinationController.text);
// //                 mapController.goToThePlace(
// //                   direction['start_location']['lat'],
// //                   direction['start_location']['lng'],
// //                   direction['bounds_ne'],
// //                   direction['bounds_sw'],
// //                 );
// //                 mapController.setPolyline(direction['polyline_decoded']);
// //               },
// //               icon: Icon(Icons.search),
// //             ),
// //           ),
// //           Align(
// //             alignment: Alignment.bottomCenter,
// //             child: Container(
// //               height: 70,
// //               width: double.infinity,
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.only(
// //                   topLeft: Radius.circular(20),
// //                   topRight: Radius.circular(20),
// //                 ),
// //               ),
// //               padding: EdgeInsets.all(20),
// //               child: Text(
// //                 "Total Distance: ${mapController.distance.toStringAsFixed(2)} km",
// //                 textAlign: TextAlign.left,
// //                 style: TextStyle(
// //                   fontSize: 20,
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
