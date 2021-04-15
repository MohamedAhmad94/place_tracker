import 'package:flutter/material.dart';
import 'package:place_tracker/models/places_data.dart';
import 'package:place_tracker/models/places_model.dart';

class PlacesController extends ChangeNotifier {
  List<Place>? places;
  PlaceCategory? selectedCategory;
  PlaceViewType? viewType;

  PlacesController(
      {this.places = PlacesData.places,
      this.selectedCategory = PlaceCategory.favorite,
      this.viewType = PlaceViewType.map});

  void setViewType(PlaceViewType viewType) {
    this.viewType = viewType;
    notifyListeners();
  }

  void setSelectedCategory(PlaceCategory newCategory) {
    selectedCategory = newCategory;
    notifyListeners();
  }

  void setPlaces(List<Place> newPlaces) {
    places = newPlaces;
    notifyListeners();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlacesController &&
        other.places == places &&
        other.selectedCategory == selectedCategory &&
        other.viewType == viewType;
  }

  @override
  int get hashCode => hashValues(places, selectedCategory, viewType);
}

enum PlaceViewType {
  map,
  list,
}
