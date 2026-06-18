import 'package:flight_app/features/airport/presentation/screen/airport_selection_home.dart';
import 'package:flight_app/features/splash/presentation/screen/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {

  static const String init = "/";
  static const String home = "/home";

  static final List<GetPage> pages = [

    GetPage(name: init, page: ()=>SplashScreen()),
    GetPage(name: home, page: ()=>HomeScreen()),
  ]
  ;
}


