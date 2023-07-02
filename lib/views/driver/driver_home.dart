import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/auth_controller.dart';
import 'package:divide_ride/controller/polyline_handler.dart';
import 'package:divide_ride/controller/ride_controller.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/views/decision_screens/decision_screen.dart';
import 'package:divide_ride/views/driver/driver_profile.dart';
import 'package:divide_ride/views/ride_requests.dart';
import 'package:divide_ride/views/my_rides.dart';
import 'package:divide_ride/views/payment.dart';
import 'package:divide_ride/widgets/green_button.dart';
import 'package:divide_ride/widgets/icon_title_widget.dart';
import 'package:divide_ride/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'dart:ui' as ui;

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({Key? key}) : super(key: key);

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  String? _mapStyle;
  DateTime? date = DateTime.now();

  AuthController authController = Get.find<AuthController>();
  RideController rideController = Get.find<RideController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late LatLng destination;
  late LatLng source;
  final Set<Polyline> _polyline = {};

  // saving all the markers that will be showing on the map and store them in this set
  Set<Marker> markers = Set<Marker>();
  List<String> list = <String>[
    '**** **** **** 8789',
    '**** **** **** 8921',
    '**** **** **** 1233',
    '**** **** **** 4352'
  ];

  @override
  void initState() {
    super.initState();

    authController.getDriverInfo();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    timeController.text = '${date!.hour}:${date!.minute}:${date!.second}';
    dateController.text = '${date!.day}-${date!.month}-${date!.year}';

    loadCustomMarker();
  }

  String dropdownValue = '**** **** **** 8789';
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController? myMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      body: Container(
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: GoogleMap(
                  markers: markers,
                  polylines: _polyline,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    myMapController = controller;
                    myMapController!.setMapStyle(_mapStyle);
                  },
                  initialCameraPosition: _kGooglePlex,
                ),
              ),
              buildProfileTitle(),
              buildTextField(),
              showSourceField ? buildTextFieldForSource() : Container(),
              showDateTimeFields ? buildDateTimeFields() : Container(),
              showDateTimeFields ? buildMaxSeatsAndPriceFields() : Container(),
              showDateTimeFields ? buildConfirmButton() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileTitle() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Obx(() => authController.myDriver.value.name == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: Get.width,
              height: Get.width * 0.5,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(color: Colors.white70),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: authController.myDriver.value.image == null
                            ? DecorationImage(
                                image: AssetImage('assets/person.png'),
                                fit: BoxFit.fill)
                            : DecorationImage(
                                image: NetworkImage(
                                    authController.myDriver.value.image!),
                                fit: BoxFit.fill)),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Welcome back, ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                          TextSpan(
                              text: authController.myDriver.value.name
                                  ?.substring(
                                      0,
                                      authController.myDriver.value.name
                                          ?.indexOf(' ')),
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      Text(
                        "Create your ride",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  )
                ],
              ),
            )),
    );
  }

  TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);

  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController maxSeatsController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();

  bool showSourceField = false;
  bool showDateTimeFields = false;
  String? maxSeats = '1 seat';
  List<String> maxSeatsList = [
    '1 seat',
    '2 seats',
    '3 seats',
    '4 seats',
  ];

  Widget buildTextField() {
    return Positioned(
      top: 170,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: destinationController,
          readOnly: true,
          onTap: () async {
            Prediction? p =
                await authController.showGoogleAutoComplete(context);

            String selectedPlace = p!.description!;

            destinationController.text = selectedPlace;

            List<geoCoding.Location> locations =
                await geoCoding.locationFromAddress(selectedPlace);

            destination =
                LatLng(locations.first.latitude, locations.first.longitude);

            markers.add(Marker(
              markerId: MarkerId(selectedPlace),
              infoWindow: InfoWindow(
                title: 'Destination: $selectedPlace',
              ),
              position: destination,
              icon: BitmapDescriptor.fromBytes(markIcons),
            ));

            myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: destination, zoom: 14)
                //17 is new zoom level
                ));

            if (mounted)
              setState(() {
                showSourceField = true;
              });
          },
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Search for a destination',
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldForSource() {
    return Positioned(
      top: 230, //170
      left: 20, //20
      right: 20, //20
      child: Container(
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: sourceController,
          readOnly: true,
          onTap: () async {
            //buildSourceSheet();
            Get.back();
            Prediction? p =
                await authController.showGoogleAutoComplete(context);

            String place = p!.description!;

            sourceController.text = place;

            source = await authController.buildLatLngFromAddress(place);

            if (markers.length >= 2) {
              markers.remove(markers.last);
            }
            markers.add(Marker(
                markerId: MarkerId(place),
                infoWindow: InfoWindow(
                  title: 'Source: $place',
                ),
                position: source));

            await getPolylines(source, destination);

            drawPolyline(place);

            myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: source, zoom: 14)));
            if (mounted)
              setState(() {
                showDateTimeFields = true;
              });
          },
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black, // 0xffA7A7A7
          ),
          decoration: InputDecoration(
            hintText: 'From: ',
            hintStyle: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.search,
              ),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget buildDateTimeFields() {
    return Positioned(
      top: 290, //170
      left: 20, //20
      right: 20, //20
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          iconTitleContainer(
            isReadOnly: true,
            path: 'assets/date.png',
            text: 'Date',
            controller: dateController,
            validator: (input) {
              if (date == null) {
                Get.snackbar('Warning', "Date is required.",
                    colorText: Colors.white,
                    backgroundColor: AppColors.greenColor);
                return '';
              }
              return null;
            },
            onPress: () {
              _selectDate(context);
            },
          ),
          iconTitleContainer(
              path: 'assets/time.png',
              text: 'Start Time',
              controller: startTimeController,
              isReadOnly: true,
              width: 170,
              validator: (input) {
                if (input.isEmpty) {
                  Get.snackbar('Warning', "Time is required.",
                      colorText: Colors.white,
                      backgroundColor: AppColors.greenColor);
                  return '';
                }
                return null;
              },
              onPress: () {
                startTimeMethod(context);
              }),
        ],
      ),
    );
  }

  Widget buildMaxSeatsAndPriceFields() {
    return Positioned(
      top: 340, //170
      left: 20, //20
      right: 20, //20
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 10, right: 10),
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 4,
                        blurRadius: 10)
                  ],
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(width: 1, color: AppColors.genderTextColor),
                ),
                child: DropdownButton(
                  isExpanded: true,
                  underline: Container(),
                  borderRadius: BorderRadius.circular(10),
                  icon: Image.asset('assets/arrowDown.png'),
                  elevation: 16,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor,
                  ),
                  value: maxSeats,
                  onChanged: (String? newValue) {
                    if (mounted)
                      setState(
                        () {
                          maxSeats = newValue!;
                        },
                      );
                  },
                  items: maxSeatsList
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              iconTitleContainer(
                  path: 'assets/dollarLogo.png',
                  text: 'Price per Seat',
                  type: TextInputType.number,
                  height: 40,
                  controller: priceController,
                  width: 170,
                  onPress: () {},
                  validator: (String input) {
                    if (input.isEmpty) {
                      Get.snackbar('Warning', "Price is required.",
                          colorText: Colors.white,
                          backgroundColor: AppColors.greenColor);
                      return '';
                    }
                  })
            ],
          ),
        ],
      ),
    );
  }

  Widget buildConfirmButton() {
    return Positioned(
      top: 450, //170
      left: 20, //20
      right: 20,
      child: Obx(() => rideController.isRideUploading.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : greenButton(
              'Create Ride',
              () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                Get.defaultDialog(
                  title: "Are you sure to create this ride ?",
                  content: Container(),
                  //barrierDismissible: false,
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Get.back();
                        Map<String, dynamic> rideData = {
                          'pickup_address': sourceController.text,
                          'destination_address': destinationController.text,
                          'date': '${date!.day}-${date!.month}-${date!.year}',
                          'start_time': startTimeController.text,
                          'max_seats': maxSeats,
                          'price_per_seat': priceController.text,
                          'driver': FirebaseAuth.instance.currentUser!.uid,
                          'pending': [],
                          'picked_up': [],
                          'joined': [],
                          'rejected': [],
                          'status': "Upcoming",
                          'payment_method': '',
                          'pickup_latlng':
                              GeoPoint(source!.latitude, source.longitude),
                          'destination_latlng': GeoPoint(
                              destination!.latitude, destination.longitude),
                        };

                        rideController.isRideUploading(true);
                        rideController.createRide(rideData).then((value) {
                          print("Ride is done");
                          resetControllers();
                          showSourceField = false;
                          showDateTimeFields = false;
                          _polyline.clear();
                          markers.clear();
                        });
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
            )),
    );
  }

  Widget buildCurrentLocationIcon() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 15),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.green,
          child: Icon(Icons.my_location, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildNotificationIcon() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, left: 15),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Icon(Icons.notifications),
        ),
      ),
    );
  }

  Widget buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: Get.width * 0.8,
        height: 20,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 4,
                  blurRadius: 10)
            ],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12), topLeft: Radius.circular(12))),
        child: Center(
          child: Container(
              width: Get.width * 0.6,
              height: 4,
              // color: Colors.black45,
              decoration: ShapeDecoration(
                color: Colors.black45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              )),
        ),
      ),
    );
  }

  //each option inside the side drawer
  buildDrawerItem(
      {required String title,
      required Function onPressed,
      Color color = Colors.black,
      double fontSize = 20,
      FontWeight fontWeight = FontWeight.w700,
      double height = 45,
      bool isVisible = false}) {
    return SizedBox(
      height: height,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        // minVerticalPadding: 0,
        dense: true,
        onTap: () => onPressed(),
        title: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: fontSize, fontWeight: fontWeight, color: color),
            ),
            const SizedBox(
              width: 5,
            ),
            isVisible
                ? CircleAvatar(
                    backgroundColor: AppColors.greenColor,
                    radius: 15,
                    child: Text(
                      '1',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Obx(
            () => authController.myDriver.value.name == null
                ? Center(child: CircularProgressIndicator())
                : InkWell(
                    onTap: () {
                      // Get.to(() => const DriverProfile());
                    },
                    child: SizedBox(
                      height: 150,
                      child: DrawerHeader(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: authController.myDriver.value.image ==
                                        null
                                    ? const DecorationImage(
                                        image: AssetImage('assets/person.png'),
                                        fit: BoxFit.fill)
                                    : DecorationImage(
                                        image: NetworkImage(authController
                                            .myDriver.value.image!),
                                        fit: BoxFit.fill),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Good Morning, ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black.withOpacity(0.28),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    authController.myDriver.value.name == null
                                        ? "User"
                                        : authController.myDriver.value.name!,
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                buildDrawerItem(
                  title: 'Payment History',
                  onPressed: () => Get.to(() => PaymentScreen()),
                ),
                Stack(
                  children: [
                    buildDrawerItem(
                      title: 'Ride Requests',
                      onPressed: () => Get.to(() => RideRequests()),
                    ),
                    Positioned(
                      top: 19,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Obx(
                            () => Text(
                              '${rideController.pendingRequests.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    buildDrawerItem(
                      title: 'My Rides',
                      onPressed: () => Get.to(() => const MyRides()),
                    ),
                    Positioned(
                      top: 17,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Obx(
                            () => Text(
                              '${rideController.driverCurrentRide.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                buildDrawerItem(
                  title: 'Settings',
                  onPressed: () => Get.to(() => const DriverProfile()),
                ),
                buildDrawerItem(title: 'Support', onPressed: () {}),
                buildDrawerItem(
                  title: 'Log Out',
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Get.to(() => DecisionScreen());
                  },
                ),
              ],
            ),
          ),
          Spacer(),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                buildDrawerItem(
                  title: 'Rate us on store',
                  onPressed: () {},
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.15),
                  height: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  late Uint8List markIcons;

  loadCustomMarker() async {
    // loading asset from folder with specified width (in this case width = 100)
    markIcons = await loadAsset('assets/dest_marker.png', 100);
  }

  // getting the asset from assets folder
  Future<Uint8List> loadAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void drawPolyline(String placeId) {
    _polyline.clear();
    _polyline.add(Polyline(
      polylineId: PolylineId(placeId),
      visible: true, // this means this line should be visible to the user
      points: [
        source,
        destination
      ], // means from point a (source) to point b (destination) draw a polyline
      color: AppColors.greenColor, // color of polyline
      width: 5,
    ));
  }

  void buildSourceSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Select Your Location",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Home Address",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              Get.back();
              source = authController.myUser.value.homeAddress!;
              sourceController.text = authController.myUser.value.hAddress!;

              if (markers.length >= 2) {
                markers.remove(markers.last);
              }
              markers.add(Marker(
                  markerId: MarkerId(authController.myUser.value.hAddress!),
                  infoWindow: InfoWindow(
                    title: 'Source: ${authController.myUser.value.hAddress!}',
                  ),
                  position: source));

              await getPolylines(source, destination);

              drawPolyline(sourceController.text);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              if (mounted) setState(() {});
              buildRideConfirmationSheet();
            },
            child: Container(
              width: Get.width,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 4,
                        blurRadius: 10)
                  ]),
              child: Row(
                children: [
                  Text(
                    authController.myUser.value.hAddress!,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Business Address",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              Get.back();
              source = authController.myUser.value.bussinessAddres!;
              sourceController.text = authController.myUser.value.bAddress!;

              if (markers.length >= 2) {
                markers.remove(markers.last);
              }
              markers.add(Marker(
                  markerId: MarkerId(authController.myUser.value.bAddress!),
                  infoWindow: InfoWindow(
                    title: 'Source: ${authController.myUser.value.bAddress!}',
                  ),
                  position: source));

              await getPolylines(source, destination);

              drawPolyline(sourceController.text);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              if (mounted) setState(() {});
              buildRideConfirmationSheet();
            },
            child: Container(
              width: Get.width,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 4,
                        blurRadius: 10)
                  ]),
              child: Row(
                children: [
                  Text(
                    authController.myUser.value.bAddress!,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              Get.back();
              Prediction? p =
                  await authController.showGoogleAutoComplete(context);

              String place = p!.description!;

              sourceController.text = place;

              source = await authController.buildLatLngFromAddress(place);

              if (markers.length >= 2) {
                markers.remove(markers.last);
              }
              markers.add(Marker(
                  markerId: MarkerId(place),
                  infoWindow: InfoWindow(
                    title: 'Source: $place',
                  ),
                  position: source));

              await getPolylines(source, destination);

              drawPolyline(place);

              myMapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: source, zoom: 14)));
              if (mounted) setState(() {});
            },
            child: Container(
              width: Get.width,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 4,
                        blurRadius: 10)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Search for Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  buildRideConfirmationSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.4,
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              width: Get.width * 0.2,
              height: 8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          textWidget(
              text: 'Select an option:',
              fontSize: 18,
              fontWeight: FontWeight.bold),
          const SizedBox(
            height: 20,
          ),
          buildDriversList(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: buildPaymentCardWidget()),
                MaterialButton(
                  onPressed: () {},
                  child: textWidget(
                    text: 'Confirm',
                    color: Colors.white,
                  ),
                  color: AppColors.greenColor,
                  shape: StadiumBorder(),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  int selectedRide = 0;

  buildDriversList() {
    return Container(
      height: 90,
      width: Get.width,
      child: StatefulBuilder(builder: (context, set) {
        return ListView.builder(
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () {
                set(() {
                  selectedRide = i;
                });
              },
              child: buildDriverCard(selectedRide == i),
            );
          },
          itemCount: 3,
          scrollDirection: Axis.horizontal,
        );
      }),
    );
  }

  buildDriverCard(bool selected) {
    return Container(
      margin: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
      height: 85,
      width: 165,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: selected
                    ? Color(0xff2DBB54).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                offset: Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(12),
          color: selected ? Color(0xff2DBB54) : Colors.grey),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                    text: 'Standard',
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
                textWidget(
                    text: '\$9.90',
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textWidget(
                    text: '3 MIN',
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.normal,
                    fontSize: 12),
              ],
            ),
          ),
          Positioned(
              right: -20,
              top: 0,
              bottom: 0,
              child: Image.asset('assets/Mask Group 2.png'))
        ],
      ),
    );
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
              if (mounted)
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

  void resetControllers() {
    destinationController.clear();
    sourceController.clear();
    date = DateTime.now();
    dateController.text = '${date!.day}-${date!.month}-${date!.year}';
    timeController.clear();
    priceController.clear();
    maxSeatsController.clear();
    startTimeController.clear();
    if (mounted) setState(() {});
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date = DateTime(picked.year, picked.month, picked.day, date!.hour,
          date!.minute, date!.second);
      dateController.text = '${date!.day}-${date!.month}-${date!.year}';
    }
    if (mounted) setState(() {});
  }

  startTimeMethod(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime = picked;
      startTimeController.text =
          '${startTime.hourOfPeriod > 9 ? "" : '0'}${startTime.hour > 12 ? '${startTime.hour - 12}' : startTime.hour}:${startTime.minute > 9 ? startTime.minute : '0${startTime.minute}'} ${startTime.hour > 12 ? 'PM' : 'AM'}';
    }
    print("start ${startTimeController.text}");
    if (mounted) setState(() {});
  }

  Dialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text('Are you sure to create this ride ?'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {},
                child: textWidget(
                  text: 'Confirm',
                  color: Colors.white,
                ),
                color: AppColors.greenColor,
                shape: StadiumBorder(),
              ),
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
          ),
        );
      },
    );
  }
}
