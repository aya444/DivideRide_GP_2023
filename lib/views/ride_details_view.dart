// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:divide_ride/utils/app_colors.dart';
// import 'package:divide_ride/widgets/location.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';
//
// import '../controller/ride_controller.dart';
// import '../views/ride_details_view.dart';
//
// class RideDetailsView extends StatefulWidget {
//
//   DocumentSnapshot ride , driver;
//
//   RideDetailsView(this.ride,this.driver);
//
//   @override
//   State<RideDetailsView> createState() => _RideDetailsViewState();
// }
//
// class _RideDetailsViewState extends State<RideDetailsView> {
//
//   RideController rideController = Get.find<RideController>();
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // return Container(
//     //   width: double.maxFinite,
//     //   height: 190,
//     //   padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
//     //   decoration: BoxDecoration(
//     //
//     //     color: AppColors.white,
//     //     borderRadius: BorderRadius.circular(10),
//     //     boxShadow: [
//     //       BoxShadow(
//     //         blurRadius: 2,
//     //         spreadRadius: 1,
//     //         color: Color(0xff393939).withOpacity(0.15),
//     //       ),
//     //     ],
//     //     color: Theme.of(context).primaryColor.withOpacity(0.8),
//     //     borderRadius: BorderRadius.circular(20),
//     //   ),
//     //   child: Row(
//     //     crossAxisAlignment: CrossAxisAlignment.start,
//     //     children: [
//     //       ClipRRect(
//     //         borderRadius: BorderRadius.circular(10),
//     //         child: Image.asset(
//     //           'assets/doctor_2.jpg',
//     //           width: 45,
//     //           fit: BoxFit.cover,
//     //         ),
//     //       ),
//     //       const SizedBox(width: 14),
//     //       Column(
//     //         crossAxisAlignment: CrossAxisAlignment.start,
//     //         children: [
//     //           Text(
//     //             "Dr. Ruben Dorwart",
//     //             style: TextStyle(
//     //               fontSize: 18,
//     //               fontWeight: FontWeight.bold,
//     //               color: Theme.of(context).colorScheme.onPrimary,
//     //             ),
//     //           ),
//     //           const SizedBox(height: 5),
//     //           Text(
//     //             "Dental Specialist",
//     //             style: Theme.of(context).textTheme.bodyText1!.copyWith(
//     //               color: Colors.white70,
//     //             ),
//     //           ),
//     //           const SizedBox(height: 18),
//     //
//     //           Container(
//     //             padding: const EdgeInsets.symmetric(
//     //               vertical: 6,
//     //               horizontal: 8.0,
//     //             ),
//     //             decoration: BoxDecoration(
//     //                 color: Colors.white10,
//     //                 borderRadius: BorderRadius.circular(10)),
//     //             child: Row(
//     //               children: const [
//     //                 Icon(
//     //                   Ionicons.calendar_outline,
//     //                   size: 18,
//     //                   color: Colors.white,
//     //                 ),
//     //                 Padding(
//     //                   padding: EdgeInsets.only(left: 6, right: 14),
//     //                   child: Text(
//     //                     "Today",
//     //                     style: TextStyle(color: Colors.white),
//     //                   ),
//     //                 ),
//     //                 Padding(
//     //                   padding: EdgeInsets.only(right: 8),
//     //                   child: Icon(
//     //                     Ionicons.time_outline,
//     //                     size: 18,
//     //                     color: Colors.white,
//     //                   ),
//     //                 ),
//     //                 Text(
//     //                   "14:30",
//     //                   style: TextStyle(
//     //                     color: Colors.white,
//     //                   ),
//     //                 ),
//     //                 Padding(
//     //                   padding: EdgeInsets.only(left:14 ,right: 8),
//     //                   child: Icon(
//     //                     Ionicons.location_outline,
//     //                     size: 18,
//     //                     color: Colors.white,
//     //                   ),
//     //                 ),
//     //                 Text(
//     //                   "14:30",
//     //                   style: TextStyle(
//     //                     color: Colors.white,
//     //                   ),
//     //                 ),
//     //
//     //               ],
//     //             ),
//     //           ),
//     //
//     //           const SizedBox(height: 7),
//     //
//     //           Container(
//     //             padding: const EdgeInsets.symmetric(
//     //               vertical: 6,
//     //               horizontal: 8.0,
//     //             ),
//     //             decoration: BoxDecoration(
//     //                 color: Colors.white10,
//     //                 borderRadius: BorderRadius.circular(10)),
//     //             child: Row(
//     //               children: const [
//     //                 Icon(
//     //                   Ionicons.car_sport,
//     //                   size: 18,
//     //                   color: Colors.white,
//     //                 ),
//     //                 Padding(
//     //                   padding: EdgeInsets.only(left: 6, right: 14),
//     //                   child: Text(
//     //                     "Honda",
//     //                     style: TextStyle(color: Colors.white),
//     //                   ),
//     //                 ),
//     //                 Padding(
//     //                   padding: EdgeInsets.only(right: 8),
//     //                   child: Icon(
//     //                     Ionicons.time_outline,
//     //                     size: 18,
//     //                     color: Colors.white,
//     //                   ),
//     //                 ),
//     //                 Text(
//     //                   "14:30 - 15:30 AM",
//     //                   style: TextStyle(
//     //                     color: Colors.white,
//     //                   ),
//     //                 )
//     //               ],
//     //             ),
//     //           ),
//     //
//     //
//     //         ],
//     //       )
//     //     ],
//     //   ),
//     // );
//
//     // /// this Query is to find the (uid of ride which is the Driver who created this ride r)
//     // DocumentSnapshot driver = rideController.allUsers.firstWhere( (r) => widget.ride.get('uid') == r.id );
//     // String driverImage = '';
//     // try{
//     //   driverImage = driver.get('image');
//     // }catch(e){
//     //   driverImage = '';
//     // }
//     //
//     // List joinedUsers = [];
//     //
//     // try{
//     //   joinedUsers = widget.ride.get('joined');
//     // }catch(e){
//     //   joinedUsers = [];
//     // }
//
//     String driverImage = '';
//     try{
//       driverImage = widget.driver.get('image');
//     }catch(e){
//       driverImage = '';
//     }
//
//     List joinedUsers = [];
//
//     try{
//       joinedUsers = widget.ride.get('joined');
//     }catch(e){
//       joinedUsers = [];
//     }
//
//     List dateInformation = [];
//     try{
//       dateInformation = DateFormat.MMMd().format(widget.ride.get('date')).toString().split(' ');
//     }catch(e){
//       dateInformation = [];
//     }
//
//
//     return Scaffold(
//
//       appBar: AppBar(
//         backgroundColor: AppColors.greenColor,
//         title: Center( child: Text('Ride Details') ),
//         centerTitle: true,
//       ),
//
//       body: Padding(
//         padding: EdgeInsets.symmetric(vertical: 24 , horizontal: 24),
//         child: Column(
//           children: [
//             Container(
//               width: double.maxFinite,
//               height: 260,
//               padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
//               decoration: BoxDecoration(
//
//                 color: AppColors.whiteColor,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 2,
//                     spreadRadius: 1,
//                     color: Color(0xff393939).withOpacity(0.15),
//                   ),
//                 ],
//                 //color: Theme.of(context).primaryColor.withOpacity(0.8),
//                 //borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     horizontalTitleGap: 10,
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.network(
//                         driverImage,
//                         width: 45,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     title: Text(
//                       '${widget.driver.get('name')}', //widget.DriverDoc!.get('driver_name') ,
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.black,
//                       ),
//
//                     ),
//                     subtitle: Row(
//                         children: [
//                           Icon(
//                             Ionicons.star,
//                             color: Colors.yellow[700],
//                             size: 18,
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(left: 4, right: 6),
//                             child: Text(
//                               "4.0",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           const Text("(195 Review)"),
//                         ]
//                     ),
//                     trailing: Container(
//                       width: 29,
//                       height: 29,
//                       padding: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage('assets/circle.png'),
//                         ),
//                       ),
//                       child: Image.asset('assets/bi_x-lg.png'),
//                     ),
//                   ),
//
//                   const SizedBox(height: 2),
//
//                   Row(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Ionicons.location_outline,
//                                 color: AppColors.greenColor,
//                                 size: 20,
//                               ),
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.6),
//                                 child: SizedBox(
//                                   width: double.maxFinite,
//                                   child: Text(
//                                     "From:  '${widget.ride.get('pickup_address')}'",
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w600,
//                                       //   color: AppColors.black,
//                                       //   //color: Colors.black54,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                     //maxLines: 2,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           Row(
//                             children: [
//                               Icon(
//                                 Ionicons.location_outline,
//                                 size: 20,
//                                 color: Colors.red,//Theme.of(context).primaryColor,
//                               ),
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.6),
//                                 child: SizedBox(
//                                   width: double.maxFinite,
//                                   child: Text(
//                                     "To:  '${widget.ride.get('destination_address')}'",
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w600,
//                                       //color: AppColors.black,
//                                       //color: AppColors.blue, //Theme.of(context).primaryColor,
//                                     ),
//                                     overflow: TextOverflow.ellipsis,
//                                     maxLines: 1,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   Row(
//
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 6,
//                           horizontal: 8.0,
//                         ),
//                         decoration: BoxDecoration(
//                             color: AppColors.blue,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Ionicons.calendar_outline,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(left: 6, right: 14),
//                               child: Text(
//                                 '${dateInformation[1]} ${dateInformation[0]}',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(right: 8),
//                               child: Icon(
//                                 Ionicons.time_outline,
//                                 size: 18,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             Text(
//                               '${widget.ride.get('start_time')}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: 80,
//                       ),
//                       myText(
//                         text: '255 EGP',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 6,
//                           horizontal: 8.0,
//                         ),
//                         decoration: BoxDecoration(
//                             color: AppColors.blue,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Row(
//                           children: [
//                           const Icon(
//                               Ionicons.car_sport,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.only(left: 6, right: 8),
//                               child: Text(
//                                 'Nissan Suny',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(right: 8),
//                               child: Container(
//                                 color: Colors.white,
//                                 child: SizedBox(
//                                   width: 2,
//                                   height: 16,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               "blue",
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               child: Row(
//                 children: [
//
//
//                   Container(
//                     width: Get.width*0.6,
//                     height: 50,
//                     child: ListView.builder(itemBuilder: (context,index){
//
//                       DocumentSnapshot joinedUser = rideController.allUsers.firstWhere((e)=> e.id == joinedUsers[index]);
//
//                       String image = '';
//
//                       try{
//                         image = joinedUser.get('image');
//                       }catch(e){
//                         image = '';
//                       }
//
//
//
//                       return Container(
//                         margin: EdgeInsets.only(left: 10),
//                         child: CircleAvatar(
//                           minRadius: 13,
//                           backgroundImage: NetworkImage(image),
//                         ),
//                       );
//                     },itemCount: joinedUsers.length,scrollDirection: Axis.horizontal,),
//                   ),
//
//                   Spacer(),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         "${widget.ride.get('price')} EGP",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18,
//                         ),
//                       ),
//                       Text(
//                         "${widget.ride.get('max_entries')} seats left!",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//
//                     },
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(13),
//                           color: AppColors.greenColor.withOpacity(0.9)),
//                       child: Center(
//                         child: Text(
//                           "cancel Ride",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//
//                     },
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.4),
//                               spreadRadius: 0.1,
//                               blurRadius: 60,
//                               offset:
//                               Offset(0, 1), // changes position of shadow
//                             ),
//                           ],
//                           borderRadius: BorderRadius.circular(13)),
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                       child: Center(
//                         child: Text(
//                           'Edit Ride',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//           ],
//         ),
//       ),
//     );
//     return Container(
//       width: Get.width,
//       height: 190,
//       decoration: BoxDecoration(
//         color: AppColors.whiteColor,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//
//             blurRadius: 2,
//             spreadRadius: 1,
//             color: Color(0xff393939).withOpacity(0.15),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 100,
//             height: 190,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 bottomLeft: Radius.circular(10),
//               ),
//               image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: AssetImage('assets/doctor_2.jpg')   //NetworkImage(),
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   child: Row(
//                     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       myText(
//                         text: 'Driver name', //widget.DriverDoc!.get('driver_name') ,
//                         style: TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.black,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 65,
//                       ),
//                       myText(
//                         text: '25 EGP',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                     children: [
//                       Icon(
//                         Ionicons.star,
//                         color: Colors.yellow[700],
//                         size: 18,
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.only(left: 4, right: 6),
//                         child: Text(
//                           "4.0",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       const Text("(195 Review)"),
//                     ]
//                 ),
//
//                 const SizedBox(height: 15),
//
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(
//                           Ionicons.location_outline,
//                           color: AppColors.greenColor,
//                           size: 14,
//                         ),
//                         Text(
//                           "Shobra, Asad",
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             //   color: AppColors.black,
//                             //   //color: Colors.black54,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           //maxLines: 2,
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 6,
//                     ),
//                     Row(
//                       children: [
//                         Icon(
//                           Ionicons.location_outline,
//                           size: 14,
//                           color: Colors.red,//Theme.of(context).primaryColor,
//                         ),
//                         Text(
//                           "Shobra, Menyat as Serg, El Sahel",
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             //color: AppColors.black,
//                             //color: AppColors.blue, //Theme.of(context).primaryColor,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         )
//                       ],
//                     ),
//
//                   ],
//                 ),
//
//                 const SizedBox(height: 20),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 6,
//                     horizontal: 8.0,
//                   ),
//                   decoration: BoxDecoration(
//                       color: AppColors.blue,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Row(
//                     children: const [
//                       Icon(
//                         Ionicons.calendar_outline,
//                         size: 18,
//                         color: Colors.white,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 6, right: 14),
//                         child: Text(
//                           "Today",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: 8),
//                         child: Icon(
//                           Ionicons.time_outline,
//                           size: 18,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         "14:30",
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//     // return Column(
//     //   children: List.generate(nearbyDoctors.length, (index) {
//     //     return Padding(
//     //       padding: const EdgeInsets.only(bottom: 18),
//     //       child: Row(
//     //         children: [
//     //           Container(
//     //             width: 100,
//     //             height: 100,
//     //             decoration: BoxDecoration(
//     //               borderRadius: BorderRadius.circular(10),
//     //               image: DecorationImage(
//     //                 image: AssetImage(nearbyDoctors[index].profile),
//     //                 fit: BoxFit.cover,
//     //               ),
//     //             ),
//     //           ),
//     //           const SizedBox(width: 10),
//     //           Column(
//     //             crossAxisAlignment: CrossAxisAlignment.start,
//     //             children: [
//     //               Text(
//     //                 "Dr. ${nearbyDoctors[index].name}",
//     //                 style: const TextStyle(
//     //                     fontSize: 16, fontWeight: FontWeight.bold),
//     //               ),
//     //               const SizedBox(height: 8),
//     //               const Text("General practitioner"),
//     //               const SizedBox(height: 16),
//     //               Row(
//     //                 children: [
//     //                   Icon(
//     //                     Ionicons.star,
//     //                     color: Colors.yellow[700],
//     //                     size: 18,
//     //                   ),
//     //                   const Padding(
//     //                     padding: EdgeInsets.only(left: 4, right: 6),
//     //                     child: Text(
//     //                       "4.0",
//     //                       style: TextStyle(fontWeight: FontWeight.bold),
//     //                     ),
//     //                   ),
//     //                   const Text("195 Reviews")
//     //                 ],
//     //               )
//     //             ],
//     //           )
//     //         ],
//     //       ),
//     //     );
//     //   }),
//     // );
//
//     // return Column(
//     //   children: List.generate(nearbyPlaces.length, (index) {
//     //     return Padding(
//     //       padding: const EdgeInsets.only(bottom: 10),
//     //       child: SizedBox(
//     //         height: 135,
//     //         width: double.maxFinite,
//     //         child: Card(
//     //           elevation: 0.4,
//     //           shape: RoundedRectangleBorder(
//     //             borderRadius: BorderRadius.circular(12),
//     //           ),
//     //           child: InkWell(
//     //             borderRadius: BorderRadius.circular(12),
//     //             // onTap: () {
//     //             //   Navigator.push(
//     //             //       context,
//     //             //       MaterialPageRoute(
//     //             //         builder: (context) => TouristDetailsPage(
//     //             //           image: nearbyPlaces[index].image,
//     //             //         ),
//     //             //       ));
//     //             // },
//     //             child: Padding(
//     //               padding: const EdgeInsets.all(8.0),
//     //               child: Row(
//     //                 children: [
//     //                   ClipRRect(
//     //                     borderRadius: BorderRadius.circular(12),
//     //                     child: Image.asset(
//     //                       nearbyPlaces[index].image,
//     //                       height: double.maxFinite,
//     //                       width: 130,
//     //                       fit: BoxFit.cover,
//     //                     ),
//     //                   ),
//     //                   const SizedBox(width: 10),
//     //                   Expanded(
//     //                     child: Column(
//     //                       crossAxisAlignment: CrossAxisAlignment.start,
//     //                       children: [
//     //                         const Text(
//     //                           "Sea of Peace",
//     //                           style: TextStyle(
//     //                             fontSize: 16,
//     //                             fontWeight: FontWeight.bold,
//     //                           ),
//     //                         ),
//     //                         const Text("Portic Team"),
//     //                         const SizedBox(height: 10),
//     //                         // DISTANCE WIDGET
//     //                         const Distance(),
//     //                         const Spacer(),
//     //                         Row(
//     //                           children: [
//     //                             Icon(
//     //                               Icons.star,
//     //                               color: Colors.yellow.shade700,
//     //                               size: 14,
//     //                             ),
//     //                             const Text(
//     //                               "4.5",
//     //                               style: TextStyle(
//     //                                 fontSize: 12,
//     //                               ),
//     //                             ),
//     //                             const Spacer(),
//     //                             RichText(
//     //                               text: TextSpan(
//     //                                   style: TextStyle(
//     //                                     fontSize: 20,
//     //                                     color: Theme.of(context).primaryColor,
//     //                                   ),
//     //                                   text: "\$22",
//     //                                   children: const [
//     //                                     TextSpan(
//     //                                         style: TextStyle(
//     //                                           fontSize: 12,
//     //                                           color: Colors.black54,
//     //                                         ),
//     //                                         text: "/ Person")
//     //                                   ]),
//     //                             )
//     //                           ],
//     //                         )
//     //                       ],
//     //                     ),
//     //                   )
//     //                 ],
//     //               ),
//     //             ),
//     //           ),
//     //         ),
//     //       ),
//     //     );
//     //   }),
//     // );
//
//   }
// }
//
//
// Widget myText({text, style, textAlign}) {
//   return Text(
//     text,
//     style: style,
//     textAlign: textAlign,
//
//   );
// }
