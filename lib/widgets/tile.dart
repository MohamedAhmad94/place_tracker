import 'package:flutter/material.dart';
import 'package:place_tracker/models/places_model.dart';
import 'package:place_tracker/screens/place_details.dart';

class Tile extends StatelessWidget {
  final Place? place;
  final ValueChanged<Place>? onPlaceChanged;

  const Tile({
    Key? key,
    @required this.place,
    @required this.onPlaceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push<void>(
        context,
        MaterialPageRoute(builder: (context) {
          return PlaceDetails(
            place: place,
            onChanged: (value) => onPlaceChanged!(value),
          );
        }),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              place!.name!,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              maxLines: 3,
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  size: 20.0,
                  color: Colors.amber,
                );
              }).toList(),
            ),
            Text(
              place!.description ?? '',
              style: TextStyle(color: Colors.black, fontSize: 20),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 15.0),
            Divider(
              height: 2.0,
              color: Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }
}
