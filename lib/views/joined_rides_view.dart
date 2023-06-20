import 'package:flutter/material.dart';

import '../shared preferences/shared_pref.dart';
import '../utils/app_constants.dart';
import '../widgets/joined_rides_for_user.dart';
import '../widgets/upcoming_rides_for_driver.dart';
import '../widgets/upcoming_rides_for_user.dart';

class JoinedRidesView extends StatefulWidget {
  const JoinedRidesView({Key? key}) : super(key: key);

  @override
  State<JoinedRidesView> createState() => _JoinedRidesViewState();
}

class _JoinedRidesViewState extends State<JoinedRidesView> {

  bool isDriver = false;


  @override
  void initState() {
    // TODO: implement initState

    isDriver = CacheHelper.getData(key: AppConstants.decisionKey) ?? false ;

    print(isDriver.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
              children:  [

                SizedBox(height: 30),
                Expanded(
                  child: isDriver ? UpcomingRidesForDriver() : JoinedRidesForUser(),

                )
              ]
          )
      ),
    );
  }
}
