import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/shared%20preferences/shared_pref.dart';
import 'package:divide_ride/views/decision_screens/decision_screen.dart';
import 'package:divide_ride/views/home.dart';
import 'package:divide_ride/views/login_screen.dart';
import 'package:divide_ride/views/ride_details_view.dart';
import 'package:divide_ride/views/rides_view.dart';
import 'package:divide_ride/views/my_rides.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controller/auth_controller.dart';
import 'firebase_options.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    RideController rideController = Get.put(RideController());
    authController.decideRoute();
    final textTheme = Theme.of(context).textTheme;

    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff5a73d8),
        textTheme: GoogleFonts.poppinsTextTheme(textTheme),
      ),
      home: DecisionScreen(),

      //MyRides(),



    );
  }
}