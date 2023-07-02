import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/shared%20preferences/shared_pref.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/utils/app_constants.dart';
import 'package:divide_ride/views/user/payment_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/ride_controller.dart';
import '../widgets/ride_box.dart';
import '../widgets/text_widget.dart';

class RideDetailsView extends StatefulWidget {
  DocumentSnapshot ride;
  DocumentSnapshot driver;
  RideDetailsView(this.ride, this.driver);

  @override
  State<RideDetailsView> createState() => _RideDetailsViewState();
}

class _RideDetailsViewState extends State<RideDetailsView> {
  RideController rideController = Get.find<RideController>();

  bool isDriver = false;

  @override
  void initState() {
    super.initState();
    rideController.isRidesLoading(true);

    isDriver = CacheHelper.getData(key: AppConstants.decisionKey) ?? false;

    print(isDriver.toString());
    rideController.getAcceptedUserForRide(widget.ride.id);
  }

  @override
  Widget build(BuildContext context) {
    RideController rideController = Get.find<RideController>();

    String userId = FirebaseAuth.instance.currentUser!.uid;
    String maxSeats = widget.ride.get('max_seats');
    List pendingUsers = [];

    try {
      pendingUsers = widget.ride.get('pending');
    } catch (e) {
      pendingUsers = [];
    }

    List joinedUsers = [];

    try {
      joinedUsers = widget.ride.get('joined');
    } catch (e) {
      joinedUsers = [];
    }

    List rejectedUsers = [];

    try {
      rejectedUsers = widget.ride.get('rejected');
    } catch (e) {
      rejectedUsers = [];
    }

    try {
      rejectedUsers = widget.ride.get('rejected');
    } catch (e) {
      rejectedUsers = [];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenColor,
        title: Text('Ride Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            RideBox(
                ride: widget.ride, driver: widget.driver, showCarDetails: true),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                child: Row(
                  children: [
                    Container(
                      width: Get.width * 0.6,
                      height: 50,
                      child: Row(
                        children: List<Widget>.generate(
                          joinedUsers.length,
                          (index) {
                            DocumentSnapshot user = rideController.allUsers
                                .firstWhere((e) => e.id == joinedUsers[index]);
                            String image = '';

                            try {
                              image = user.get('image');
                            } catch (e) {
                              image = '';
                            }
                            return Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(image),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.ride.get('price_per_seat')} EGP',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${widget.ride.get('max_seats')} left',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            // Spacer(),
            if (isDriver) ...[
              if (widget.ride.get('status') == 'Ended' ||
                  widget.ride.get('status') == 'Cancelled')
                ...[]
              else if (widget.ride.get('status') == 'Upcoming') ...[
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          rideController.cancelRide(widget.ride.id);
                          rideController.updateHistoryDriverRide();
                          rideController.updateHistoryUserRide();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: Colors.red.withOpacity(0.9)),
                          child: Center(
                            child: Text(
                              "Cancel Ride",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                        onTap: () {
                          if (pendingUsers.contains(userId)) {
                          } else if (joinedUsers.contains(userId)) {
                          } else if (rejectedUsers.contains(userId)) {
                          } else if (widget.ride.get('max_seats') ==
                              "0 seats") {
                          } else {
                            Get.defaultDialog(
                              title: "Are you sure to join this ride ?",
                              content: Container(),
                              //barrierDismissible: false,
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Get.back();

                                    //rideController.isRequestLoading(true);
                                    rideController.requestToJoinRide(
                                        widget.ride, userId);

                                    //Get.back();
                                  },
                                  child: textWidget(
                                    text: 'Confirm',
                                    color: Colors.white,
                                  ),
                                  color: AppColors.greenColor,
                                  shape: StadiumBorder(),
                                ),
                                SizedBox(width: 7),
                                MaterialButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: textWidget(
                                    text: 'Cancel',
                                    color: Colors.white,
                                  ),
                                  color: Colors.red,
                                  shape: StadiumBorder(),
                                ),
                              ],
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13),
                              color: pendingUsers.contains(userId)
                                  ? AppColors.yellow.withOpacity(0.9)
                                  : rejectedUsers.contains(userId)
                                      ? Colors.red.shade700
                                      : joinedUsers.contains(userId)
                                          ? AppColors.greenColor
                                              .withOpacity(0.9)
                                          : AppColors.greenColor
                                              .withOpacity(0.9)),
                          child: Center(
                              child: Text(
                            pendingUsers.contains(userId)
                                ? "Pending"
                                : rejectedUsers.contains(userId)
                                    ? "Rejected"
                                    : joinedUsers.contains(userId)
                                        ? "Joined"
                                        : widget.ride.get('max_seats') ==
                                                "0 seats"
                                            ? "No seats Available"
                                            : "Send Request",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )),
                        )),
                  ),
                  if (widget.ride.get('status') == "Ended") ...[
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(() => PaymentView(widget.ride, widget.driver));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 0.1,
                                  blurRadius: 60,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(13)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Center(
                            child: Text(
                              'Pay',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ],
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

Widget myText({text, style, textAlign}) {
  return Text(
    text,
    style: style,
    textAlign: textAlign,
  );
}
