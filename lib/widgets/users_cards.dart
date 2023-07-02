import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/widgets/user_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersCards extends StatefulWidget {
  final String rideId;

  const UsersCards({Key? key, required this.rideId}) : super(key: key);

  @override
  State<UsersCards> createState() => _UsersCardsState();
}

class _UsersCardsState extends State<UsersCards> {
  RideController rideController = Get.find<RideController>();

  @override
  void initState() {
    super.initState();
    print('length of user Snapshot = ${rideController.userSnapshots.length}');
    print("driver Id = ${FirebaseAuth.instance.currentUser!.uid} ");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rideController.getAcceptedUserForRide(widget.rideId);
      rideController.getUpcomingRidesForUser();
      rideController.getMyDocument();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        itemCount: rideController.userSnapshots.length,
        itemBuilder: (context, index) {
          DocumentSnapshot user = rideController.userSnapshots[index];
          print(user.data());

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 2),
            child: UserBox(
              user: user,
              rideId: widget.rideId,
            ),
          );
        },
      ),
    );
  }
}
