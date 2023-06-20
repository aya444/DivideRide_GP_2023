import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/views/tabs/joined_tab.dart';
import 'package:divide_ride/views/tabs/upcoming_tab.dart';
import 'package:flutter/material.dart';

import 'tabs/history_tab.dart';

class MyRides extends StatelessWidget {
  const MyRides({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.greenColor,
          title: Text('All Rides'),
          centerTitle: true,
          bottom: TabBar(
              isScrollable: true,
              labelColor: AppColors.whiteColor,
              labelStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.grey[300],
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              indicatorWeight: 3.0,
              padding: EdgeInsets.only(left: 30, right: 30),
              tabs: [
                Tab(text: 'Upcoming Rides'),
                Tab(text: 'Joined Rides'),
                Tab(text: 'Rides History'),
                // Tab(icon: Icon(Icons.settings )),
              ]),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(children: [

                UpcomingTab(),
                JoinedTab(),
                HistoryTab(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

// class CustomAppBar extends StatefulWidget {
//   const CustomAppBar({Key? key}) : super(key: key);
//
//   @override
//   State<CustomAppBar> createState() => _CustomAppBarState();
// }
//
// class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin{
//
//   late TabController tabController;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     tabController = TabController(length: 3, vsync: this);
//   }
//
//   // @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('T A B B A R' , style: TextStyle(fontWeight: FontWeight.bold ) ),
//         centerTitle: true,
//         bottom: TabBar(
//             controller: tabController,
//             labelColor: AppColors.greenColor,
//             labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             unselectedLabelColor: Colors.grey,
//             unselectedLabelStyle: const TextStyle(fontSize: 18),
//             indicatorWeight: 3.0,
//             tabs: [
//               Tab(text: 'Upcoming'),
//               Tab(text: 'Upcoming'),
//               Tab(icon: Icon(Icons.person )),
//             ]
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height:40),
//           // Center( child: Text('T A B B A R') ),
//           TabBar(
//               // controller: tabController,
//               labelColor: AppColors.greenColor,
//               labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               unselectedLabelColor: Colors.grey,
//               unselectedLabelStyle: const TextStyle(fontSize: 18),
//               indicatorWeight: 3.0,
//               tabs: [
//                 Tab(text: 'Upcoming'),
//                 Tab(icon: Icon(Icons.settings )),
//                 Tab(icon: Icon(Icons.person )),
//               ]
//           ),
//           Expanded(
//             child: TabBarView(children: [
//
//               UpcomingTab(),
//               PastTab(),
//
//               Container(
//                   color: Colors.yellow,
//                   child: Center(
//                     child: Text('3st TAB'),
//                   )
//               ),
//             ]
//
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
