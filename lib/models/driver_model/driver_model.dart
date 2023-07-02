class DriverModel {
  String? country;
  String? vehicle_color;
  String? vehicle_make;
  String? vehicle_model;
  String? vehicle_number;
  String? vehicle_type;
  String? vehicle_year;
  String? document;
  String? email;
  String? name;
  bool? IsDriver;
  String? image;

  DriverModel(
      {this.name,
      this.country,
      this.vehicle_color,
      this.vehicle_make,
      this.vehicle_model,
      this.vehicle_number,
      this.vehicle_type,
      this.vehicle_year,
      this.document,
      this.IsDriver,
      this.email,
      this.image});

  DriverModel.fromJson(Map<String, dynamic> json) {
    country = json['Country'];
    vehicle_color = json['Vehicle_color'];
    vehicle_make = json['Vehicle_make'];
    vehicle_model = json['Vehicle_model'];
    vehicle_number = json['Vehicle_number'];
    vehicle_type = json['Vehicle_type'];
    vehicle_year = json['Vehicle_year'];
    document = json['document'];
    email = json['email'];
    image = json['image'];
    IsDriver = json['isDriver'];
    name = json['name'];
  }
}
