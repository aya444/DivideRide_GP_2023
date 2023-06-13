import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/models/driver_model/driver_model.dart';
import 'package:divide_ride/models/user_model/user_model.dart';
import 'package:divide_ride/shared%20preferences/shared_pref.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/utils/app_constants.dart';
import 'package:divide_ride/views/driver/driver_home.dart';
import 'package:divide_ride/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:path/path.dart' as Path;




class RideController extends GetxController {

  @override
  void onInit(){
    super.onInit();
    getMyDocument();
    getUsers();
    getRides();
    getRidesICreated();
  }


  FirebaseAuth auth = FirebaseAuth.instance;

  DocumentSnapshot? myDocument;

  getMyDocument(){
    FirebaseFirestore.instance.collection('users').doc(auth.currentUser!.uid)
        .snapshots().listen((event) {
      myDocument = event;
    });
  }


  var allUsers = <DocumentSnapshot>[].obs;
  var allRides = <DocumentSnapshot>[].obs;

  var ridesICreated = <DocumentSnapshot>[].obs;
  var ridesIJoined = <DocumentSnapshot>[].obs;

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

    isRidesLoading(true);
    ridesICreated.value =  allRides.where((e){
      String driverId = e.get('driver');

      return driverId.contains(FirebaseAuth.instance.currentUser!.uid);

    }).toList();

  }

  // getRidesIJoined(){
  //
  //   isRidesLoading(true);
  //   ridesIJoined.value =  allRides.where((e){
  //     String? driverId = e.get('driver');
  //
  //     return driverId!.contains(FirebaseAuth.instance.currentUser!.uid);
  //
  //   }).toList();
  //
  // }








}

