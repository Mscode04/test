class UserModel {
  String? firstName;
  String? lastName;
  String? city;
  String? contactNumber;

  UserModel({this.firstName, this.lastName, this.city, this.contactNumber});

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    city = json['city'];
    contactNumber = json['contact_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['city'] = this.city;
    data['contact_number'] = this.contactNumber;
    return data;
  }
}
