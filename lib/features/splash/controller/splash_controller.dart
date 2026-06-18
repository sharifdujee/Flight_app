
import 'package:flight_app/features/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    navigateNext();
    super.onInit();
  }

  void navigateNext(){
    Future.delayed(const Duration(seconds: 30),(){
      Get.offAllNamed(AppRoutes.home);
    });

  }
}