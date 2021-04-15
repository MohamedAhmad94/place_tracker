import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Place {
  final String? id;
  final LatLng? latLng;
  final String? name;
  final PlaceCategory? category;
  final String? description;
  final double? rating;

  const Place(
      {@required this.id,
      @required this.latLng,
      @required this.name,
      @required this.category,
      this.description,
      this.rating});

  double get latitude => latLng!.latitude;

  double get longitude => latLng!.longitude;

  Place copyWith({
    String? id,
    LatLng? latLng,
    String? name,
    PlaceCategory? category,
    String? description,
    double? rating,
  }) {
    return Place(
        id: this.id,
        latLng: this.latLng,
        name: this.name,
        category: this.category,
        description: this.description,
        rating: this.rating);
  }
}

enum PlaceCategory { visited, favorite, planned }
