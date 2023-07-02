import 'package:divide_ride/views/driver/driver_home.dart';
import 'package:divide_ride/widgets/green_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/green_intro_widget.dart';

class VerificaitonPendingScreen extends StatefulWidget {
  const VerificaitonPendingScreen({Key? key}) : super(key: key);

  @override
  State<VerificaitonPendingScreen> createState() =>
      _VerificaitonPendingScreenState();
}

class _VerificaitonPendingScreenState extends State<VerificaitonPendingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          greenIntroWidgetWithoutLogos(
              title: 'Verification!', subtitle: 'process status'),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Verification Pending',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),

              Text(
                'Your document is still pending for verification. Once it’s all verified you start getting rides. please sit tight',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff7D7D7D)),
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: 30,
              ),

              //Get.offAll is to remove all pages before
              greenCustomButton('Get started', () {
                Get.off(() => DriverHomeScreen());
              }),
            ],
          )),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
