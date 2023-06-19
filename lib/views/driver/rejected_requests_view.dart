import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/models/user_model/user_model.dart';
import 'package:divide_ride/widgets/ride_before_database.dart';
import 'package:divide_ride/widgets/ride_box.dart';
import 'package:divide_ride/widgets/ride_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RejectedRequestsView extends StatefulWidget {
  const RejectedRequestsView({Key? key}) : super(key: key);

  @override
  State<RejectedRequestsView> createState() => _RejectedRequestsViewState();
}

class _RejectedRequestsViewState extends State<RejectedRequestsView> {


  RideController rideController = Get.find<RideController>();


  @override
  void initState() {
    super.initState();


    print('length of ridesICreated = ${rideController.ridesICreated.length}');
    print('length of allRides = ${rideController.allRides.length}');
    print('length of allUsers = ${rideController.allUsers.length}');
    print("driver Id = ${FirebaseAuth.instance.currentUser!.uid} ");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rideController.getRidesICreated();
      rideController.getMyDocument();
    });

  }


  @override
  Widget build(BuildContext context) {


    return Obx(() => ListView.builder(

      shrinkWrap: true,
      //physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {

        //DocumentSnapshot driver = rideController.allUsers.firstWhere( (e) => rideController.allRides[index].get('driver') == e.id );

        DocumentSnapshot driver = rideController.myDocument!;

        return Padding(
            padding: EdgeInsets.symmetric(vertical: 13 , horizontal: 1),

            child: RideBox( ride: rideController.ridesICreated[index] , driver: driver , showCarDetails: false,));
      }
      , itemCount: rideController.ridesICreated.length,)
    );
  }


}