import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tracking_app/util/image_const.dart';

const storeLocal = FlutterSecureStorage();

class BackgroundConstant extends StatelessWidget {
  const BackgroundConstant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Image.asset(
      AppImages.APP_LOGO_TXT,
      fit: BoxFit.cover,
    );
  }
}
