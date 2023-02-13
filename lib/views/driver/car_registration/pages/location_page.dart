import 'package:divide_ride/utils/app_colors.dart';
import 'package:divide_ride/widgets/green_intro_widget.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key, required this.selectedLocation, required this.onSelect}) : super(key: key);

  final String selectedLocation;
  final Function onSelect;
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<String> locations = [
    'Egypt',
    'Morocco',
    'Algeria',
    'Lybia'
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('What service Location you want to register?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),),
        SizedBox(height: 10,),

        Expanded(child: ListView.builder(itemBuilder: (ctx,i){
          return ListTile(
            onTap: ()=> widget.onSelect(locations[i]),
            visualDensity: VisualDensity(vertical: -4), // to decrease the spacing between each item in the list
            title: Text(locations[i]),
            trailing: widget.selectedLocation == locations[i]?Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar( // will trail the checked item in the list
                backgroundColor: AppColors.greenColor,
                child: Icon(Icons.check, color: Colors.white,size: 15,),
              ),
            ):SizedBox.shrink(),
          );
        }, itemCount: locations.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),),)
      ],
    );
  }

}