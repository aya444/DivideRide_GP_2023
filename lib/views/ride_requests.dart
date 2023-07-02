import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/views/tabs/accepted_tab.dart';
import 'package:divide_ride/views/tabs/pending_tab.dart';
import 'package:divide_ride/views/tabs/rejected_tab.dart';
import 'package:flutter/material.dart';

class RideRequests extends StatelessWidget {
  const RideRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.greenColor,
          title: Text('My Requests'),
          centerTitle: true,
          bottom: TabBar(
              isScrollable: true,
              labelColor: AppColors.whiteColor,
              labelStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.grey[300],
              unselectedLabelStyle: const TextStyle(fontSize: 14),
              indicatorWeight: 3.0,
              padding: const EdgeInsets.only(left: 30, right: 30),
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Accepted'),
                Tab(text: 'Rejected'),
                // Tab(icon: Icon(Icons.settings )),
              ]),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(children: [
                PendingTab(),
                AcceptedTab(),
                RejectedTab(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
