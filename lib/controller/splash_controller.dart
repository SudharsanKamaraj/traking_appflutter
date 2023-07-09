import 'package:get/get.dart';
import 'package:tracking_app/view/screens/home_page/home_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.to(const HomePage());
  }
}
