import 'package:divide_ride/views/driver/accepted_requests_view.dart';
import 'package:flutter/material.dart';

class AcceptedTab extends StatelessWidget {
  const AcceptedTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            SizedBox(height: 30),
            Expanded(
              child: AcceptedRequestsView(),
            )
          ])),
    );
  }
}
