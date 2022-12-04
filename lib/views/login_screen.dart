import 'package:divide_ride/views/otp_verification_screen.dart';
import 'package:divide_ride/widgets/green_intro_widget.dart';
import 'package:divide_ride/widgets/login_widget.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const  LoginScreen({Key? key}) : super(key: key);


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

   final countryPicker = const FlCountryCodePicker(/*showSearchBar: true*/);

  CountryCode countryCode = CountryCode(name: 'Egypt', code: "eg", dialCode: "+20");


  onSubmit(String? input){
    Get.to(()=>OtpVerificationScreen(countryCode.dialCode+input!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              greenIntroWidget(),

              const SizedBox(height: 50,),

              loginWidget(countryCode,()async{

                final code = await countryPicker.showPicker(context: context);
                if (code != null)  countryCode = code;
                setState(() {

                });
              },onSubmit),


            ],
          ),
        ),
      ),
    );
  }
  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(DiagnosticsProperty<bool>('countryPicker', countryPicker));
  // }
}