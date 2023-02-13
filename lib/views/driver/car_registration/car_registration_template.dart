import 'dart:io';

import 'package:divide_ride/controller/auth_controller.dart';
import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/views/driver/car_registration/pages/document_uploaded_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/location_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/upload_document_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_color_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_make.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_model_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_model_year_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_number_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_type_page.dart';
import 'package:divide_ride/views/driver/verification_pending_screen.dart';
import 'package:divide_ride/widgets/green_intro_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

class CarRegistrationTemplate extends StatefulWidget {
  const CarRegistrationTemplate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CarRegistrationTemplateState();
}

class _CarRegistrationTemplateState extends State<CarRegistrationTemplate> {
  String selectedLocation = '';
  String selectedVehicalType = '';
  String selectedVehicalMake = '';
  String selectedVehicalModel = '';
  String selectModelYear = '';
  PageController pageController = PageController();
  TextEditingController vehicalNumberController = TextEditingController();
  String vehicalColor = '';
  File? document;

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        greenIntroWidgetWithoutLogos(
            title: 'Car Registration', subtitle: 'Complete the process detail'),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: PageView(
              onPageChanged: (int page) {
                currentPage = page;
              },
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                LocationPage(
                  selectedLocation: selectedLocation,
                  onSelect: (String location) {
                    setState(() {
                      selectedLocation = location;
                    });
                  },
                ),
                VehicalTypePage(
                  selectedVehical: selectedVehicalType,
                  onSelect: (String vehicalType) {
                    setState(() {
                      selectedVehicalType = vehicalType;
                    });
                  },
                ),
                VehicalMakePage(
                  selectedVehical: selectedVehicalMake,
                  onSelect: (String vehicalMake) {
                    setState(() {
                      selectedVehicalMake = vehicalMake;
                    });
                  },
                ),
                VehicalModelPage(
                  selectedModel: selectedVehicalModel,
                  onSelect: (String vehicalModel) {
                    setState(() {
                      selectedVehicalModel = vehicalModel;
                    });
                  },
                ),
                VehicalModelYearPage(
                  onSelect: (int year) {
                    setState(() {
                      selectModelYear = year.toString();
                    });
                  },
                ),
                VehicalNumberPage(
                  controller: vehicalNumberController,
                ),
                VehicalColorPage(
                  onColorSelected: (String selectedColor) {
                    vehicalColor = selectedColor;
                  },
                ),
                UploadDocumentPage(
                  onImageSelected: (File image) {
                    document = image;
                  },
                ),
                DocumentUploadedPage(),
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(()=> isUploading.value? Center(child: CircularProgressIndicator(),): FloatingActionButton(
                onPressed: () {
                  if (currentPage < 8) {
                    pageController.animateToPage(currentPage + 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn);
                  } else {
                    uploadDriverCarEntry();
                  }
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                backgroundColor: AppColors.greenColor,
              ),)
            )),
      ],
    ));
  }

  var isUploading = false.obs;

  void uploadDriverCarEntry() async {
    isUploading(true);

    String imageURL = await Get.find<AuthController>().uploadImage(document!); // This will upload the image

    Map<String, dynamic> carData = {
      'Country': selectedLocation,
      'Vehicle_type': selectedVehicalType,
      'Vehicle_make': selectedVehicalMake,
      'Vehicle_model': selectedVehicalModel,
      'Vehicle_year': selectModelYear,
      'Vehicle_number': vehicalNumberController.text.trim(),
      'Vehicle_color': vehicalColor,
      'document': imageURL,
    };

    await Get.find<AuthController>().uploadCarEntry(carData); //This will upload the car info
    isUploading(false);

    Get.to(()=> VerificaitonPendingScreen());
  }
}
