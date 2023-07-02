import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RideController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getUsers();
    getRides();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  late DocumentSnapshot myDocument;

  RxList allUsers = [].obs;
  RxList allRides = [].obs;
  RxList userSnapshots = [].obs;
  RxList filteredAndArrangedRides = [].obs;

  RxList ridesICreated = [].obs; // Rides with all dates
  RxList ridesICancelled = [].obs; // Rides that were cancelled
  RxList ridesIJoined = [].obs; // Rides user joined it
  RxList ridesIEnded = [].obs; // Rides that were ended

  RxList upcomingRidesForDriver = [].obs; // Rides with upcoming date for driver
  RxList upcomingRidesForUser = [].obs; // Rides with upcoming date for user

  RxList driverHistory = [].obs; // Rides that ended or cancelled for driver
  RxList userHistory = [].obs; // Rides that ended or cancelled for user

  RxList driverCurrentRide = [].obs; // contains the driver current ride
  RxList userCurrentRide = [].obs; // contains the user current ride

  RxList myRequests = [].obs;
  RxList pendingRequests = [].obs;
  RxList acceptedRequests = [].obs;
  RxList rejectedRequests = [].obs;

  var isRideUploading = false.obs;
  var isRidesLoading = false.obs;
  var isUsersLoading = false.obs;
  var isRequestLoading = false.obs;

  // Main Functionalities
  ///this method is for storing Ride Info into Firebase
  createRide(Map<String, dynamic> rideData) async {
    await FirebaseFirestore.instance
        .collection('rides')
        .add(rideData)
        .then((value) {
      Get.snackbar('Success', 'Your ride is created successfully.',
          colorText: Colors.white, backgroundColor: Color(0xFF00832C));
      isRideUploading(false);
      updateUpcomingDriverRide();
      updateUpcomingUserRide();
    }).catchError((e) {});
  }

  /// this method allows the driver to cancel his ride
  cancelRide(String rideId) async {
    try {
      // Get a reference to the ride document in Firestore to update to it
      DocumentReference rideRef =
          FirebaseFirestore.instance.collection('rides').doc(rideId);

      // Add the userId to the pending array in the ride document
      await rideRef.update({
        'status': "Cancelled",
      }).then((value) {
        Get.snackbar('Success', 'Your ride was canceled',
            colorText: Colors.white, backgroundColor: Colors.red);
        isRideUploading(false);
        updateHistoryDriverRide();
        updateHistoryUserRide();
      });
    } catch (e) {
      print('Failed to cancel ride: $e');
    }
  }

  /// this method allows the driver to start his ride
  startRide(String rideId) async {
    try {
      // Get a reference to the ride document in Firestore to update to it
      DocumentReference rideRef =
          FirebaseFirestore.instance.collection('rides').doc(rideId);

      // Add the userId to the pending array in the ride document
      await rideRef.update({
        'status': "Started",
      }).then((value) {
        Get.snackbar('Success', 'Have a safe journey!',
            colorText: Colors.white, backgroundColor: Color(0xFF00832C));
        isRideUploading(false);
        updateOngoingDriverRide();
        updateOngoingUserRide();
      });
    } catch (e) {
      print('Failed to start ride: $e');
    }
  }

  /// this method allows the driver to end his ride
  endRide(String rideId) async {
    try {
      // Get a reference to the ride document in Firestore to update to it
      DocumentReference rideRef =
          FirebaseFirestore.instance.collection('rides').doc(rideId);

      // Add the userId to the pending array in the ride document
      await rideRef.update({
        'status': "Ended",
      }).then((value) {
        Get.snackbar('Success', 'You have ended the ride!',
            colorText: Colors.white, backgroundColor: Color(0xFF00832C));
        isRideUploading(false);
        updateHistoryUserRide();
        updateHistoryDriverRide();
      });
    } catch (e) {
      print('Failed to end ride: $e');
    }
  }

  /// this method allows the user to send request to driver to join him on the ride
  requestToJoinRide(DocumentSnapshot ride, String userId) async {
    try {
      String driverId = ride.get('driver');

      // Get a reference to the ride document in Firestore to update to it
      await FirebaseFirestore.instance.collection('rides').doc(ride.id).set({
        'pending': FieldValue.arrayUnion([userId]),
      }, SetOptions(merge: true)).then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(driverId)
            .collection('requests')
            .add({'user_id': userId, 'ride_id': ride.id, 'status': 'Pending'});
      });

      Get.snackbar('Success', 'Your request was sent successfully.',
          colorText: Colors.white, backgroundColor: AppColors.greenColor);
      isRequestLoading(false);
    } catch (e) {
      print('Failed to send request to join ride: $e');
    }
  }

  /// this method allows the driver to accept the request made by the user to join his ride
  acceptRequest(DocumentSnapshot ride, DocumentSnapshot? request) async {
    String driverId = ride.get('driver');
    String userId = request!.get('user_id');
    String requestId = request!.id;
    int seat = 0;
    String maxSeats = "";

    List seatInformation = [];
    try {
      seatInformation = ride.get('max_seats').toString().split(' ');
      seat = int.parse(seatInformation[0]) - 1;
      maxSeats = seat == 1 ? '$seat seat' : '$seat seats';
    } catch (e) {
      print('exception');
      seatInformation = [];
    }
    pendingRequests.remove(userId);
    print('length of pending requests = ${pendingRequests.length}');

    await FirebaseFirestore.instance.collection('rides').doc(ride.id).set({
      'pending': FieldValue.arrayRemove([userId]),
      'joined': FieldValue.arrayUnion([userId]),
      'max_seats': maxSeats,
    }, SetOptions(merge: true)).then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(driverId)
          .collection('requests')
          .doc(requestId)
          .set({'status': 'Accepted'}, SetOptions(merge: true)).then((value) {
        Get.snackbar('Success', 'Your request was accepted successfully.',
            colorText: Colors.white, backgroundColor: AppColors.greenColor);

        isRequestLoading(false);
        updatePendingRequests();
      });
    });
  }

  /// this method allows the driver to reject the request made by the user to join his ride
  rejectRequest(DocumentSnapshot ride, DocumentSnapshot? request) async {
    String driverId = ride.get('driver');
    String userId = request!.get('user_id');
    String requestId = request!.id;

    await FirebaseFirestore.instance.collection('rides').doc(ride.id).set({
      'pending': FieldValue.arrayRemove([userId]),
      'rejected': FieldValue.arrayUnion([userId]),
    }, SetOptions(merge: true)).then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(driverId)
          .collection('requests')
          .doc(requestId)
          .set({'status': 'Rejected'}, SetOptions(merge: true)).then((value) {
        Get.snackbar('Success', 'Your request was rejected successfully.',
            colorText: Colors.white, backgroundColor: AppColors.greenColor);

        isRequestLoading(false);
        updatePendingRequests();
      });
    });
  }

  /// this method is to add userId tho pickup array this shows that the users has rode the car with the driver
  pickedUp(String rideId, String userId) async {
    try {
      DocumentReference rideRef =
          FirebaseFirestore.instance.collection('rides').doc(rideId);
      rideRef.update({
        'picked_up': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      print('Failed to add userId to picked_up array: $e');
    }
  }

  /// this method find all rides with the sam destination and date given by user then arrange them from the nearest in distance to furthest
  void findAndArrangeRides(Map<String, dynamic> searchRideInfo) {
    String destinationAddress = searchRideInfo['destination_address'];
    String date = searchRideInfo['date'];
    DateTime currentDateTime = DateTime.now();

    // filter rides based on destination and date
    List filteredRides = allRides.where((ride) {
      String rideDestination = ride.get('destination_address');
      String rideDate = ride.get('date');
      String status = ride['status'];
      // String rideStatus = ride.get('status');
      String startTime = ride.get('start_time');

      // Parse ride's date and start time
      DateTime rideDateTime =
          DateFormat('dd-MM-yyyy hh:mm a').parse('$rideDate $startTime');
      return rideDestination == destinationAddress &&
          rideDate == date &&
          rideDateTime.isAfter(currentDateTime) &&
          status != 'Cancelled' &&
          status != 'Ended';
    }).toList();

    // Sort the filtered rides based on proximity to the source location
    filteredRides.sort((a, b) {
      double distanceA = calculateDistance(
          a.get('pickup_latlng'), searchRideInfo['pickup_latlng']);
      double distanceB = calculateDistance(
          b.get('pickup_latlng'), searchRideInfo['pickup_latlng']);
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

  // Updaters
  updateOngoingDriverRide() {
    getOngoingRideForDriver();
  }

  updateOngoingUserRide() {
    getOngoingRideForUser();
  }

  updateUpcomingUserRide() {
    getUpcomingRidesForUser();
  }

  updateUpcomingDriverRide() {
    getUpcomingRidesForDriver();
  }

  updateHistoryUserRide() {
    getRideHistoryForUser();
  }

  updateHistoryDriverRide() {
    getRideHistoryForDriver();
  }

  updatePendingRequests() {
    getPendingRequests();
  }

  // Getters
  getMyDocument() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .listen((event) {
      myDocument = event;
    });
  }

  ///this method is getting all Users from the database and store inside allUsers list
  getUsers() {
    isUsersLoading(true);
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      allUsers.assignAll(event.docs);
      isUsersLoading(false);
    });
  }

  ///this method is getting all Rides from the database and store inside allRides list
  getRides() {
    isRidesLoading(true);
    FirebaseFirestore.instance.collection('rides').snapshots().listen((event) {
      allRides.assignAll(event.docs);
      isRidesLoading(false);
    });
  }

  ///this method is getting all rides Created by Specific Driver from the database and store inside RidesICreated list
  getRidesICreated() {
    ridesICreated.assignAll(allRides.where((e) {
      String driverId = e.get('driver');
      String status = e.get('status');

      return driverId.contains(FirebaseAuth.instance.currentUser!.uid) &&
          status == 'Upcoming';
    }).toList());
  }

  ///this method gets length of joined array in ride entity
  getJoinedArrayLength(String rideId) async {
    final rideSnapshot =
        await FirebaseFirestore.instance.collection('rides').doc(rideId).get();

    if (rideSnapshot.exists && rideSnapshot.data() != null) {
      final joinedArray = rideSnapshot.data()!['joined'] as List<dynamic>;
      return joinedArray.length;
    }

    return 0; // Default value if the 'joined' array doesn't exist or ride doesn't exist
  }

  getJoinedArray(String rideId) async {
    final rideSnapshot =
        await FirebaseFirestore.instance.collection('rides').doc(rideId).get();

    if (rideSnapshot.exists && rideSnapshot.data() != null) {
      final joinedArray = rideSnapshot.data()!['joined'] as List<dynamic>;
      return joinedArray;
    }
  }

  /// this method gets the current ride for the driver
  getOngoingRideForDriver() async {
    DateTime currentDate = DateTime.now();
    DateTime previous30Minutes = currentDate.subtract(Duration(minutes: 30));
    DateTime next3Hours = currentDate.add(Duration(hours: 3));

    List tempArray = ridesICreated.where((ride) {
      String driverId = ride['driver'];
      String status = ride['status'];
      DateTime rideDate = DateFormat('dd-MM-yyyy').parse(ride['date']);
      DateTime startTime = DateFormat('hh:mm a').parse(ride['start_time']);

      // Combine date and time for comparison
      DateTime rideDateTime = DateTime(
        rideDate.year,
        rideDate.month,
        rideDate.day,
        startTime.hour,
        startTime.minute,
      );

      // Filter rides that occur within 30 minutes before and 3 hours after the current date and time
      return driverId.contains(FirebaseAuth.instance.currentUser!.uid) &&
          rideDateTime.isAfter(previous30Minutes) &&
          rideDateTime.isBefore(next3Hours) &&
          status != 'Cancelled' &&
          status != 'Ended' &&
          status != 'Started';
    }).toList();

    // Assign filtered rides to currentRide array
    driverCurrentRide.assignAll(tempArray);
  }

  /// this method get all rides with still active date and arrange them from the nearest date to the furthest for driver
  getUpcomingRidesForDriver() {
    DateTime currentDate = DateTime.now();
    DateTime next3Hours = currentDate.add(Duration(
        hours: 3, minutes: 1)); // Get the next 5 hours from the current date

    List tempArray = ridesICreated.where((ride) {
      String driverId = ride['driver'];
      String status = ride['status'];
      DateTime rideDate = DateFormat('dd-MM-yyyy').parse(ride['date']);
      DateTime startTime = DateFormat('hh:mm a').parse(ride['start_time']);

      // Combine date and time for comparison
      DateTime rideDateTime = DateTime(
        rideDate.year,
        rideDate.month,
        rideDate.day,
        startTime.hour,
        startTime.minute,
      );

      // Filter rides that occur after the next 5 hours from the current date
      return driverId.contains(FirebaseAuth.instance.currentUser!.uid) &&
          rideDateTime.isAfter(next3Hours) &&
          status != 'Cancelled' &&
          status != 'Ended';
    }).toList();

    // Sort rides by nearest date and time
    tempArray.sort((a, b) {
      DateTime rideDateTimeA = DateFormat('dd-MM-yyyy hh:mm a')
          .parse(a['date'] + ' ' + a['start_time']);
      DateTime rideDateTimeB = DateFormat('dd-MM-yyyy hh:mm a')
          .parse(b['date'] + ' ' + b['start_time']);
      return rideDateTimeA.compareTo(rideDateTimeB);
    });

    // Assign sorted rides to activeRides array
    upcomingRidesForDriver.assignAll(tempArray);
  }

  /// this method get all rides that was ended or cancelled by driver and arrange them from the nearest date to the furthest for driver
  getRideHistoryForDriver() {
    List tempArray = ridesIEnded.where((ride) {
      String driverId = ride['driver'];

      // Filter rides that have already occurred
      return driverId.contains(FirebaseAuth.instance.currentUser!.uid);
    }).toList();

    // Concatenate the canceled rides to the temporary array
    tempArray.addAll(ridesICancelled);

    // Sort rides by nearest date and time
    tempArray.sort((a, b) {
      DateTime rideDateTimeA = DateFormat('dd-MM-yyyy hh:mm a')
          .parse(a['date'] + ' ' + a['start_time']);
      DateTime rideDateTimeB = DateFormat('dd-MM-yyyy hh:mm a')
          .parse(b['date'] + ' ' + b['start_time']);
      return rideDateTimeA.compareTo(rideDateTimeB);
    });

    // Assign sorted rides to endedRides array
    driverHistory.assignAll(tempArray);
  }

  /// this method gets the current ride for the user
  getOngoingRideForUser() {
    //TODO change to accepted array
    List tempArray = ridesIJoined.where((ride) {
      List<dynamic> joinedUsers = ride['joined'];
      String status = ride['status'];

      return joinedUsers.contains(FirebaseAuth.instance.currentUser!.uid) &&
          status == 'Started';
    }).toList();

    // Assign filtered rides to currentRide array
    userCurrentRide.assignAll(tempArray);
  }

  /// this method get all rides with still active date and arrange them from the nearest date to the furthest for user
  getUpcomingRidesForUser() {
    DateTime currentDate = DateTime.now();
    DateTime next3Hours = currentDate.add(Duration(
        hours: 3, minutes: 1)); // Get the next 5 hours from the current date

    List tempArray = ridesIJoined.where((ride) {
      List<dynamic> joinedUsers = ride['joined'];
      String status = ride['status'];
      DateTime rideDate = DateFormat('dd-MM-yyyy').parse(ride['date']);
      DateTime startTime = DateFormat('hh:mm a').parse(ride['start_time']);

      // Combine date and time for comparison
      DateTime rideDateTime = DateTime(
        rideDate.year,
        rideDate.month,
        rideDate.day,
        startTime.hour,
        startTime.minute,
      );

      // Filter rides that occur within the next 4 hours and have the user in the joined list
      return joinedUsers.contains(FirebaseAuth.instance.currentUser!.uid) &&
          rideDateTime.isAfter(next3Hours) &&
          status == 'Upcoming';
    }).toList();

    // Sort rides by nearest date and time
    tempArray.sort((a, b) {
      DateTime rideDateTimeA = DateFormat('dd-MM-yyyy hh:mm a')
          .parse(a['date'] + ' ' + a['start_time']);
      DateTime rideDateTimeB = DateFormat('dd-MM-yyyy hh:mm a')
          .parse(b['date'] + ' ' + b['start_time']);
      return rideDateTimeA.compareTo(rideDateTimeB);
    });

    // Assign filtered rides to upcomingRides array
    upcomingRidesForUser.assignAll(tempArray);
  }

  /// this method get all rides that was ended or cancelled by driver and arrange them from the nearest date to the furthest for user
  getRideHistoryForUser() {
    DateTime currentDate = DateTime.now();

    List tempArray = ridesIJoined.where((ride) {
      List<dynamic> joinedUsers = ride['joined'];
      String status = ride['status'];
      DateTime rideDate = DateFormat('dd-MM-yyyy').parse(ride['date']);
      DateTime startTime = DateFormat('hh:mm a').parse(ride['start_time']);

      // Combine date and time for comparison
      DateTime rideDateTime = DateTime(
        rideDate.year,
        rideDate.month,
        rideDate.day,
        startTime.hour,
        startTime.minute,
      );

      // Filter rides that have already occurred
      return joinedUsers.contains(FirebaseAuth.instance.currentUser!.uid) &&
          (status == 'Ended' ||
              status == 'Cancelled' ||
              rideDateTime.isBefore(currentDate));
    }).toList();

    // Sort rides by nearest date and time
    tempArray.sort((a, b) {
      DateTime rideDateTimeA = DateFormat('dd-MM-yyyy hh:mm a')
          .parse(a['date'] + ' ' + a['start_time']);
      DateTime rideDateTimeB = DateFormat('dd-MM-yyyy hh:mm a')
          .parse(b['date'] + ' ' + b['start_time']);
      return rideDateTimeA.compareTo(rideDateTimeB);
    });

    // Assign sorted rides to endedRides array
    userHistory.assignAll(tempArray);
  }

  /// this method gets all cancelled rides by driver
  getRidesICancelled() {
    ridesICancelled.assignAll(allRides.where((e) {
      String driverId = e.get('driver');
      String status = e.get('status');

      return driverId.contains(FirebaseAuth.instance.currentUser!.uid) &&
          status == 'Cancelled';
    }).toList());
  }

  /// this method gets all rides a user joined
  getRidesIJoined() {
    ridesIJoined.assignAll(allRides.where((e) {
      List joinedIds = e.get('joined');

      return joinedIds.contains(FirebaseAuth.instance.currentUser!.uid);
    }).toList());
  }

  /// this method gets all rides that a driver has ended after making it
  getRidesIEnded() {
    ridesIEnded.assignAll(allRides.where((e) {
      String driverId = e.get('driver');
      String status = e.get('status');

      return driverId.contains(FirebaseAuth.instance.currentUser!.uid) &&
          status == 'Ended';
    }).toList());
  }

  /// this method to get all requests sent to driver by the users to join his rides
  getMyRequests() {
    isRequestLoading(true);
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('requests')
        .snapshots()
        .listen((event) {
      myRequests.value = event.docs;
      isRequestLoading(false);
    });
  }

  /// this method gets all users who joined a specific ride
  getAcceptedUserForRide(String rideId) async {
    String currentDriverId = FirebaseAuth.instance.currentUser!.uid;
    List<String> userIds = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentDriverId)
        .collection('requests')
        .where('ride_id', isEqualTo: rideId)
        .where('status', isEqualTo: 'Accepted')
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot
        .docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>) {
      if (document.data() != null) {
        userIds.add(document.data()!['user_id']);
      }
    }

    List<DocumentSnapshot<Map<String, dynamic>>> userSnapshots =
        []; // Create a local list

    for (String userId in userIds) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
      if (userSnapshot.exists) {
        userSnapshots.add(userSnapshot);
      }
    }

    // Update the userSnapshots in the RideController instance
    this.userSnapshots.assignAll(userSnapshots);
  }

  /// this method gets all pending requests that the driver is yet to accept or reject
  getPendingRequests() {
    pendingRequests.assignAll(myRequests.where((e) {
      String status = e.get('status');

      return status == 'Pending';
    }).toList());
  }

  /// this method gets all requests accepted by the driver
  getAcceptedRequests() {
    acceptedRequests.assignAll(myRequests.where((e) {
      String status = e.get('status');

      return status == 'Accepted';
    }).toList());
  }

  /// this method gets all requests rejected by the driver
  getRejectedRequests() {
    rejectedRequests.assignAll(myRequests.where((e) {
      String status = e.get('status');

      return status == 'Rejected';
    }).toList());
  }
}
