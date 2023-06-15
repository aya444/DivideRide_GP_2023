import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideController extends GetxController {

  @override
  void onInit(){
    super.onInit();
    getMyDocument();
    getUsers();
    getRides();
  }


  FirebaseAuth auth = FirebaseAuth.instance;

  DocumentSnapshot? myDocument;

  getMyDocument(){
    FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid)
        .snapshots().listen((event) {
      myDocument = event;
    });
  }



  RxList allUsers = [].obs;
  RxList allRides = [].obs;

  RxList ridesICreated = [].obs;

  RxList ridesICancelled = [].obs;

  RxList ridesIJoined = [].obs;

  RxList filteredAndArrangedRides = [].obs;



  var isRideUploading = false.obs;

  var isRidesLoading = false.obs;

  var isUsersLoading = false.obs;

  ///this method is for storing Ride Info into Firebase
  createRide(Map<String,dynamic> rideData) async {

    await FirebaseFirestore.instance.collection('rides')
        .add(rideData)
        .then((value) {
      Get.snackbar('Success', 'Your ride is created successfully.',
          colorText: Colors.white,backgroundColor: AppColors.greenColor);
      isRideUploading(false);
    }).catchError((e){

    });
  }

  ///this method is getting all Users from the database and store inside allUsers list
  getUsers(){

    isUsersLoading(true);
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {

      allUsers.assignAll( event.docs ) ;
      isUsersLoading(false);

    });

  }

  ///this method is getting all Rides from the database and store inside allRides list
  getRides(){

    isRidesLoading(true);
    FirebaseFirestore.instance.collection('rides').snapshots().listen((event) {
      allRides.assignAll( event.docs );
      isRidesLoading(false);
    });

  }

  ///this method is getting all rides Created by Specific Driver from the database and store inside RidesICreated list
  getRidesICreated(){

    ridesICreated.assignAll( allRides.where((e){
      String driverId = e.get('driver');
      String status = e.get('status');

      return driverId.contains(FirebaseAuth.instance.currentUser!.uid) && status=='Upcoming';

    }).toList());
  }


  void findAndArrangeRides(Map<String, dynamic> searchRideInfo) {
    String destinationAddress = searchRideInfo['destination_address'];
    String date = searchRideInfo['date'];

    // filter rides based on destination and date
    List filteredRides = allRides.where((ride) {
      String rideDestination = ride.get('destination_address');
      String rideDate = ride.get('date');
      return rideDestination == destinationAddress && rideDate == date;
    }).toList();

    // Sort the filtered rides based on proximity to the source location
    filteredRides.sort((a, b) {
      double distanceA = calculateDistance(a.get('pickup_latlng'), searchRideInfo['pickup_latlng']);
      double distanceB = calculateDistance(b.get('pickup_latlng'), searchRideInfo['pickup_latlng']);
      return distanceA.compareTo(distanceB);
    });

    filteredAndArrangedRides.assignAll(filteredRides);
  }

  double calculateDistance(GeoPoint location, GeoPoint sourceLatLng) {
    const int earthRadius = 6371; // Radius of the Earth in kilometers

    double lat1 = location.latitude;
    double lon1 = location.longitude;

    double lat2 = sourceLatLng.latitude;
    double lon2 = sourceLatLng.longitude;

    // Calculate the differences between the latitudes and longitudes
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    // Apply the Haversine formula
    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance; // Return the calculated distance
  }

  double _toRadians(double degree) {
    return degree * pi / 180; // Convert degree to radians

  }


  getRidesICancelled(){

    ridesICancelled.assignAll( allRides.where((e){
      String driverId = e.get('driver');
      String status = e.get('status');

      return driverId.contains(FirebaseAuth.instance.currentUser!.uid) && status=='Cancelled';

    }).toList());
  }


  getRidesIJoined(){

    ridesIJoined.assignAll( allRides.where((e){

      List joinedIds = e.get('joined');

      return joinedIds.contains(FirebaseAuth.instance.currentUser!.uid);

    }).toList());

  }


}

