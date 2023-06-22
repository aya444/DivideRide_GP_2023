import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/models/user_model/user_model.dart';
import 'package:divide_ride/widgets/ride_before_database.dart';
import 'package:divide_ride/widgets/ride_box.dart';
import 'package:divide_ride/widgets/ride_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/driver_model/driver_model.dart';
import '../views/ride_details_before_database.dart';

class HistoryRidesForDriver extends StatefulWidget {
  const HistoryRidesForDriver({Key? key}) : super(key: key);

  @override
  State<HistoryRidesForDriver> createState() => _UpcomingRidesForDriverState();
}

class _UpcomingRidesForDriverState extends State<HistoryRidesForDriver> {


  RideController rideController = Get.find<RideController>();


  @override
  void initState() {
    super.initState();


    print('length of ridesICancelled = ${rideController.ridesICancelled.length}');
    print('length of allRides = ${rideController.allRides.length}');
    print('length of allUsers = ${rideController.allUsers.length}');
    print("driver Id = ${FirebaseAuth.instance.currentUser!.uid} ");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rideController.getRidesICancelled();
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
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 2),

            child: RideBox( ride: rideController.ridesICancelled[index] , driver: driver , showCarDetails: false , shouldNavigate: true,));
      }
      , itemCount: rideController.ridesICancelled.length,)
    );
  }


}









