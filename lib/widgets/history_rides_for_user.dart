import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/widgets/ride_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryRidesForUser extends StatefulWidget {
  const HistoryRidesForUser({Key? key}) : super(key: key);

  @override
  State<HistoryRidesForUser> createState() => _RidesCardsState();
}

class _RidesCardsState extends State<HistoryRidesForUser> {
  RideController rideController = Get.find<RideController>();

  @override
  void initState() {
    super.initState();

    print('length of userHistory = ${rideController.userHistory.length}');
    print('length of allRides = ${rideController.allRides.length}');
    print('length of allUsers = ${rideController.allUsers.length}');
    print("driver Id = ${FirebaseAuth.instance.currentUser!.uid} ");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rideController.getRidesIJoined();
      rideController.getRideHistoryForUser();
      rideController.getMyDocument();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot driver = rideController.allUsers.firstWhere(
                (e) => rideController.userHistory[index].get('driver') == e.id);

            return Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: RideBox(
                  ride: rideController.userHistory[index],
                  driver: driver,
                  showCarDetails: false,
                  shouldNavigate: true,
                ));
          },
          itemCount: rideController.userHistory.length,
        ));
  }
}
