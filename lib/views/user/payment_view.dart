import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/shared%20preferences/shared_pref.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/utils/app_constants.dart';
import 'package:divide_ride/widgets/green_button.dart';
import 'package:divide_ride/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/ride_controller.dart';
import '../../widgets/ride_box.dart';
import '../ride_details_view.dart';

class PaymentView extends StatefulWidget {
  DocumentSnapshot ride;
  DocumentSnapshot driver;
  PaymentView(this.ride, this.driver);

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  RideController rideController = Get.find<RideController>();

  bool isDriver = false;

  int selectedRadio = 0;

  String dropdownValue = '**** **** **** 8789';
  List<String> list = <String>[
    '**** **** **** 8789',
    '**** **** **** 8921',
    '**** **** **** 1233',
    '**** **** **** 4352'
  ];

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  void initState() {
    super.initState();

    isDriver = CacheHelper.getData(key: AppConstants.decisionKey) ?? false;

    print(isDriver.toString());
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.greenColor,
          title: Text('Payment'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(children: [
                RideBox(
                    ride: widget.ride,
                    driver: widget.driver,
                    showCarDetails: true),
                //SizedBox(height: 20,),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Row(
                  children: [
                    myText(
                      text: 'Payment Method',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        buildPaymentCardWidget(),
                      ],
                    ),
                    Spacer(),
                    Radio(
                      value: 0,
                      groupValue: selectedRadio,
                      onChanged: (int? val) {
                        setSelectedRadio(val!);
                      },
                    ),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),

                Row(
                  children: [
                    myText(
                      text: 'Other option',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 48,
                      height: 34,
                      child: Image.asset(
                        'assets/vodafone_2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    myText(
                      text: 'Vodafone cash',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Radio(
                      value: 1,
                      groupValue: selectedRadio,
                      onChanged: (int? value) {
                        setState(() {
                          setSelectedRadio(value!);
                        });
                      },
                      activeColor: AppColors.blue,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 48,
                      height: 34,
                      child: Image.asset(
                        'assets/cash.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    myText(
                      text: 'Cash',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Radio(
                      value: 2,
                      groupValue: selectedRadio,
                      onChanged: (int? value) {
                        setState(() {
                          setSelectedRadio(value!);
                        });
                      },
                      activeColor: AppColors.blue,
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    myText(
                      text: 'Ride Price',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    myText(
                      text: '${widget.ride!.get('price_per_seat')} EGP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                Divider(),
                Row(
                  children: [
                    myText(
                      text: 'Service Price',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    myText(
                      text: '3 EGP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                Divider(),
                Row(
                  children: [
                    myText(
                      text: 'Total Price',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    myText(
                      text:
                          '${int.parse(widget.ride!.get('price_per_seat')) + 3} EGP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                greenButton('Pay', () {}),
              ])),
        ));
  }

  buildPaymentCardWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/visa.png',
            width: 40,
          ),
          SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: textWidget(text: value),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
