import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthController extends GetxController {
  String userUid = '';
  var verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  dynamic credentials;

  var isProfileUploading = false.obs;

  bool isLoginAsDriver = false;

// storeUserCard(String number, String expiry, String cvv, String name) async {
//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .collection('cards')
//       .add({'name': name, 'number': number, 'cvv': cvv, 'expiry': expiry});
//
//   return true;
// }
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
      //decideRoute();
    }).catchError((e) {
      print("Error while sign In $e");
    });
  }
}