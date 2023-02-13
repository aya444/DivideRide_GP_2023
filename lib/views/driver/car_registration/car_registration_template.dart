import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/views/driver/car_registration/pages/location_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_color_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_make.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_model_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_model_year_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_number_page.dart';
import 'package:divide_ride/views/driver/car_registration/pages/vehicle_type_page.dart';
import 'package:divide_ride/widgets/green_intro_widget.dart';
import 'package:flutter/material.dart';

class CarRegistrationTemplate extends StatefulWidget {
  const CarRegistrationTemplate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CarRegistrationTemplateState();

}

class _CarRegistrationTemplateState extends State<CarRegistrationTemplate>{
  String selectedLocation = '';
  String selectedVehicalType =  '';
  String selectedVehicalMake =  '';
  String selectedVehicalModel =  '';
  String selectModelYear = '';
  PageController pageController = PageController();
  TextEditingController vehicalNumberController = TextEditingController();
  String vehicalColor = '';

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          greenIntroWidgetWithoutLogos(title: 'Car Registration', subtitle: 'Complete the process detail'),

          const SizedBox(
            height: 20,
          ),

          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            child: PageView(
              onPageChanged: (int page){
                currentPage = page;
              },
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                LocationPage(selectedLocation: selectedLocation, onSelect: (String location){
                  setState(() {
                    selectedLocation = location;
                  });
                },),

                VehicalTypePage(
                  selectedVehical: selectedVehicalType,
                  onSelect: (String vehicalType){
                    setState(() {
                      selectedVehicalType = vehicalType;
                    });
                  },
                ),

                VehicalMakePage(
                  selectedVehical: selectedVehicalMake,
                  onSelect: (String vehicalMake){
                    setState(() {
                      selectedVehicalMake = vehicalMake;
                    });
                  },
                ),

                VehicalModelPage(
                  selectedModel: selectedVehicalModel,
                  onSelect: (String vehicalModel){
                    setState(() {
                      selectedVehicalModel = vehicalModel;
                    });
                  },
                ),
                VehicalModelYearPage(
                  onSelect: (int year){
                    setState(() {
                      selectModelYear = year.toString();
                    });
                  },
                ),

                VehicalNumberPage(
                  controller: vehicalNumberController,
                ),

                VehicalColorPage(
                  onColorSelected: (String selectedColor){
                    vehicalColor = selectedColor;
                  },
                ),
              ],
            ),
          ),),
          Align(
            alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(onPressed: (){
                  pageController.animateToPage(currentPage+1, duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
                }, child: Icon(Icons.arrow_forward, color: Colors.white,), backgroundColor: AppColors.greenColor,),
              )
          ),
        ],
      )
    );
  }

}
