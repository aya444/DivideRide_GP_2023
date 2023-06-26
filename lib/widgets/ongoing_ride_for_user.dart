import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/widgets/ride_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OngoingRideForUser extends StatefulWidget {
  const OngoingRideForUser({Key? key}) : super(key: key);

  @override
  State<OngoingRideForUser> createState() => _OngoingRideForUserState();
}

class _OngoingRideForUserState extends State<OngoingRideForUser> {
  RideController rideController = Get.find<RideController>();

  @override
  void initState() {
    super.initState();

    print('length of allRides = ${rideController.allRides.length}');
    print('length of allUsers = ${rideController.allUsers.length}');
    print('length of currentRides = ${rideController.userCurrentRide.length}');
    print("driver Id = ${FirebaseAuth.instance.currentUser!.uid} ");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rideController.getRidesIJoined();
      rideController.getOngoingRideForUser();
      rideController.getMyDocument();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot driver = rideController.allUsers.firstWhere((e) =>
                rideController.userCurrentRide[index].get('driver') == e.id);

            return Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: RideBox(
                  ride: rideController.userCurrentRide[index],
                  driver: driver,
                  showCarDetails: false,
                  shouldNavigate: true,
                  showStartOption: true,
                ));
          },
          itemCount: rideController.userCurrentRide.length,
        ));
  }
}
