import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Padding(
        padding: const EdgeInsets.all(100.0),
        child: Center(
          child: Column(
            children:
            [
              Text(
              'Your are LogedIn',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
              minWidth: Get.width,
              height: 50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              color: AppColors.greenColor,
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
                Get.to(() => LoginScreen());
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
            ]
          ),
        ),
      ),
    );
  }

}
