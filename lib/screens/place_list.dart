import 'package:flutter/material.dart';
import 'package:place_tracker/models/places_controller.dart';
import 'package:provider/provider.dart';
import 'package:place_tracker/models/places_model.dart';
import 'package:place_tracker/widgets/list_category_button_bar.dart';
import 'package:place_tracker/widgets/tile.dart';

class PlaceList extends StatefulWidget {
  @override
  _PlaceListState createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  final ScrollController? _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<PlacesController>(context);

    return Column(
      children: [
        ListCategoryButtonBar(
          selectedCategory: state.selectedCategory,
          onCategoryChanged: (value) => _onCategoryChanged(value),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            controller: _scrollController,
            shrinkWrap: true,
            children: state.places!
                .where((place) => place.category == state.selectedCategory)
                .map((place) => Tile(
                      place: place,
                      onPlaceChanged: (value) => _onPlaceChanged(value),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  void _onCategoryChanged(PlaceCategory newCategory) {
    _scrollController!.jumpTo(0.0);
    Provider.of<PlacesController>(context, listen: false)
        .setSelectedCategory(newCategory);
  }

  void _onPlaceChanged(Place value) {
    final newPlaces = List<Place>.from(
        Provider.of<PlacesController>(context, listen: false).places!);
    final index = newPlaces.indexWhere((place) => place.id == value.id);
    newPlaces[index] = value;

    Provider.of<PlacesController>(context, listen: false).setPlaces(newPlaces);
  }
}
