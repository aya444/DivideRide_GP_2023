import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/models/user_model/user_model.dart';
import 'package:divide_ride/widgets/ride_before_database.dart';
import 'package:divide_ride/widgets/ride_box.dart';
import 'package:divide_ride/widgets/ride_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PendingRequestsView extends StatefulWidget {
  const PendingRequestsView({Key? key}) : super(key: key);

  @override
  State<PendingRequestsView> createState() => _PendingRequestsViewState();
}

class _PendingRequestsViewState extends State<PendingRequestsView> {


  RideController rideController = Get.find<RideController>();


  @override
  void initState() {
    super.initState();


    print('length of ridesICreated = ${rideController.ridesICreated.length}');
    print('length of allRides = ${rideController.allRides.length}');
    print('length of allUsers = ${rideController.allUsers.length}');
    print("length of pendingRequests = ${rideController.pendingRequests.length}");
    print("driver Id = ${FirebaseAuth.instance.currentUser!.uid} ");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rideController.getPendingRequests();
    });

  }


  @override
  Widget build(BuildContext context) {


    return Obx(() => ListView.builder(

      shrinkWrap: true,
      //physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {


        DocumentSnapshot user = rideController.allUsers.firstWhere( (e) => rideController.pendingRequests[index].get('user_id') == e.id );

        DocumentSnapshot ride = rideController.allRides.firstWhere( (e) => rideController.pendingRequests[index].get('ride_id') == e.id );

        return Padding(
            padding: EdgeInsets.symmetric(vertical: 13,horizontal: 1),

            child: RideBox( ride: ride , driver: user , showCarDetails: false , showOptions: true));
      }
      , itemCount: rideController.pendingRequests.length,)
    );
  }


}