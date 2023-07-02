import 'package:divide_ride/views/driver/rejected_requests_view.dart';
import 'package:flutter/material.dart';

class RejectedTab extends StatelessWidget {
  const RejectedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            SizedBox(height: 30),
            Expanded(
              child: RejectedRequestsView(),
            )
          ])),
    );
  }
}
