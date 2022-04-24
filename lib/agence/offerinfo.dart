import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class OfferInfo {
  String description;
  int prix;
  double surface;
  String categorie;

  // String image;
  OfferInfo({
    // required this.image
    required this.surface,
    required this.description,
    required this.prix,
    required this.categorie,
  });
  factory OfferInfo.toObject(json) => OfferInfo(
        // image: json['path']
        surface: json['surface'].toDouble(),
        description: json['description'],
        prix: json['prix'],
        categorie: json['name'],
      );
}
