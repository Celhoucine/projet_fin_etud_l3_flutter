class OfferInfo {
  String email;
  int phone;
  String? address;
  String agenceName;
  OfferInfo(
      {required this.email,
      required this.phone,
      required this.address,
      required this.agenceName});
  factory OfferInfo.toObject(json) => OfferInfo(
    email: json['email'],
        phone: json['phone'],
        address: json['address'],
        agenceName: json['agenceName']
  );
}
