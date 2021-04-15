import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_tracker/models/places_controller.dart';
import 'package:place_tracker/screens/place_list.dart';
import 'package:place_tracker/screens/place_map.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<PlacesController>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.pin_drop, size: 24.0),
        title: Text(
          'Place Tracker',
          style: Theme.of(context).textTheme.headline1,
        ),
        backgroundColor: Colors.green[700],
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
            child: IconButton(
                icon: Icon(
                    state.viewType == PlaceViewType.map
                        ? Icons.list
                        : Icons.map,
                    size: 30.0),
                onPressed: () {
                  state.setViewType(state.viewType == PlaceViewType.map
                      ? PlaceViewType.list
                      : PlaceViewType.map);
                }),
          )
        ],
      ),
      body: IndexedStack(
        index: state.viewType == PlaceViewType.map ? 0 : 1,
        children: [
          PlaceMap(center: const LatLng(30.033333, 31.233334)),
          PlaceList(),
        ],
      ),
    );
  }
}
