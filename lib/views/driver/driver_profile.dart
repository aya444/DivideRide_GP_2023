import 'dart:io';

import 'package:divide_ride/widgets/green_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:divide_ride/controller/auth_controller.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/widgets/green_intro_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class DriverProfile extends StatefulWidget {
  const DriverProfile({Key? key}) : super(key: key);

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthController authController = Get.find<AuthController>();

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = authController.myDriver.value.name??"";
    emailController.text = authController.myDriver.value.email??"";

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * 0.4,
              child: Stack(
                children: [
                  greenIntroWidgetWithoutLogos(title: 'My Profile'),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        getImage(ImageSource.camera);
                      },
                      child: selectedImage == null
                          ? authController.myDriver.value.image!=null? Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(authController.myDriver.value.image!),
                                fit: BoxFit.fill),
                            shape: BoxShape.circle,
                            color: Color(0xffD6D6D6)),

                      ): Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffD6D6D6)),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      )
                          : Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(selectedImage!),
                                fit: BoxFit.fill),
                            shape: BoxShape.circle,
                            color: Color(0xffD6D6D6)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 23),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                        'Name', Icons.person_outlined, nameController,(String? input){

                      if(input!.isEmpty){
                        return 'Name is required!';
                      }

                      if(input.length<5){
                        return 'Please enter a valid name!';
                      }

                      return null;

                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(

                        'Email', Icons.email, emailController,(String? input){

                      if(input!.isEmpty){
                        return 'Email is required!';
                      }

                      if(!input.isEmail){
                        return 'Enter valid email.';
                      }

                      return null;

                    },onTap: ()async{



                    },readOnly: false),

                    const SizedBox(
                      height: 30,
                    ),
                    Obx(() => authController.isProfileUploading.value
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : greenButton('Update', () {


                      if(!formKey.currentState!.validate()){
                        return;
                      }


                      authController.isProfileUploading(true);
                      authController.storeDriverInfo(
                        selectedImage,
                        nameController.text,
                        emailController.text,
                        url: authController.myDriver.value.image??"",


                      );
                    })),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextFieldWidget(
      String title, IconData iconData, TextEditingController controller,Function validator,{Function? onTap,bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xffA7A7A7)),
        ),
        const SizedBox(
          height: 6,
        ),
        Container(
          width: Get.width,
          // height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            readOnly: readOnly,
            onTap: ()=> onTap!(),
            validator: (input)=> validator(input),
            controller: controller,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xffA7A7A7)),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  iconData,
                  color: AppColors.greenColor,
                ),
              ),
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }


}