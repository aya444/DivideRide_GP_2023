import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/views/driver/driver_home.dart';
import 'package:divide_ride/views/tabs/ongoing_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/ride_controller.dart';
import '../../shared preferences/shared_pref.dart';
import '../../utils/app_constants.dart';
import '../../widgets/users_cards.dart';
import '../my_rides.dart';

class ViewUsers extends StatefulWidget {
  final String rideId;

  const ViewUsers({Key? key, required this.rideId}) : super(key: key);

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  RideController rideController = Get.find<RideController>();
  bool isDriver = false;

  @override
  void initState() {
    isDriver = CacheHelper.getData(key: AppConstants.decisionKey) ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenColor,
        title: Text('Users To Pick Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: UsersCards(
                rideId: widget.rideId,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Container(
                width: 200.00,
                child: ElevatedButton(
                  onPressed: () {
                    rideController.endRide(widget.rideId);
                     rideController.updateOngoingDriverRide();
                     rideController.updateOngoingUserRide();
                     Get.to(() => DriverHomeScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Text(
                      'End Ride',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 21),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
