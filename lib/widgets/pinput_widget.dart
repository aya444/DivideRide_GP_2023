import 'package:divide_ride/controller/auth_controller.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

class RoundedWithShadow extends StatefulWidget {
  const RoundedWithShadow({Key? key}) : super(key: key);

  @override
  _RoundedWithShadowState createState() => _RoundedWithShadowState();

  @override
  String toStringShort() => 'Rounded With Shadow';
}

class _RoundedWithShadowState extends State<RoundedWithShadow> {

  AuthController authController = Get.find<AuthController>();

  void initState() {
    // TODO: implement initState
    super.initState();
    listenOtp();
  }

  void listenOtp() async{
    await SmsAutoFill().listenForCode();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  String codeValue = "";

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: TextStyle(fontSize: 20, color: Colors.black),
                  colorBuilder: FixedColorBuilder(AppColors.greenColor),
                ),
                currentCode: codeValue,
                codeLength: 6,
                onCodeChanged: (code) {
                  print("onCodeChanged $code");
                  if (code!.length == 6) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                  setState(() {
                    codeValue = code.toString();
                  });
                },
                onCodeSubmitted: (pin) {
                  print("onCodeSubmitted $pin");
                  authController.verifyOtp(pin);
                },

              ),
            ),


          ),
        )
    );
  }
}