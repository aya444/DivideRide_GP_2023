import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/widgets/ride_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RidesSearchCards extends StatefulWidget {
  const RidesSearchCards({Key? key}) : super(key: key);

  @override
  State<RidesSearchCards> createState() => _RidesSearchCardsState();
}

class _RidesSearchCardsState extends State<RidesSearchCards> {
  RideController rideController = Get.find<RideController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => rideController.isRidesLoading.value
        ? Center(
      child: CircularProgressIndicator(),
    )
        : SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: rideController.filteredAndArrangedRides.length,
        itemBuilder: (context, index) {
          DocumentSnapshot<Object?> ride = rideController.filteredAndArrangedRides[index];
          DocumentSnapshot driver = rideController.allUsers.firstWhere( (e) => ride.get('driver') == e.id );
          Map<String, dynamic>? data = ride.data() as Map<String, dynamic>?;

          print('I am inside the ride search cards');
          if (data != null) {
            final pickupAddress = data['pickup_address'];
            final destinationAddress = data['destination_address'];

            if (pickupAddress != null && destinationAddress != null) {
              print('Ride ID: ${ride.id}');
              print('Pickup Address: $pickupAddress');
              print('Destination Address: $destinationAddress');
              // Add more fields as needed
            } else {
              print('Invalid ride data for Ride ID: ${ride.id}');
            }
          } else {
            print('No data available for Ride ID: ${ride.id}');
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: RideBox(
              ride: ride,
              driver: driver,
              showCarDetails: false,
            ),
          );
        },
      ),
    ));
  }
}