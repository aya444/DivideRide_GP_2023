// import 'package:divide_ride/utils/app_colors.dart';
// import 'package:divide_ride/views/login_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
              }, initialCameraPosition: _kGooglePlex,
             // Padding(
            //   padding: const EdgeInsets.all(100.0),
            //   child: Center(
            //     child: Column(
            //       children:
            //       [
            //         Text(
            //         'Your are LogedIn',
            //         style: GoogleFonts.poppins(
            //             fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            //         ),
            //         SizedBox(
            //           height: 20,
            //         ),
            //         MaterialButton(
            //         minWidth: Get.width,
            //         height: 50,
            //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            //         color: AppColors.greenColor,
            //         onPressed: () async{
            //           await FirebaseAuth.instance.signOut();
            //           Get.to(() => LoginScreen());
            //         },
            //         child: Text(
            //           'Logout',
            //           style: GoogleFonts.poppins(
            //               fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            //         ),
            //       )
            //       ]
            //     ),
            //   ),
            // ),
            ),
          ),
          buildProfileTitle(),
          buildTextField(),
        ],
      ),
    );
  }

  Widget buildProfileTitle(){
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.green,
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome Back, ',
                        style: TextStyle(color: Colors.black, fontSize: 14)
                      ),
                      TextSpan(
                          text: 'Name',
                          style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold)
                      ),
                    ]
                  ),
                ),
                Text("Where are you going?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(){
    return Positioned(
      top: 170,
      left: 20,
      right: 20,
      child: Container(
        width: Get.width,
        height: 50,
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
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xffA7A7A7)),
          decoration: InputDecoration(
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
}
