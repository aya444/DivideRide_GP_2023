import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/widgets/rides_cards.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../models/driver_model/driver_model.dart';
import '../utils/app_colors.dart';
import '../views/ride_details_before_database.dart';

class RideBox extends StatelessWidget {

  final DocumentSnapshot ride;
  final DocumentSnapshot driver;
  final bool showCarDetails;
  final bool showOptions;
  final bool shouldNavigate;

  const RideBox({super.key, required this.ride , required this.driver , required this.showCarDetails , this.showOptions = false , this.shouldNavigate=false});



  @override
  Widget build(BuildContext context) {
    
    
    List dateInformation = [];
    try{
      dateInformation = ride.get('date').toString().split('-');
    }catch(e){
      dateInformation = [];
    }



    return InkWell(
      onTap: () {
        if(showCarDetails == false){
          if(showOptions == true || shouldNavigate == false){

          }
          else{
            Get.to(()=> RideDetailsBeforeDatabase(ride , driver));
          }

        }
      },
      child: Container(
        width: double.maxFinite,
        height: showCarDetails || showOptions ? 260 : 215,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        decoration: BoxDecoration(

          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: 1,
              color: Color(0xff393939).withOpacity(0.15),
            ),
          ],
          //color: Theme.of(context).primaryColor.withOpacity(0.8),
          //borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 10,
              leading: CircleAvatar(
                radius:25,
                backgroundImage: NetworkImage(
                  driver.get('image')!,
                  // width: 45,
                  // fit: BoxFit.cover,
                ),
              ),
              title: Text(
              '${driver.get('name')}', //DriverDoc!.get('driver_name')
              overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),

              ),
              subtitle: Row(
                  children: [
                    Icon(
                      Ionicons.star,
                      color: Colors.yellow[700],
                      size: 18,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, right: 6),
                      child: Text(
                        "4.0",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text("(195 Review)"),
                  ]
              ),
              // trailing: Container(
              //   width: 29,
              //   height: 29,
              //   padding: EdgeInsets.all(5),
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('assets/circle.png'),
              //     ),
              //   ),
              //   child: Image.asset('assets/bi_x-lg.png'),
              // ),
            ),

            const SizedBox(height: 2),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Ionicons.location_outline,
                          color: AppColors.greenColor,
                          size: 20,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.6),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              'From: ${ride.get('pickup_address')}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                //   color: AppColors.black,
                                //   //color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                              //maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Icon(
                          Ionicons.location_outline,
                          size: 20,
                          color: Colors.red,//Theme.of(context).primaryColor,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.6),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              'To: ${ride.get('destination_address')}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                //color: AppColors.black,
                                //color: AppColors.blue, //Theme.of(context).primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(

              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Icon(
                        Ionicons.calendar_outline,
                        size: 18,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6, right: 14),
                        child: Text(
                          '${dateInformation[0]}-${dateInformation[1]}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(
                          Ionicons.time_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${ride.get('start_time')}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),


                    ],
                  ),
                ),

                if(!showCarDetails)... [
                  Spacer(),
                  myText(
                    text: '${ride.get('price_per_seat')} EGP',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),

                ]

              ],

            ),

            if(showOptions)...[

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      //width: 200,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.greenColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      //width: 200,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Reject",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )

            ],

            if(showCarDetails)...[

              const SizedBox(height: 10),

              Row(
                children: [
                  Container(
                    //width: 200,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(
                        Ionicons.car_sport,
                        size: 18,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 6, right: 8),
                        child: Text(
                          '${driver.get('Vehicle_make')} ${driver.get('Vehicle_model')}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Container(
                          color: Colors.white,
                          child: SizedBox(
                            width: 2,
                            height: 16,
                          ),
                        ),
                      ),
                      Text(
                        '${driver.get('Vehicle_color')}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),

                    ],
                  ),
            ),
                ],
              )

            ]

          ],
        ),
      ),
    );
  }
}
