import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideModel {
  String? pickup_address;
  String? destination_address;
  String? start_time;
  String? date;
  String? max_seats;
  String? price_per_seat;
  String? driver;
  String? status;
  String? payment_method;

  List<String>? pending;
  List<String>? picked_up;
  List<String>? joined;
  List<String>? rejected;

  LatLng? pickup_latlng;
  LatLng? destination_latlng;

  RideModel({
    this.pickup_address,
    this.destination_address,
    this.start_time,
    this.date,
    this.max_seats,
    this.price_per_seat,
    this.driver,
    this.status,
    this.payment_method,
    this.pending,
    this.picked_up,
    this.joined,
    this.rejected,
  });

  RideModel.fromJson(Map<String, dynamic> json) {
    pickup_address = json['pickup_address'];
    destination_address = json['destination_address'];
    start_time = json['start_time'];
    date = json['date'];
    max_seats = json['max_seats'];
    price_per_seat = json['price_per_seat'];
    driver = json['driver'];
    status = json['status'];
    payment_method = json['payment_method'];
    pending = json['pending'];
    picked_up = json['picked_up'];
    joined = json['joined'];
    rejected = json['rejected'];
    pickup_latlng =
        LatLng(json['pickup_latlng'].latitude, json['pickup_latlng'].longitude);
    destination_latlng = LatLng(json['destination_latlng'].latitude,
        json['destination_latlng'].longitude);
  }
}
