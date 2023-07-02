import 'package:flutter/material.dart';

import '../history_rides_view.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HistoryRidesView(),
    );
  }
}
