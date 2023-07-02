import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/widgets/ride_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OngoingRideForDriver extends StatefulWidget {
  const OngoingRideForDriver({Key? key}) : super(key: key);

  @override
  State<OngoingRideForDriver> createState() => _OngoingRideForDriverState();
}

class _OngoingRideForDriverState extends State<OngoingRideForDriver> {
  RideController rideController = Get.find<RideController>();

  @override
  void initState() {
    super.initState();

    print('length of allRides = ${rideController.allRides.length}');
    print('length of allUsers = ${rideController.allUsers.length}');
    print(
        'length of currentRides = ${rideController.driverCurrentRide.length}');
    print("driver Id = ${FirebaseAuth.instance.currentUser!.uid} ");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rideController.getOngoingRideForDriver();
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
                  ride: rideController.driverCurrentRide[index],
                  driver: driver,
                  showCarDetails: false,
                  shouldNavigate: true,
                  showStartOption: true,
                ));
          },
          itemCount: rideController.driverCurrentRide.length,
        ));
  }
}
