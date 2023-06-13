import 'package:divide_ride/widgets/ride_card.dart';
import 'package:divide_ride/widgets/rides_cards.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RidesView extends StatelessWidget {
  const RidesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: const [

              SizedBox(height: 30),
              Expanded(
                  child: RidesCards()

              )
            ]
          )
      ),
    );
  }
}
