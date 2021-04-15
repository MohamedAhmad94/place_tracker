import 'package:flutter/material.dart';

class AddPlaceBar extends StatelessWidget {
  final bool? visible;
  final VoidCallback? onSavePressed;
  final VoidCallback? onCancelPressed;

  const AddPlaceBar(
      {Key? key,
      @required this.visible,
      @required this.onSavePressed,
      @required this.onCancelPressed})
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
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                child:
                    Text("Save", style: Theme.of(context).textTheme.headline2),
                onPressed: onSavePressed),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child:
                  Text("Cancel", style: Theme.of(context).textTheme.headline2),
              onPressed: onCancelPressed,
            ),
          ],
        ),
      ),
    );
  }
}
