import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/models/driver_model/driver_model.dart';
import 'package:divide_ride/models/user_model/user_model.dart';
import 'package:divide_ride/shared%20preferences/shared_pref.dart';
import 'package:divide_ride/utils/app_constants.dart';
import 'package:divide_ride/views/driver/driver_home.dart';
import 'package:divide_ride/views/user/home.dart';
import 'package:divide_ride/views/user/profile_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:path/path.dart' as Path;

import '../views/driver/car_registration/car_registration_template.dart';
import '../views/driver/profile_setup.dart';



class AuthController extends GetxController {
  String userUid = '';
  var verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  dynamic credentials;

  var isProfileUploading = false.obs;

  //bool isLoginAsDriver = true;

  var myUser= UserModel().obs;   /// all information of user is stored in myUser
  var myDriver= DriverModel().obs;  /// all information of driver is stored in myDriver


  storeUserCard(String number, String expiry, String cvv, String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cards')
        .add({'name': name, 'number': number, 'cvv': cvv, 'expiry': expiry});

    return true;
  }

  RxList userCards = [].obs;

  getUserCards() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('cards')
        .snapshots().listen((event) {
      userCards.value = event.docs;
    });
  }


//   CountdownController countdownController = CountdownController();
//   TextEditingController otpEditingController = TextEditingController();
//   var messageOtpCode = ''.obs;
//
//   @override
//   void onInit() async {
//     super.onInit();
//     print(await SmsAutoFill().getAppSignature);
//     // Listen for SMS OTP
//     await SmsAutoFill().listenForCode();
//   }
//
//   @override
//   void onReady() {
//     super.onReady();
//     countdownController.start();
//   }
//
//   @override
//   void onClose() {
//     super.onClose();
//     otpEditingController.dispose();
//     SmsAutoFill().unregisterListener();
//   }


  phoneAuth(String phone) async {
    try {
      credentials = null;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('Completed');
          credentials = credential;
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        forceResendingToken: resendTokenId,
        verificationFailed: (FirebaseAuthException e) {
          log('Failed');
          if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          log('Code sent');
          verId = verificationId;
          resendTokenId = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log("Error occured $e");
    }
  }

  verifyOtp(String otpNumber) async {
    log("Called");
    PhoneAuthCredential credential =
    PhoneAuthProvider.credential(verificationId: verId, smsCode: otpNumber);

    log("LogedIn");

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      decideRoute();
    }).catchError((e) {
      print("Error while sign In $e");
    });
  }

  // var isDecided = false;
  var isDecided = false;

  decideRoute() {
    // if (isDecided) {
    //   return;
    // }
    isDecided = true;
    print("called");

    ///step 1- Check user login?
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      /// step 2- Check whether user profile exists?
      ///isLoginAsDriver == true means navigate it to the driver module
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) async{

               ///isLoginAsDriver == true means navigate it to driver module
              bool isLoginAsDriver = await CacheHelper.getData(key: AppConstants.decisionKey) ?? false ;

              if (isLoginAsDriver) {
                if (value.exists) {
                  print("Driver HOme Screen");
                  Get.offAll(() => DriverHomeScreen());
                } else {
                  Get.offAll(() => DriverProfileSetup());
                }
              } else {
                if (value.exists) {
                  Get.offAll(() => HomeScreen());
                } else {
                  Get.offAll(() => ProfileSettingScreen());
                }
              }

      }).catchError((e) {
        print("Error while decideRoute is $e");
      });
    }
  }



  uploadImage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance
        .ref()
        .child('users/$fileName'); // Modify this path/string as your need
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
          (value) {
        imageUrl = value;
        print("Download URL: $value");
      },
    );

    return imageUrl;
  }

  storeUserInfo(
      File? selectedImage,
      String name,
      String home,
      String business,
      String shop, {
        String url = '',
        LatLng? homeLatLng,
        LatLng? businessLatLng,
        LatLng? shoppingLatLng,
      }) async {
    String url_new = url;
    if (selectedImage != null) {
      url_new = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url_new,
      'name': name,
      'home_address': home,
      'business_address': business,
      'shopping_address': shop,
      'home_latlng': GeoPoint(homeLatLng!.latitude, homeLatLng.longitude),
      'business_latlng':
      GeoPoint(businessLatLng!.latitude, businessLatLng.longitude),
      'shopping_latlng':
      GeoPoint(shoppingLatLng!.latitude, shoppingLatLng.longitude),
    },SetOptions(merge: true)).then((value) {
      isProfileUploading(false);

      Get.to(() => HomeScreen());
    });
  }



  //this function shows user information on their profile, snapshots to capture any changes on real time
  //it calls UserModel instance to assert the value of the current user to this instance
  getUserInfo() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {
      myUser.value = UserModel.fromJson(event.data()!);
    });
  }

  Future<Prediction?> showGoogleAutoComplete(BuildContext context) async {
    const kGoogleApiKey = "AIzaSyCHWB38zEhd2ncTPPCPHFksdmT2FINaF0U";

    Prediction? p = await PlacesAutocomplete.show(
      //Prediction is nullable in case a non existed place is searched for
      offset: 0,
      radius: 1000,
      strictbounds: false,
      region: "eg",
      language: "en",
      context: context,
      mode: Mode.overlay,
      apiKey: kGoogleApiKey,
      components: [
        new Component(Component.country, "eg")
      ],
      //restrict the search to egypt
      types: [
        // "street_number",
        // "street_address",
        // "route",
        // "locality",
        // "sublocality"
      ],
      hint: "Search City",
    );
    return p;
  }

  Future<LatLng> buildLatLngFromAddress(String place) async {
    List<geoCoding.Location> locations = await geoCoding.locationFromAddress(place);
    return LatLng(locations.first.latitude, locations.first.longitude);
  }

 //NEW
  storeDriverProfile(
      File? selectedImage,
      String name,
      String email, {
        String url = '',

      }) async {
    String url_new = url;
    if (selectedImage != null) {
      url_new = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url_new,
      'name': name,
      'email': email,
      'isDriver': true
    },SetOptions(merge: true)).then((value) {
      isProfileUploading(false);

      Get.off(()=> CarRegistrationTemplate());
    });
  }

  storeDriverInfo(
      File? selectedImage,
      String name,
      String email, {
        String url = '',

      }) async {
    String url_new = url;
    if (selectedImage != null) {
      url_new = await uploadImage(selectedImage);
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url_new,
      'name': name,
      'email': email,
    },SetOptions(merge: true)).then((value) {
      isProfileUploading(false);

      Get.off(()=> DriverHomeScreen());
    });
  }


  Future<bool> uploadCarEntry(Map<String,dynamic> carData)async{
    bool isUploaded = false;
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set(carData,SetOptions(merge: true));

    isUploaded = true;

    return isUploaded;
  }


  //this function shows user information on their profile, snapshots to capture any changes on real time
  //it calls UserModel instance to assert the value of the current user to this instance
  getDriverInfo() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {
      myDriver.value = DriverModel.fromJson(event.data()!);
    });
  }
}

