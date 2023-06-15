import 'package:divide_ride/widgets/upcoming_rides_for_driver.dart';
import 'package:flutter/material.dart';

import '../history_rides_view.dart';
import '../rides_view.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HistoryRidesView(),
    );
  }
}
