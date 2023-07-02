import 'package:divide_ride/widgets/upcoming_rides_for_driver.dart';
import 'package:divide_ride/widgets/upcoming_rides_for_user.dart';
import 'package:flutter/material.dart';

import '../shared preferences/shared_pref.dart';
import '../utils/app_constants.dart';

class UpcomingRidesView extends StatefulWidget {
  const UpcomingRidesView({Key? key}) : super(key: key);

  @override
  State<UpcomingRidesView> createState() => _UpcomingRidesViewState();
}

class _UpcomingRidesViewState extends State<UpcomingRidesView> {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            SizedBox(height: 30),
            Expanded(
              child:
                  isDriver ? UpcomingRidesForDriver() : UpcomingRidesForUser(),
            )
          ])),
    );
  }
}
