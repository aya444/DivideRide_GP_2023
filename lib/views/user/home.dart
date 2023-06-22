import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divide_ride/controller/auth_controller.dart';
import 'package:divide_ride/controller/polyline_handler.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/views/user/my_profile.dart';
import 'package:divide_ride/views/payment.dart';
import 'package:divide_ride/views/user/nearest_rides_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'dart:ui' as ui;

import '../../controller/ride_controller.dart';
import '../../widgets/green_button.dart';
import '../../widgets/icon_title_widget.dart';
import '../decision_screens/decision_screen.dart';
import '../my_rides.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _mapStyle;
  DateTime? date = DateTime.now();

  AuthController authController = Get.find<AuthController>();
  RideController rideController = Get.find<RideController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late LatLng destination;
  late LatLng source;
  final Set<Polyline> _polyline = {};

  // saving all the markers that will be showing on the map and store them in this set
  Set<Marker> markers = Set<Marker>();

  @override
  void initState() {
    super.initState();

    authController.getUserInfo();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    dateController.text = '${date!.day}-${date!.month}-${date!.year}';

    loadCustomMarker();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GoogleMapController? myMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      body: Stack(
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
          buildCurrentLocationIcon(),
          showSourceField ? buildTextFieldForSource() : Container(),
          showDateTimeFields ? buildSearchButton() : Container(),
          showDateTimeFields ? buildDateField() : Container(),
          buildBottomSheet(),
        ],
      ),
    );
  }

  // Widget for the welcome part
  Widget buildProfileTitle() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Obx(() => authController.myUser.value.name == null
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
                        image: authController.myUser.value.image == null
                            ? DecorationImage(
                                image: AssetImage('assets/person.png'),
                                fit: BoxFit.fill)
                            : DecorationImage(
                                image: NetworkImage(
                                    authController.myUser.value.image!),
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
                              text: authController.myUser.value.name?.substring(
                                  0,
                                  authController.myUser.value.name
                                      ?.indexOf(' ')),
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      Text(
                        "Where are you going?",
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

  TextEditingController destinationController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool showSourceField = false;
  bool showDateTimeFields = false;

  // Widget for destination field
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

  // Widget buildTextFieldForSource() {
  //   return Positioned(
  //     top: 230, //170
  //     left: 20, //20
  //     right: 20, //20
  //     child: Container(
  //       width: Get.width,
  //       height: 50,
  //       padding: EdgeInsets.only(left: 15),
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           boxShadow: [
  //             BoxShadow(
  //                 color: Colors.black.withOpacity(0.05),
  //                 spreadRadius: 4,
  //                 blurRadius: 10)
  //           ],
  //           borderRadius: BorderRadius.circular(8)),
  //       child: TextFormField(
  //         controller: sourceController,
  //         readOnly: true,
  //         onTap: () async {
  //           //buildSourceSheet();
  //           Get.back();
  //           Prediction? p =
  //               await authController.showGoogleAutoComplete(context);
  //
  //           String place = p!.description!;
  //
  //           sourceController.text = place;
  //
  //           source = await authController.buildLatLngFromAddress(place);
  //
  //           if (markers.length >= 2) {
  //             markers.remove(markers.last);
  //           }
  //           markers.add(Marker(
  //               markerId: MarkerId(place),
  //               infoWindow: InfoWindow(
  //                 title: 'Source: $place',
  //               ),
  //               position: source));
  //
  //           await getPolylines(source, destination);
  //
  //           drawPolyline(place);
  //
  //           myMapController!.animateCamera(CameraUpdate.newCameraPosition(
  //               CameraPosition(target: source, zoom: 14)));
  //           if (mounted)
  //             setState(() {
  //               showDateTimeFields = true;
  //             });
  //         },
  //         style: GoogleFonts.poppins(
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.black, // 0xffA7A7A7
  //         ),
  //         decoration: InputDecoration(
  //           hintText: 'From: ',
  //           hintStyle: GoogleFonts.poppins(
  //               fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
  //           suffixIcon: Padding(
  //             padding: const EdgeInsets.only(left: 10),
  //             child: Icon(
  //               Icons.search,
  //             ),
  //           ),
  //           border: InputBorder.none,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget for Source field
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
            buildSourceSheet();
          },
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
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

  // Widget for Current location Icon
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

  // Widget for bottom sheet that shows users' favourite locations
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

  Widget buildDateField() {
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
        ],
      ),
    );
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

  Widget buildSearchButton() {
    return Positioned(
      top: 350, //170
      left: 20, //20
      right: 20,
      child: Obx(
        () => rideController.isRideUploading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : greenButton('Search for Rides', () {
                // if (!formKey.currentState!.validate()) {
                //  return;
                //   }
                print("I am before array!");
                Map<String, dynamic> searchRideInfo = {
                  'pickup_address': sourceController.text,
                  'destination_address': destinationController.text,
                  'date': '${date!.day}-${date!.month}-${date!.year}',
                  'pickup_latlng': GeoPoint(source!.latitude, source.longitude),
                  'destination_latlng':
                      GeoPoint(destination!.latitude, destination.longitude),
                };
                print("I ama after array");
                print('Search Ride Info: $searchRideInfo');

                rideController.findAndArrangeRides(searchRideInfo);

                print('Filtered and arranged rides:');
                rideController.filteredAndArrangedRides.forEach((snapshot) {
                  final data = snapshot.data() as Map<String, dynamic>?;

                  if (data != null) {
                    final pickupAddress = data['pickup_address'];
                    final destinationAddress = data['destination_address'];

                    if (pickupAddress != null && destinationAddress != null) {
                      print('Ride ID: ${snapshot.id}');
                      print('Pickup Address: $pickupAddress');
                      print('Destination Address: $destinationAddress');
                      // Add more fields as needed
                    } else {
                      print('Invalid ride data for Ride ID: ${snapshot.id}');
                    }
                  } else {
                    print('No data available for Ride ID: ${snapshot.id}');
                  }
                });

                resetControllers();
                Get.to(() => NearestRidePage(
                      rideController: rideController,
                    ));
              }),
      ),
    );
  }

  // each option inside the side drawer
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

  // Widget to create the side drawer
  buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Obx(() => authController.myUser.value.name == null ? Center(child: CircularProgressIndicator()) :
          InkWell(
            onTap: () {
              Get.to(() => const MyProfile());
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
                        image: authController.myUser.value.image == null
                            ? const DecorationImage(
                                image: AssetImage('assets/person.png'),
                                fit: BoxFit.fill)
                            : DecorationImage(
                                image: NetworkImage(
                                    authController.myUser.value.image!),
                                fit: BoxFit.fill)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Good Morning, ',
                            style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.28),
                                fontSize: 14)),
                        Text(
                          authController.myUser.value.name == null
                              ? "User"
                              : authController.myUser.value.name!,
                          style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      ],
                    ),
                  )
                ],
              )),
            ),
          ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                buildDrawerItem(title: 'Payment History', onPressed: () => Get.to(() => PaymentScreen())),
                //buildDrawerItem(title: 'Ride History', onPressed: () {}, isVisible: true),
                buildDrawerItem(title: 'All Rides', onPressed: () => Get.to(()=> const MyRides())),
                buildDrawerItem(title: 'Settings', onPressed: () {Get.to(() => const MyProfile());}),
                buildDrawerItem(title: 'Support', onPressed: () {}),
                buildDrawerItem(title: 'Log Out', onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Get.to(() => DecisionScreen());}),
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
                    title: 'Do more',
                    onPressed: () {},
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.15),
                    height: 20),
                const SizedBox(
                  height: 20,
                ),
                // buildDrawerItem(
                //     title: 'Get food delivery',
                //     onPressed: () {},
                //     fontSize: 12,
                //     fontWeight: FontWeight.w500,
                //     color: Colors.black.withOpacity(0.15),
                //     height: 20),
                // buildDrawerItem(
                //     title: 'Make money driving',
                //     onPressed: () {},
                //     fontSize: 12,
                //     fontWeight: FontWeight.w500,
                //     color: Colors.black.withOpacity(0.15),
                //     height: 20),
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
          const SizedBox(
            height: 20,
          ),
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

  // Function to fetch users' favourite locations in source sheet
  void buildSourceSheet() {
    Get.bottomSheet(Container(
      width: Get.width,
      height: Get.height * 0.7,
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
              if (mounted)
                setState(() {
                  showDateTimeFields = true;
                });
              // buildRideConfirmationSheet();
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
              if (mounted)
                setState(() {
                  showDateTimeFields = true;
                });
              // buildRideConfirmationSheet();
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
              if (mounted)
                setState(() {
                  showDateTimeFields = true;
                });
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

  void resetControllers() {
    destinationController.clear();
    sourceController.clear();
    date = DateTime.now();
    dateController.text = '${date!.day}-${date!.month}-${date!.year}';
    if (mounted) setState(() {});
  }
}
