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

  OfferInfo({
    required this.id,
    required this.surface,
    required this.description,
    required this.prix,
    required this.categorie,
    required this.created_at,
    required this.num_image,
    required this.agenceName,
    required this.phone,
    required this.email,
  });
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
      );
}
