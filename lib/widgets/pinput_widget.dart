// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';
//
// class RoundedWithShadow extends StatefulWidget {
//   const RoundedWithShadow({Key? key}) : super(key: key);
//
//   @override
//   _RoundedWithShadowState createState() => _RoundedWithShadowState();
//
//   @override
//   String toStringShort() => 'Rounded With Shadow';
// }
//
// class _RoundedWithShadowState extends State<RoundedWithShadow> {
//   //final controller = TextEditingController();
//   //final focusNode = FocusNode();
//
//   @override
//   void dispose() {
//     //controller.dispose();
//     //focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 60,
//       height: 64,
//       textStyle: GoogleFonts.poppins(
//         fontSize: 20,
//         color: const Color.fromRGBO(70, 69, 66, 1),
//       ),
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(232, 235, 241, 0.37),
//         borderRadius: BorderRadius.circular(24),
//       ),
//     );
//
//     final cursor = Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         width: 21,
//         height: 1,
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(137, 146, 160, 1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//
//     return Pinput(
//       length: 4,
//       //controller: controller,
//       //focusNode: focusNode,
//       defaultPinTheme: defaultPinTheme,
//       separator: const SizedBox(width: 16),
//       focusedPinTheme: defaultPinTheme.copyWith(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: const [
//             BoxShadow(
//               color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
//               offset: Offset(0, 3),
//               blurRadius: 16,
//             )
//           ],
//         ),
//       ),
//       onClipboardFound: (value) {
//         debugPrint('onClipboardFound: $value');
//         //controller.setText(value);
//       },
//       showCursor: true,
//       cursor: cursor,
//     );
//   }
// }
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