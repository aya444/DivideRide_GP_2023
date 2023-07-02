import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../shared preferences/shared_pref.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';

class UserBox extends StatefulWidget {
  final DocumentSnapshot user;
  final String rideId;

  UserBox({
    Key? key,
    required this.user,
    required this.rideId,
  }) : super(key: key);

  @override
  State<UserBox> createState() => _UserBoxState();
}

class _UserBoxState extends State<UserBox> {
  RideController rideController = Get.find<RideController>();
  bool isDriver = false;
  bool isPickedUp = false;

  @override
  void initState() {
    isDriver = CacheHelper.getData(key: AppConstants.decisionKey) ?? false;
    super.initState();
  }

  void onPickedUp() {
    setState(() {
      isPickedUp = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // Handle onTap logic here
        },
        child: Container(
          width: double.maxFinite,
          height: 170,
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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      widget.user.get('image')!,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 10,
                      title: Text(
                        '${widget.user.get('name')}',
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
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.phone),
                    color: AppColors.greenColor,
                    onPressed: () {
                      //TODO add phone functionality here
                    },
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(children: [
                Expanded(
                    child: SizedBox(
                  width: 200.00,
                  child: ElevatedButton(
                    onPressed: () {
                      rideController.pickedUp(widget.rideId, widget.user.id);
                      onPickedUp();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: isPickedUp ? Colors.blue : AppColors.greenColor,
                      onPrimary: isPickedUp ? Colors.green : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isPickedUp ? 'Picked Up' : 'Pick Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )),
              ]),
            ],
          ),
        ));
  }
}
