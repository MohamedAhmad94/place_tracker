import 'package:flutter/material.dart';
import 'package:place_tracker/models/places_model.dart';
import 'package:place_tracker/widgets/category_button.dart';

class ListCategoryButtonBar extends StatelessWidget {
  final PlaceCategory? selectedCategory;
  final ValueChanged<PlaceCategory>? onCategoryChanged;

  const ListCategoryButtonBar({
    Key? key,
    @required this.selectedCategory,
    @required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CategoryButton(
          category: PlaceCategory.favorite,
          selected: selectedCategory == PlaceCategory.favorite,
          onCategoryChanged: onCategoryChanged,
        ),
        CategoryButton(
          category: PlaceCategory.visited,
          selected: selectedCategory == PlaceCategory.visited,
          onCategoryChanged: onCategoryChanged,
        ),
        CategoryButton(
          category: PlaceCategory.planned,
          selected: selectedCategory == PlaceCategory.planned,
          onCategoryChanged: onCategoryChanged,
        ),
      ],
    );
  }
}
