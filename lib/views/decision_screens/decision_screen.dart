import 'package:divide_ride/controller/auth_controller.dart';
import 'package:divide_ride/views/login_screen.dart';
import 'package:divide_ride/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets/green_intro_widget.dart';

class DecisionScreen extends StatelessWidget{
  DecisionScreen({Key? key}) : super(key: key);

  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            greenIntroWidget(),

            const SizedBox(height: 50,),
            DecisionButton(
                'assets/driver.png',
                'Login As Driver',
                    (){
                  authController.isLoginAsDriver = true;
                  Get.to(()=> LoginScreen());
                    },
                Get.width*0.8
            ),
            const SizedBox(height: 20,),
            DecisionButton(
                'assets/customer.png',
                'Login As User',
                    (){
                      authController.isLoginAsDriver = false;
                      Get.to(()=> LoginScreen());
                    },
                Get.width*0.8
            ),
          ],
        ),
      ),
    );
  }

}
