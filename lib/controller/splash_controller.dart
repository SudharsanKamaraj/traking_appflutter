import 'package:get/get.dart';

class SplashController extends GetxController {
  void navigationStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    // Get.to(const HomePage());
  }
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
