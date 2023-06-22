import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/views/driver/accepted_requests_view.dart';
import 'package:divide_ride/views/driver/pending_requests_view.dart';
import 'package:divide_ride/views/ride_requests.dart';
import 'package:divide_ride/views/tabs/accepted_tab.dart';
import 'package:divide_ride/views/tabs/pending_tab.dart';
import 'package:divide_ride/widgets/upcoming_rides_for_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RideController extends GetxController {

  @override
  void onInit(){
    super.onInit();
    //getMyDocument();
    getUsers();
    getRides();
    //getMyRequests();
  }


  FirebaseAuth auth = FirebaseAuth.instance;

  late DocumentSnapshot myDocument;

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

  RxList myRequests = [].obs;

  RxList pendingRequests = [].obs;

  RxList acceptedRequests = [].obs;

  RxList rejectedRequests = [].obs;


  var isRideUploading = false.obs;

  var isRidesLoading = false.obs;

  var isUsersLoading = false.obs;

  var isRequestLoading = false.obs;


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

  /// Function to request to join a specific ride
  // requestToJoinRide(String rideId, String userId) async {
  //   try {
  //     // Get a reference to the ride document in Firestore to update to it
  //     DocumentReference rideRef = FirebaseFirestore.instance.collection('rides').doc(rideId);
  //
  //     // Add the userId to the pending array in the ride document
  //     await rideRef.update({
  //       'pending': FieldValue.arrayUnion([userId]),
  //     }).then((value) {
  //       Get.snackbar('Success', 'Your request was sent successfully.',
  //           colorText: Colors.white,backgroundColor: AppColors.greenColor);
  //       isRideUploading(false);
  //     });
  //   } catch (e) {
  //     print('Failed to send request to join ride: $e');
  //   }
  // }


  requestToJoinRide(DocumentSnapshot ride, String userId) async {
    try {


      String driverId = ride.get('driver');

      // Get a reference to the ride document in Firestore to update to it
      await FirebaseFirestore.instance.collection('rides').doc(ride.id).set({
        'pending': FieldValue.arrayUnion([userId]),

      },SetOptions(merge: true)).then((value) {

        FirebaseFirestore.instance
            .collection('users')
            .doc(driverId)
            .collection('requests')
            .add({'user_id': userId, 'ride_id': ride.id, 'status': 'Pending'});

      });

      Get.snackbar('Success', 'Your request was sent successfully.',
          colorText: Colors.white,backgroundColor: AppColors.greenColor);
      isRequestLoading(false);

    } catch (e) {
      print('Failed to send request to join ride: $e');
    }
  }


  // getPendingRequests(){
  //
  //   pendingRequests.assignAll( ridesICreated.where((e){
  //
  //     List pendingIds = e.get('pending');
  //
  //     //return pendingIds.contains(FirebaseAuth.instance.currentUser!.uid);
  //
  //     return pendingIds;
  //   }));
  //
  // }

  getMyRequests(){

    isRequestLoading(true);
    FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('requests')
        .snapshots().listen((event) {
        myRequests.value = event.docs;
        isRequestLoading(false);
    });

 }

 getPendingRequests(){

   pendingRequests.assignAll( myRequests.where((e){

     String status = e.get('status');

     return status=='Pending';


   }).toList());

 }

  getAcceptedRequests(){

    acceptedRequests.assignAll( myRequests.where((e){

      String status = e.get('status');

      return status=='Accepted';

    }).toList());

  }


  getRejectedRequests(){

    rejectedRequests.assignAll( myRequests.where((e){

      String status = e.get('status');

      return status=='Rejected';

    }).toList());

  }



 acceptRequest(DocumentSnapshot ride , DocumentSnapshot? request) async{


   String driverId = ride.get('driver');
   String userId = request!.get('user_id');
   String requestId = request!.id;
   int seat = 0;
   String maxSeats = "";

   List seatInformation = [];
   try{

     seatInformation = ride.get('max_seats').toString().split(' ');
     seat = int.parse(seatInformation[0]) - 1;
     maxSeats = seat == 1 ? '$seat seat' : '$seat seats';

   }catch(e){
     print('exception');
     seatInformation = [];
   }


   await FirebaseFirestore.instance.collection('rides').doc(ride.id).set({
     'pending': FieldValue.arrayRemove([userId]),
     'joined': FieldValue.arrayUnion([userId]),
     'max_seats': maxSeats,

   },SetOptions(merge: true)).then((value) async {

     await FirebaseFirestore.instance
         .collection('users')
         .doc(driverId)
         .collection('requests')
         .doc(requestId).set({

          'status': 'Accepted'

     },SetOptions(merge: true)).then((value) {


       Get.snackbar('Success', 'Your request was accepted successfully.',
           colorText: Colors.white,backgroundColor: AppColors.greenColor);


       isRequestLoading(false);



     });

   });

 }

  rejectRequest(DocumentSnapshot ride , DocumentSnapshot? request) async{


    String driverId = ride.get('driver');
    String userId = request!.get('user_id');
    String requestId = request!.id;

    await FirebaseFirestore.instance.collection('rides').doc(ride.id).set({
      'pending': FieldValue.arrayRemove([userId]),
      'rejected': FieldValue.arrayUnion([userId]),

    },SetOptions(merge: true)).then((value) {

      FirebaseFirestore.instance
          .collection('users')
          .doc(driverId)
          .collection('requests')
          .doc(requestId).set({

        'status': 'Rejected'

      },SetOptions(merge: true)).then((value) {

        Get.snackbar('Success', 'Your request was rejected successfully.',
            colorText: Colors.white,backgroundColor: AppColors.greenColor);

        isRequestLoading(false);

      });

    });

  }











}

