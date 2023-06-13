import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/models/user_model/user_model.dart';
import 'package:divide_ride/widgets/ride_before_database.dart';
import 'package:divide_ride/widgets/ride_box.dart';
import 'package:divide_ride/widgets/ride_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/driver_model/driver_model.dart';
import '../views/ride_details_before_database.dart';

class RidesCards extends StatefulWidget {
  const RidesCards({Key? key}) : super(key: key);

  @override
  State<RidesCards> createState() => _RidesCardsState();
}

class _RidesCardsState extends State<RidesCards> {


  RideController rideController = Get.find<RideController>();

  @override
  void initState() {
    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Obx(() =>
  //   rideController.isRidesLoading.value ? Center(
  //     child: CircularProgressIndicator(),) : ListView.builder(
  //
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemBuilder: (context, index) {
  //       return Padding(
  //           padding: EdgeInsets.symmetric(vertical: 13),
  //           child: RideCard(rideController.allRides[index],));
  //     }
  //     , itemCount: rideController.allRides.length,)
  //   );
  // }


  @override
  Widget build(BuildContext context) {

    return Obx(() =>
    rideController.isRidesLoading.value ? Center(
      child: CircularProgressIndicator(),) : ListView.builder(

      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {

        DocumentSnapshot driver = rideController.allUsers.firstWhere( (e) => rideController.allRides[index].get('driver') == e.id );

        return Padding(
            padding: EdgeInsets.symmetric(vertical: 13),

            child: RideBox( ride: rideController.allRides[index] , driver: driver , showCarDetails: false ));
      }
      , itemCount: rideController.allRides.length,)
    );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return ListView.builder(
  //
  //     shrinkWrap: true,
  //     // physics: NeverScrollableScrollPhysics(),
  //     itemBuilder: (context, index) {
  //       return Padding(
  //           padding: EdgeInsets.symmetric(horizontal:1 , vertical: 13),
  //           child: RideBox( ride: rides[index] , driver:  drivers[index] , showCarDetails: false ));
  //     }
  //     , itemCount: rides.length,);
  // }


final List<Driver> drivers = [
    Driver(
      name: "Habiba",
      averageReview: 0,
      totalReviews: 0,
      profile: "assets/driver_2.png",
      car: "Nissan Sunny"
    ),
    Driver(
      name: "Aya",
      averageReview: 0,
      totalReviews: 0,
      profile: "assets/driver_3.png",
      car: "Toyota corolla"
    ),
    Driver(
      name: "George",
      averageReview: 2,
      totalReviews: 0,
      profile: "assets/driver_1.png",
      car: "BMW",
    ),
  ];


  final List<Ride> rides = [
    Ride(
      from:"New Cairo",
      to: "Madinaty",
      date: "22 Feb",
      time: "14:15",
    ),
    Ride(
      from:"Zamalek",
      to: "Heliopolis",
      date: "25 Feb",
      time: "16:25",
    ),
    Ride(
      from:"Shoubra",
      to: "Nasr city",
      date: "27 Feb",
      time: "18:20",
    ),

  ];

}

class Driver {
  final String name;
  final int averageReview;
  final int totalReviews;
  final String profile;
  final String car;
  Driver({
    required this.name,
    required this.averageReview,
    required this.totalReviews,
    required this.profile,
    required this.car,
  });
}

class Ride {
  final String from;
  final String to ;
  final String date;
  final String time;
  Ride({
    required this.from,
    required this.to,
    required this.date,
    required this.time,
  });
}








