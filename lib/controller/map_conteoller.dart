import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart'
    show PolylinePoints, PolylineResult, PointLatLng;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final RxBool shouldRefresh = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshScreen();
  }

  void refreshScreen() {
    shouldRefresh.value = true;
  }

  @override
  void onClose() {
    super.onClose();
    shouldRefresh.close();
  }

  Set<Marker> markers = <Marker>{};
  Set<Polygon> polygons = <Polygon>{};
  Set<Polyline> polylines = <Polyline>{};
  List<LatLng> polygonLatLngs = <LatLng>[];

  int polygonIdCounter = 1;
  int polylineIdCounter = 1;

  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void setMarker(LatLng point) {
    markers.add(
      Marker(
        markerId: MarkerId('marker'),
        position: point,
      ),
    );
    update(); // Notify GetX that the state has changed
  }

  void setPolygon() {
    final String polygonIdVal = 'polygon_$polygonIdCounter';
    polygonIdCounter++;

    polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        strokeColor: Colors.transparent,
      ),
    );
    update(); // Notify GetX that the state has changed
  }

  void setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$polylineIdCounter';
    polylineIdCounter++;

    polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 5,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
    update(); // Notify GetX that the state has changed
  }

  Future<void> goToThePlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
    // Map<String, dynamic> place
  ) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(boundsSw[lat], boundsSw[lng]),
          northeast: LatLng(boundsNe[lat], boundsNe[lng]),
        ),
        25,
      ),
    );

    setMarker(LatLng(lat, lng));
  }

  void setController(GoogleMapController controller) {
    _controller.complete(controller);
  }
}

// class MapController extends GetxController {
//   final Completer<GoogleMapController> _controller = Completer();
//   late BitmapDescriptor customIcon;
//   LocationData? thisLocation;
//   // GoogleMapsRoutes googleMapsRoutes =
//   //     GoogleMapsRoutes(apiKey: 'AIzaSyAknPEENU__YRfnsBmp6ASfb3NqwkAl1Rs');
//
//   static const CameraPosition kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   Set<Polyline> polylines = {};
//   GoogleMapController? mapController;
//
//   void setCustomMarkerIcon() async {
//     customIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(),
//       AppIcons.MY_LOCATION_MARKER,
//     );
//   }
//
//   Future<void> getLocation() async {
//     Location location = Location();
//     LocationData currentLocation = await location.getLocation();
//     thisLocation = currentLocation!;
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(
//             currentLocation.latitude!,
//             currentLocation.longitude!,
//           ),
//           zoom: 15,
//         ),
//       ),
//     );
//     update(); // Update the state of the controller
//   }
//
//   static const LatLng sourceLocation = LatLng(11.302687, 76.938239);
//   static const LatLng destination = LatLng(11.016975, 76.968602);
//
//   Future<void> getPolyPoints() async {
//     try {
//       PolylinePoints polylinePoints = PolylinePoints();
//       List<LatLng> polylineCoordinates = [];
//       PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         'AIzaSyAknPEENU__YRfnsBmp6ASfb3NqwkAl1Rs',
//         PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//         PointLatLng(destination.latitude, destination.longitude),
//       );
//
//       debugPrint("===> result $result");
//
//       if (result.points.isNotEmpty) {
//         polylineCoordinates = result.points
//             .map((point) => LatLng(point.latitude, point.longitude))
//             .toList();
//       }
//
//       polylineCoordinates.clear();
//
//       if (result.points.isNotEmpty) {
//         polylineCoordinates = result.points
//             .map((point) => LatLng(point.latitude, point.longitude))
//             .toList();
//
//         final polyline = Polyline(
//           polylineId: const PolylineId('route'),
//           color: Colors.blue,
//           points: polylineCoordinates,
//           width: 4,
//         );
//
//         debugPrint("===> polyline $polyline");
//
//         polylines.add(polyline);
//       } else if (result.points.isEmpty) {
//         debugPrint("===> result.points.isEmpty");
//       } else {
//         debugPrint("===> result.points.sumthing");
//       }
//     } catch (e) {
//       print('Error fetching directions: $e');
//     }
//
//     update();
//   }
//
//   void setMapController(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   // Future<void> getPolyPoints() async {
//   //   try {
//   //     DirectionsResponse directions = await googleMapsRoutes.directions(
//   //       origin: sourceLocation,
//   //       destination: destination,
//   //     );
//   //
//   //     if (directions.routes.isNotEmpty) {
//   //       RouteInfo route = directions.routes.first;
//   //       List<LatLng> points = route.polylinePoints;
//   //
//   //       polylineCoordinates.clear();
//   //
//   //       if (points.isNotEmpty) {
//   //         polylineCoordinates = points;
//   //         Polyline polyline = Polyline(
//   //           polylineId: const PolylineId('route'),
//   //           color: Colors.blue,
//   //           points: polylineCoordinates,
//   //           width: 4,
//   //         );
//   //         polylines.add(polyline);
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching directions: $e');
//   //   }
//   //   update();
//   // }
//
//   @override
//   void onInit() {
//     super.onInit();
//     setCustomMarkerIcon();
//     getPolyPoints();
//     Future.delayed(const Duration(seconds: 4), () {
//       update(); // Update the state of the controller
//     });
//   }
// }

// class MapController extends GetxController {
//   final Completer<GoogleMapController> _controller = Completer();
//   late BitmapDescriptor customIcon;
//   LocationData? thisLocation;
//
//   static const CameraPosition kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   void setCustomMarkerIcon() async {
//     customIcon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(), AppIcons.MY_LOCATION_MARKER);
//   }
//
//   Future<void> getLocation() async {
//     Location location = Location();
//     LocationData currentLocation = await location.getLocation();
//     thisLocation = currentLocation!;
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(
//             currentLocation.latitude!,
//             currentLocation.longitude!,
//           ),
//           zoom: 15,
//         ),
//       ),
//     );
//     update(); // update the state of the controller
//   }
//
//   static const LatLng sourceLocation = LatLng(11.049983, 77.054013);
//   static const LatLng destination = LatLng(11.036933, 77.038318);
//
//   late List<LatLng> polylineCoordinates;
//
//   void getPolyPoints() {
//     polylineCoordinates = [
//       sourceLocation,
//       const LatLng(11.044903, 77.054327),
//       const LatLng(11.045973, 77.053319),
//       const LatLng(11.048040, 77.052460),
//       destination,
//     ];
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     setCustomMarkerIcon();
//     getPolyPoints();
//     Future.delayed(const Duration(seconds: 4), () {
//       update(); // update the state of the controller
//     });
//   }
// }

// class MapController extends GetxController {
//   final Completer<GoogleMapController> _controller = Completer();
//   late BitmapDescriptor customIcon;
//   LocationData? thisLocation;
//   GoogleMapsDirections googleMapsDirections;
//
//   static const CameraPosition kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   void setCustomMarkerIcon() async {
//     customIcon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(), AppIcons.MY_LOCATION_MARKER);
//   }
//
//   Future<void> getLocation() async {
//     Location location = Location();
//     LocationData currentLocation = await location.getLocation();
//     thisLocation = currentLocation!;
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: LatLng(
//             currentLocation.latitude!,
//             currentLocation.longitude!,
//           ),
//           zoom: 15,
//         ),
//       ),
//     );
//     update(); // update the state of the controller
//   }
//
//   static const LatLng sourceLocation = LatLng(11.049983, 77.054013);
//   static const LatLng destination = LatLng(11.036933, 77.038318);
//
//   late List<LatLng> polylineCoordinates;
//
//   void getPolyPoints() {
//     polylineCoordinates = [
//       sourceLocation,
//       const LatLng(11.044903, 77.054327),
//       const LatLng(11.045973, 77.053319),
//       const LatLng(11.048040, 77.052460),
//       destination,
//     ];
//   }
//
//   Future<void> getDirections(Location origin, Location destination) async {
//     try {
//       final directions = await googleMapsDirections.directions(
//         origin: '${origin.latitude},${origin.longitude}',
//         destination: '${destination.latitude},${destination.longitude}',
//         mode: "driving",
//       );
//
//       final route = directions.routes![0];
//       final distance = route.legs![0].distance;
//       final duration = route.legs![0].duration;
//
//       // Do something with the route information
//       print('Distance: ${distance?.text}');
//       print('Duration: ${duration?.text}');
//     } catch (e) {
//       // Handle any errors that occur during the API request
//       print('Error fetching directions: $e');
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     setCustomMarkerIcon();
//     getPolyPoints();
//     Future.delayed(const Duration(seconds: 4), () {
//       update(); // update the state of the controller
//     });
//     googleMapsDirections =
//         GoogleMapsDirections(apiKey: 'AIzaSyAknPEENU__YRfnsBmp6ASfb3NqwkAl1Rs');
//   }
// }
