import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/views/driver/view_users.dart';
import 'package:divide_ride/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../shared preferences/shared_pref.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../views/ride_details_view.dart';

class RideBox extends StatefulWidget {
  final DocumentSnapshot ride;
  final DocumentSnapshot driver;
  final bool showCarDetails;
  final bool showOptions;
  final bool shouldNavigate;
  final bool showStartOption;
  DocumentSnapshot? request;

  RideBox(
      {super.key,
      required this.ride,
      required this.driver,
      required this.showCarDetails,
      this.showOptions = false,
      this.shouldNavigate = false,
      this.request,
      this.showStartOption = false});

  @override
  State<RideBox> createState() => _RideBoxState();
}

class _RideBoxState extends State<RideBox> {
  RideController rideController = Get.find<RideController>();
  bool isDriver = false;

  @override
  void initState() {
    isDriver = CacheHelper.getData(key: AppConstants.decisionKey) ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List dateInformation = [];
    try {
      dateInformation = widget.ride.get('date').toString().split('-');
    } catch (e) {
      dateInformation = [];
    }

    return InkWell(
      onTap: () {
        if (widget.showCarDetails == false) {
          if (widget.showOptions == true ||
              widget.shouldNavigate == false ||
              widget.showStartOption == true) {
          } else {
            Get.to(() => RideDetailsView(widget.ride, widget.driver));
          }
        }
      },
      child: Container(
        width: double.maxFinite,
        height: widget.showCarDetails ||
                widget.showOptions ||
                widget.showStartOption
            ? 288
            : 245,
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 10,
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  widget.driver.get('image')!,
                ),
              ),
              title: Text(
                '${widget.driver.get('name')}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              subtitle: Row(children: [
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
              ]),
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
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width / 1.6),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              'From: ${widget.ride.get('pickup_address')}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
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
                          color: Colors.red,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width / 1.6),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              'To: ${widget.ride.get('destination_address')}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
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
                        '${widget.ride.get('start_time')}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!widget.showCarDetails) ...[
                  Spacer(),
                  myText(
                    text: '${widget.ride.get('price_per_seat')} EGP',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ]
              ],
            ),
            if (widget.showOptions) ...[
              const SizedBox(height: 10),
              Obx(() => rideController.isRequestLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.defaultDialog(
                                title: "Are you sure to accept this request ?",
                                content: Container(),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Get.back();

                                      rideController.isRequestLoading(true);
                                      rideController.acceptRequest(
                                          widget.ride, widget.request);
                                      rideController.updatePendingRequests();

                                      Get.back();
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
                            },
                            child: Container(
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
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.defaultDialog(
                                title: "Are you sure to reject this request ?",
                                content: Container(),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Get.back();
                                      rideController.isRequestLoading(true);
                                      rideController.rejectRequest(
                                          widget.ride, widget.request);
                                      rideController.updatePendingRequests();
                                      Get.back();
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
                            },
                            child: Container(
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
                        ),
                      ],
                    ))
            ],
            if (widget.showStartOption && isDriver) ...[
              const SizedBox(height: 10),
              Obx(
                () => rideController.isRidesLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                // Check if the 'joined' field exists and has a length >= 1
                                final joinedArrayLength = await rideController
                                    .getJoinedArrayLength(widget.ride.id);
                                if (joinedArrayLength >= 1) {
                                  Get.defaultDialog(
                                    title: "Are you want to start the ride?",
                                    content: Container(),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () {
                                          Get.back();
                                          rideController.isRidesLoading(true);
                                          rideController
                                              .startRide(widget.ride.id);
                                          rideController.getAcceptedUserForRide(
                                              widget.ride.id);
                                          rideController
                                              .updateOngoingDriverRide();
                                          rideController
                                              .updateOngoingUserRide();
                                          Get.to(() => ViewUsers(
                                              rideId: widget.ride.id));
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
                                          Get.back(); //TODO add user detail page here
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
                                } else {
                                  Get.snackbar(
                                    'FAILED TO START THE RIDE!',
                                    'No one joined the ride, you need to have at least one passenger with you!',
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red,
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.greenColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Start",
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
              ),
            ],
            if (widget.showStartOption && !isDriver) ...[
              const SizedBox(height: 7),
              Center(
                child: Text(
                  "Welcome Aboard!",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greenColor,
                  ),
                ),
              ),
            ],
            if (widget.showCarDetails) ...[
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
                            '${widget.driver.get('Vehicle_make')} ${widget.driver.get('Vehicle_model')}',
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
                          '${widget.driver.get('Vehicle_color')}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
            if (widget.ride.get('status') == "Cancelled") ...[
              const SizedBox(height: 7),
              Center(
                child: Text(
                  '${widget.ride.get('status')}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
