import 'package:flutter/material.dart';

class MapFabs extends StatelessWidget {
  final bool? visible;
  final VoidCallback? onAddPlacePressed;
  final VoidCallback? onToggleMapTypePressed;

  const MapFabs(
      {Key? key,
      @required this.visible,
      this.onAddPlacePressed,
      this.onToggleMapTypePressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 12.0, right: 12.0),
      child: Visibility(
        visible: visible!,
        child: Column(
          children: [
            FloatingActionButton(
              heroTag: "add_place_button",
              onPressed: onAddPlacePressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.add_location,
                size: 30,
              ),
            ),
            SizedBox(height: 12.0),
            FloatingActionButton(
              heroTag: "toggle_map_type_button",
              onPressed: onToggleMapTypePressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              mini: true,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.layers,
                size: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}
