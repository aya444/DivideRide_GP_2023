import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/widgets/ride_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpcomingRidesForDriver extends StatefulWidget {
  const UpcomingRidesForDriver({Key? key}) : super(key: key);

  @override
  State<UpcomingRidesForDriver> createState() => _UpcomingRidesForDriverState();
}

class _UpcomingRidesForDriverState extends State<UpcomingRidesForDriver> {
  RideController rideController = Get.find<RideController>();

  @override
  void initState() {
    super.initState();

    print('length of ridesICreated = ${rideController.ridesICreated.length}');
    print(
        'length of activeRides = ${rideController.upcomingRidesForDriver.length}');
    print('length of allRides = ${rideController.allRides.length}');
    print('length of allUsers = ${rideController.allUsers.length}');
    print("driver Id = ${FirebaseAuth.instance.currentUser!.uid} ");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rideController.getRidesICreated();
      rideController.getUpcomingRidesForDriver();
      rideController.getMyDocument();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot driver = rideController.myDocument!;

            return Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: RideBox(
                  ride: rideController.upcomingRidesForDriver[index],
                  driver: driver,
                  showCarDetails: false,
                  shouldNavigate: true,
                ));
          },
          itemCount: rideController.upcomingRidesForDriver.length,
        ));
  }
}
