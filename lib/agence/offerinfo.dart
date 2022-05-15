import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class OfferInfo {
  int id;
  String description;
  int prix;
  double surface;
  String categorie;
  String created_at;
  int num_image;
  int phone;
  String agenceName;
  String email;
  String willaya;
  String baladiya;
  String lat;
  String long;
  int bathroom;
  int garage;
  int bedroom;
  int livingroom;
  int kitchen;

  OfferInfo(
      {required this.id,
      required this.surface,
      required this.description,
      required this.prix,
      required this.categorie,
      required this.created_at,
      required this.num_image,
      required this.agenceName,
      required this.phone,
      required this.email,
      required this.baladiya,
      required this.willaya,
      required this.lat,
      required this.long,
      required this.bathroom,
      required this.bedroom,
      required this.garage,
      required this.kitchen,
      required this.livingroom});
  factory OfferInfo.toObject(json) => OfferInfo(
      id: json['id'],
      surface: json['surface'].toDouble(),
      description: json['description'],
      prix: json['prix'],
      categorie: json['name'],
      created_at: json['created_at'],
      num_image: json['images'],
      agenceName: json['agenceName'],
      phone: json['phone'],
      email: json['email'],
      baladiya: json['baladiya'],
      willaya: json['willaya'],
      lat: json['latitude'],
      long: json['longitude'],
      bathroom: json['bathroom'],
      bedroom: json['bedroom'],
      livingroom: json['livingroom'],
      garage: json['garage'],
      kitchen: json['kitchen']);
}
