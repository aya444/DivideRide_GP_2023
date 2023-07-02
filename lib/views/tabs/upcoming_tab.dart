import 'package:divide_ride/views/upcoming_rides_view.dart';
import 'package:flutter/material.dart';

class UpcomingTab extends StatelessWidget {
  const UpcomingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpcomingRidesView(),
    );
  }
}
