import 'package:flutter/material.dart';
import 'package:place_tracker/models/places_model.dart';

class CategoryButton extends StatelessWidget {
  final PlaceCategory? category;
  final bool? selected;
  final ValueChanged<PlaceCategory>? onCategoryChanged;
  const CategoryButton({
    Key? key,
    @required this.category,
    @required this.selected,
    @required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _buttonText;
    switch (category) {
      case PlaceCategory.favorite:
        _buttonText = 'Favorites';
        break;
      case PlaceCategory.visited:
        _buttonText = 'Visited';
        break;
      case PlaceCategory.planned:
        _buttonText = 'Planned';
        break;
      default:
        _buttonText = '';
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: selected! ? Colors.blue : Colors.transparent,
          ),
        ),
      ),
      child: ButtonTheme(
        height: 35.0,
        child: TextButton(
          child: Text(
            _buttonText,
            style: TextStyle(
              fontSize: selected! ? 20.0 : 18.0,
              color: selected! ? Colors.blue : Colors.black87,
            ),
          ),
          onPressed: () => onCategoryChanged!(category!),
        ),
      ),
    );
  }
}
