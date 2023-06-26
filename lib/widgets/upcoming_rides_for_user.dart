import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/widgets/ride_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/ride_controller.dart';

class UpcomingRidesForUser extends StatefulWidget {
  const UpcomingRidesForUser({Key? key}) : super(key: key);

  @override
  State<UpcomingRidesForUser> createState() => _UpcomingRidesForUserState();
}

class _UpcomingRidesForUserState extends State<UpcomingRidesForUser> {
  RideController rideController = Get.find<RideController>();

  @override
  void initState() {
    print('length of upcomingRides = ${rideController.upcomingRidesForUser.length}');
    print('length of allRides = ${rideController.allRides.length}');
    print('length of allUsers = ${rideController.allUsers.length}');
    print("driver Id = ${FirebaseAuth.instance.currentUser!.uid} ");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rideController.getRidesIJoined();
      rideController.getUpcomingRidesForUser();
      rideController.getMyDocument();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot driver = rideController.allUsers.firstWhere((e) =>
                rideController.upcomingRidesForUser[index].get('driver') == e.id);

            return Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: RideBox(
                  ride: rideController.upcomingRidesForUser[index],
                  driver: driver,
                  showCarDetails: false,
                  shouldNavigate: true,
                ));
          },
          itemCount: rideController.upcomingRidesForUser.length,
        ));
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:divide_ride/controller/ride_controller.dart';
// import 'package:divide_ride/models/user_model/user_model.dart';
// import 'package:divide_ride/widgets/ride_before_database.dart';
// import 'package:divide_ride/widgets/ride_box.dart';
// import 'package:divide_ride/widgets/ride_card.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../models/driver_model/driver_model.dart';
// import '../views/ride_details_before_database.dart';
//
// class UpcomingRidesForUser extends StatefulWidget {
//   const UpcomingRidesForUser({Key? key}) : super(key: key);
//
//   @override
//   State<UpcomingRidesForUser> createState() => _RidesCardsState();
// }
//
// class _RidesCardsState extends State<UpcomingRidesForUser> {
//
//
//   RideController rideController = Get.find<RideController>();
//
//   @override
//   void initState() {
//     super.initState();
//
//     print('length of allRides = ${rideController.allRides.length}');
//     print('length of allUsers = ${rideController.allUsers.length}');
//     print("user Id = ${FirebaseAuth.instance.currentUser!.uid} ");
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//
//     });
//
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Obx(() =>
//   //   rideController.isRidesLoading.value ? Center(
//   //     child: CircularProgressIndicator(),) : ListView.builder(
//   //
//   //     shrinkWrap: true,
//   //     physics: NeverScrollableScrollPhysics(),
//   //     itemBuilder: (context, index) {
//   //       return Padding(
//   //           padding: EdgeInsets.symmetric(vertical: 13),
//   //           child: RideCard(rideController.allRides[index],));
//   //     }
//   //     , itemCount: rideController.allRides.length,)
//   //   );
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Obx(() => ListView.builder(
//
//       shrinkWrap: true,
//       //physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//
//         DocumentSnapshot driver = rideController.allUsers.firstWhere( (e) => rideController.allRides[index].get('driver') == e.id );
//
//         return Padding(
//             padding: EdgeInsets.symmetric(vertical: 13 , horizontal: 2),
//
//             child: RideBox( ride: rideController.allRides[index] , driver: driver , showCarDetails: false , shouldNavigate: true,));
//       }
//       , itemCount: rideController.allRides.length,)
//     );
//   }
//
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return ListView.builder(
//   //
//   //     shrinkWrap: true,
//   //     // physics: NeverScrollableScrollPhysics(),
//   //     itemBuilder: (context, index) {
//   //       return Padding(
//   //           padding: EdgeInsets.symmetric(horizontal:1 , vertical: 13),
//   //           child: RideBox( ride: rides[index] , driver:  drivers[index] , showCarDetails: false ));
//   //     }
//   //     , itemCount: rides.length,);
//   // }
//
//
//   final List<Driver> drivers = [
//     Driver(
//         name: "Habiba",
//         averageReview: 0,
//         totalReviews: 0,
//         profile: "assets/driver_2.png",
//         car: "Nissan Sunny"
//     ),
//     Driver(
//         name: "Aya",
//         averageReview: 0,
//         totalReviews: 0,
//         profile: "assets/driver_3.png",
//         car: "Toyota corolla"
//     ),
//     Driver(
//       name: "George",
//       averageReview: 2,
//       totalReviews: 0,
//       profile: "assets/driver_1.png",
//       car: "BMW",
//     ),
//   ];
//
//
//   final List<Ride> rides = [
//     Ride(
//       from:"New Cairo",
//       to: "Madinaty",
//       date: "22 Feb",
//       time: "14:15",
//     ),
//     Ride(
//       from:"Zamalek",
//       to: "Heliopolis",
//       date: "25 Feb",
//       time: "16:25",
//     ),
//     Ride(
//       from:"Shoubra",
//       to: "Nasr city",
//       date: "27 Feb",
//       time: "18:20",
//     ),
//
//   ];
//
// }
//
// class Driver {
//   final String name;
//   final int averageReview;
//   final int totalReviews;
//   final String profile;
//   final String car;
//   Driver({
//     required this.name,
//     required this.averageReview,
//     required this.totalReviews,
//     required this.profile,
//     required this.car,
//   });
// }
//
// class Ride {
//   final String from;
//   final String to ;
//   final String date;
//   final String time;
//   Ride({
//     required this.from,
//     required this.to,
//     required this.date,
//     required this.time,
//   });
// }
//
//
//
//
//
//
//
//
