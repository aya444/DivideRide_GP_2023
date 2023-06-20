import 'package:flutter/material.dart';

import '../joined_rides_view.dart';

class JoinedTab extends StatelessWidget {
  const JoinedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JoinedRidesView(),
    );
  }
}
