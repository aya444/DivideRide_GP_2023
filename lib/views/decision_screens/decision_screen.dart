import 'package:divide_ride/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets/green_intro_widget.dart';

class DecisionScreen extends StatelessWidget{
  const DecisionScreen({Key? key}) : super(key: key);

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
                    (){},
                Get.width*0.8
            ),
            const SizedBox(height: 20,),
            DecisionButton(
                'assets/customer.png',
                'Login As User',
                    (){},
                Get.width*0.8
            ),
          ],
        ),
      ),
    );
  }

}
