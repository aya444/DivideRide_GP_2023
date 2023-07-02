import 'package:flutter/material.dart';

import '../shared preferences/shared_pref.dart';
import '../utils/app_constants.dart';
import '../widgets/history_rides_for_driver.dart';
import '../widgets/history_rides_for_user.dart';

class HistoryRidesView extends StatefulWidget {
  const HistoryRidesView({Key? key}) : super(key: key);

  @override
  State<HistoryRidesView> createState() => _UpcomingRidesViewState();
}

class _UpcomingRidesViewState extends State<HistoryRidesView> {
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
              child: isDriver ? HistoryRidesForDriver() : HistoryRidesForUser(),
            )
          ])),
    );
  }
}
