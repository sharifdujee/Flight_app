import 'package:flight_app/features/home/controller/home_controller.dart';
import 'package:flight_app/features/splash/controller/splash_controller.dart';
import 'package:get/get.dart';

import '../../features/airport/controller/airport_controller.dart';

class AppBinding  extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(()=>SplashController(), fenix: true);
    Get.lazyPut(()=>AirportController(), fenix: true);
    // TODO: implement dependencies
  }
}