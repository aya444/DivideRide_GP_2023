import 'package:flutter/material.dart';

import '../shared preferences/shared_pref.dart';
import '../utils/app_constants.dart';
import '../widgets/ongoing_ride_for_driver.dart';
import '../widgets/ongoing_ride_for_user.dart';

class OngoingRidesView extends StatefulWidget {
  const OngoingRidesView({Key? key}) : super(key: key);

  @override
  State<OngoingRidesView> createState() => _OngoingRidesViewState();
}

class _OngoingRidesViewState extends State<OngoingRidesView> {
  bool isDriver = false;

  @override
  void initState() {
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
              child: isDriver ? OngoingRideForDriver() : OngoingRideForUser(),
            )
          ])),
    );
  }
}
