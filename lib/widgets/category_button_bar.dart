import 'package:flutter/material.dart';
import 'package:place_tracker/models/places_model.dart';

class CategoryBar extends StatelessWidget {
  final PlaceCategory? selectedPlaceCategory;
  final bool? visible;
  final ValueChanged<PlaceCategory>? onChanged;
  const CategoryBar(
      {Key? key,
      @required this.selectedPlaceCategory,
      @required this.visible,
      @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible!,
        child: Container(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 14.0),
          alignment: Alignment.bottomCenter,
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: selectedPlaceCategory == PlaceCategory.favorite
                          ? Colors.green[700]
                          : Colors.lightGreen),
                  child: Text("Favorites",
                      style: Theme.of(context).textTheme.headline3),
                  onPressed: () => onChanged!(PlaceCategory.favorite)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: selectedPlaceCategory == PlaceCategory.visited
                          ? Colors.green[700]
                          : Colors.lightGreen),
                  child: Text("Visited",
                      style: Theme.of(context).textTheme.headline3),
                  onPressed: () => onChanged!(PlaceCategory.visited)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: selectedPlaceCategory == PlaceCategory.planned
                          ? Colors.green[700]
                          : Colors.lightGreen),
                  child: Text("Planned",
                      style: Theme.of(context).textTheme.headline3),
                  onPressed: () => onChanged!(PlaceCategory.planned)),
            ],
          ),
        ));
  }
}
