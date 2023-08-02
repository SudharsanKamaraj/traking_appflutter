// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ArrayStorage {
//   static Future<int> _getNextId() async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'next_array_id';
//
//     int nextId = prefs.getInt(key) ?? 1;
//     await prefs.setInt(key, nextId + 1);
//
//     return nextId;
//   }
//
//   static Future<void> storeArray(List<int> array) async {
//     int id = await _getNextId();
//     final prefs = await SharedPreferences.getInstance();
//     final key = 'array_$id';
//
//     await prefs.setStringList(key, array.map((e) => e.toString()).toList());
//   }
//
//   static Future<List<List<int>>> getAllArrays() async {
//     final prefs = await SharedPreferences.getInstance();
//     final keys = prefs.getKeys();
//
//     List<List<int>> allArrays = [];
//
//     for (String key in keys) {
//       if (key.startsWith('array_')) {
//         List<String> stringArray = prefs.getStringList(key) ?? [];
//         List<int> array = stringArray.map((e) => int.parse(e)).toList();
//         allArrays.add(array);
//       }
//     }
//
//     return allArrays;
//   }
// }
//
// class YourListViewWidget extends StatefulWidget {
//   @override
//   _YourListViewWidgetState createState() => _YourListViewWidgetState();
// }
//
// class _YourListViewWidgetState extends State<YourListViewWidget> {
//   List<List<int>> allArrays = [];
//   var newArray = [123, 123];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchArrays();
//   }
//
//   void fetchArrays() async {
//     allArrays = await ArrayStorage.getAllArrays();
//     setState(() {}); // Update the UI after fetching the arrays.
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Arrays List View'),
//         ),
//         body: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 await ArrayStorage.storeArray(newArray);
//
//                 List<List<int>> allArrays = await ArrayStorage.getAllArrays();
//
//                 print('All stored arrays:');
//                 for (List<int> array in allArrays) {
//                   print(array);
//                 }
//               },
//               child: Text('Store and Retrieve Arrays'),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: allArrays.length,
//                 itemBuilder: (context, index) {
//                   List<int> array = allArrays[index];
//                   return Card(
//                     child: ListTile(
//                       title: Text('Array $index'),
//                       subtitle: Text(array.toString()),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ));
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: YourListViewWidget(),
//   ));
// }

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracking_app/controller/map_conteoller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request notification permission if it is denied
  var notificationStatus = await Permission.notification.status;
  if (notificationStatus.isDenied) {
    await Permission.notification.request();
  }

  // await initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePageMap(),
    );
  }
}

class MyName extends StatelessWidget {
  const MyName({Key? key}) : super(key: key);

  void forLoop() {
    double i = 0;
    double j = 10;
    for (i = 0; 5 >= i; i++) {
      print(i);
      for (j = 0; 5 >= j; j++) {
        print(j);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Sudharsan",
    );
  }
}

class MyHomePageMap extends StatefulWidget {
  @override
  _MyHomePageMapState createState() => _MyHomePageMapState();
}

class _MyHomePageMapState extends State<MyHomePageMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Location location = Location();
  LatLng _initialPosition = LatLng(0, 0); // Initial map location
  GoogleMapController? _mapController; // Use nullable type here
  Set<Marker> _markers = {};
  List<LatLng> latLngList = [];
  bool _isLocationTrack = false; // Add this line to track location status
  List<LatLng> _polylineCoordinates = [];
  var map = Map();
  List<List<LatLng>> allLatLngLists = [];

  void getPolyline(BuildContext context, array) {
    print("getPolyline : $array");
    setState(() {
      _polylineCoordinates = array;
      print(_polylineCoordinates);
      _polylines.add(
        Polyline(
          polylineId: PolylineId('polyline'),
          points: _polylineCoordinates,
          color: Colors.blue, // Color of the line (red in this case)
          width: 5, // Thickness of the line
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _createPolyline();
    _fetchAllLatLngLists();
    // getPolyline();
  }

  Future<void> _fetchAllLatLngLists() async {
    List<List<LatLng>> lists = await dataStorage.getAllLatLngLists();
    setState(() {
      allLatLngLists = lists;
    });
  }

  _requestLocationPermission() async {
    var status = await location.requestPermission();
    if (status == Permission.notification.isDenied) {
      // Handle permission denied
    } else {
      _listenToLocationUpdates(); // Start listening to location updates
    }
  }

  void _listenToLocationUpdates() {
    location.onLocationChanged.listen((LocationData? currentLocation) {
      if (_isLocationTrack == true && currentLocation != null) {
        setState(() {
          _initialPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          latLngList.add(_initialPosition);
          // dataStorage.saveLatLngList(latLngList);
          // print(map);
          // print("===> latLngList : $latLngList");
          _markers.add(Marker(
            markerId: MarkerId("userLocation"),
            position: _initialPosition,
          ));
        });
        if (_mapController != null) {
          _mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: _initialPosition, zoom: 16.0),
          ));
        }
      } else {
        print("==> it is not working");
      }
    });
  }

  Set<Polyline> _polylines = {};

  void _createPolyline() {
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('polyline'),
          points: _polylineCoordinates,
          color: Colors.blue, // Color of the line (red in this case)
          width: 5, // Thickness of the line
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('GPS Tracking'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ValueListenableBuilder<List<List<LatLng>>>(
          valueListenable: dataStorage.latLngListsNotifier,
          builder: (context, value, child) {
            // This builder will be called whenever the ValueNotifier is updated
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                List<LatLng> array = value[index];
                return GestureDetector(
                  onTap: () {
                    getPolyline(context, array);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('Array $index'),
                      subtitle: Text(array.toString()),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      body: Stack(children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition:
              CameraPosition(target: _initialPosition, zoom: 16.0),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          markers: _markers,
          polylines: _polylines,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 20),
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLocationTrack =
                      !_isLocationTrack; // Toggle location status
                  if (_isLocationTrack) {
                    _listenToLocationUpdates(); // Start listening to location updates
                    // print(map);
                    // getPolyline();
                  }
                });
                // print("===> latLngList : $latLngList");
                _isLocationTrack == false
                    ? await dataStorage.storeLatLngList(latLngList)
                    : null;
                _createPolyline();
                List<List<LatLng>> allLatLngLists =
                    await dataStorage.getAllLatLngLists();

                print('All stored LatLng lists:');
                for (List<LatLng> latLngList in allLatLngLists) {
                  print(latLngList);
                }
                // getPolyline();
                // FlutterBackgroundService().invoke('setAsBackground');
                // final service = FlutterBackgroundService();
                // bool isRunning = await service.isRunning();
                // if (isRunning) {
                //   service.invoke('stopService');
                // } else {
                //   service.startService();
                // }
              },
              child: Container(
                height: 40,
                width: _isLocationTrack ? 40 : 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
                child: Text(_isLocationTrack ? "end" : "Start"),
              ),
            ),
          ),
        ),
      ]),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () async {
      //       setState(() {
      //         _isLocationTrack = !_isLocationTrack; // Toggle location status
      //         if (_isLocationTrack) {
      //           _listenToLocationUpdates(); // Start listening to location updates
      //           // getPolyline();
      //         }
      //       });
      //       _createPolyline();
      //       // FlutterBackgroundService().invoke('setAsBackground');
      //       // final service = FlutterBackgroundService();
      //       // bool isRunning = await service.isRunning();
      //       // if (isRunning) {
      //       //   service.invoke('stopService');
      //       // } else {
      //       //   service.startService();
      //       // }
      //     },
      //     child: _isLocationTrack ? Text("") : Icons.location_off),
    );
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));
}

@pragma('vn:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) async {
      service.setAsForegroundService();
      // _listenToLocationUpdates();
      // print(
      //     "Location update in the background: $_listenToLocationUpdates");
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: "TRACKING APP", content: "this app");
      }
    }
    // print("background service running");
    service.invoke('update');
  });
}
