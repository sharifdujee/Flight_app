import 'dart:async';
import 'package:flight_app/features/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Timer? _navTimer;

  @override
  void onInit() {
    super.onInit();
    navigateNext();
  }

  void navigateNext() {
    _navTimer = Timer(const Duration(seconds: 3), () {

      Get.offAllNamed(AppRoutes.home);
    });
  }

  @override
  void onClose() {
    _navTimer?.cancel();
    super.onClose();
  }
}