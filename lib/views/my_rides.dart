import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/views/tabs/ongoing_tab.dart';
import 'package:divide_ride/views/tabs/upcoming_tab.dart';
import 'package:flutter/material.dart';

import '../shared preferences/shared_pref.dart';
import '../utils/app_constants.dart';
import 'tabs/history_tab.dart';

class MyRides extends StatefulWidget {
  const MyRides({Key? key}) : super(key: key);

  @override
  State<MyRides> createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  bool isDriver = false;

  @override
  void initState() {
    // TODO: implement initState

    isDriver = CacheHelper.getData(key: AppConstants.decisionKey) ?? false;

    print(isDriver.toString());

    super.initState();
  }

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
                Tab(text: 'Ongoing'),
                Tab(text: 'Upcoming'),
                Tab(text: 'History'),
              ]),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(children: [
                OngoingTab(),
                UpcomingTab(),
                HistoryTab(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
