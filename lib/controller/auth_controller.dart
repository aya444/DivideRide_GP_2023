import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/models/user_model/user_model.dart';
import 'package:divide_ride/views/home.dart';
import 'package:divide_ride/views/profile_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:path/path.dart' as Path;



class AuthController extends GetxController {
  String userUid = '';
  var verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  dynamic credentials;

  var isProfileUploading = false.obs;

  bool isLoginAsDriver = false;

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

  //var isDecided = false;

  decideRoute() {
    // if (isDecided) {
    //   return;
    // }
    // isDecided = true;
    // print("called");

    ///step 1- Check user login?
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) { ///if condition is ture this means user isa already login
      /// step 2- Check whether user profile exists?
      ///isLoginAsDriver == true means navigate it to the driver module
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        ///if condition is true this means userprofile is exist else it doesn't exist
        if (value.exists) {
          Get.to(() => HomeScreen());
        } else {
          Get.to(() => ProfileSettingScreen());
        }

        ///isLoginAsDriver == true means navigate it to driver module
        // if(isLoginAsDriver){
        //
        //   if (value.exists) {
        //     print("Driver HOme Screen");
        //   } else {
        //     //Get.offAll(() => DriverProfileSetup());
        //   }


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

  var myUser= UserModel().obs;  /// all information of user is stored in myUser

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
    const kGoogleApiKey = "AIzaSyC8j9kfawLk8lGQZxOiWV-33h36nrxfs44";

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

}