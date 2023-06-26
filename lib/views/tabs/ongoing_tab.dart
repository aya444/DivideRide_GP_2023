import 'package:flutter/material.dart';

import '../ongoing_ride_view.dart';

class OngoingTab extends StatelessWidget {
  const OngoingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OngoingRidesView(),
    );
  }
}
