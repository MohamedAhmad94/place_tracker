import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_tracker/models/places_controller.dart';
import 'package:place_tracker/models/places_model.dart';
import 'package:place_tracker/screens/place_details.dart';
import 'package:place_tracker/widgets/add_place_button_bar.dart';
import 'package:place_tracker/widgets/category_button_bar.dart';
import 'package:place_tracker/widgets/map_fabs.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class PlaceMap extends StatefulWidget {
  final LatLng? center;

  const PlaceMap({Key? key, this.center}) : super(key: key);

  @override
  _PlaceMapState createState() => _PlaceMapState();
}

class _PlaceMapState extends State<PlaceMap> {
  Completer<GoogleMapController>? mapController = Completer();

  MapType? _currentMapType = MapType.normal;

  LatLng? _lastMapPosition;

  final Map<Marker, Place>? _markedPlaces = <Marker, Place>{};

  final Set<Marker>? _markers = {};

  Marker? _pendingMarker;

  MapConfig? _config;

  @override
  Widget build(BuildContext context) {
    _updateMapConfig();
    var state = Provider.of<PlacesController>(context);
    return Builder(builder: (context) {
      return Center(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.center!,
                zoom: 10.0,
              ),
              mapType: _currentMapType!,
              markers: _markers!,
              onCameraMove: (position) => _lastMapPosition = position.target,
            ),
            CategoryBar(
              selectedPlaceCategory: state.selectedCategory,
              visible: _pendingMarker == null,
              onChanged: _switchSelectedCategory,
            ),
            AddPlaceBar(
              visible: _pendingMarker != null,
              onSavePressed: () => _confirmAddPlace(context),
              onCancelPressed: _cancelAddPlace,
            ),
            MapFabs(
              visible: _pendingMarker == null,
              onAddPlacePressed: _onAddPlacePressed,
              onToggleMapTypePressed: _onToggleMapTypePressed,
            ),
          ],
        ),
      );
    });
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapController!.complete(controller);
    _lastMapPosition = widget.center;

    var markers = <Marker>{};
    for (var place
        in Provider.of<PlacesController>(context, listen: false).places!) {
      markers.add(await _createPlaceMarker(context, place));
    }

    setState(() {
      _markers!.addAll(markers);
    });

    _zoomtoFitSelectedCategory();
  }

  @override
  void didUpdateWidget(PlaceMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      _zoomtoFitSelectedCategory();
    }
  }

  void _zoomtoFitSelectedCategory() {
    _zoomToFitPlaces(
      _getPlacesForCategory(
        Provider.of<PlacesController>(context, listen: false).selectedCategory!,
        _markedPlaces!.values.toList(),
      ),
    );
  }

  void _cancelAddPlace() {
    if (_pendingMarker != null) {
      setState(() {
        _markers!.remove(_pendingMarker);
        _pendingMarker = null;
      });
    }
  }

  Future<void> _confirmAddPlace(BuildContext context) async {
    if (_pendingMarker != null) {
      final newPlace = Place(
          id: Uuid().v1(),
          latLng: _pendingMarker!.position,
          name: _pendingMarker!.infoWindow.title,
          category: Provider.of<PlacesController>(context, listen: false)
              .selectedCategory);
      var placeMraker = await _getPlaceMarkerIcon(
          context,
          Provider.of<PlacesController>(context, listen: false)
              .selectedCategory!);

      setState(() {
        final updatedMarker = _pendingMarker!.copyWith(
          iconParam: placeMraker,
          infoWindowParam: InfoWindow(
            title: 'New Place',
            snippet: null,
            onTap: () => _pushPlaceDetailsScreen(newPlace),
          ),
          draggableParam: false,
        );
        _updateMarker(
          marker: _pendingMarker,
          updatedMarker: updatedMarker,
          place: newPlace,
        );
        _pendingMarker = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
          "New Place Added",
          style: TextStyle(fontSize: 16.0),
        ),
        action: SnackBarAction(
          label: "Edit",
          onPressed: () async {
            _pushPlaceDetailsScreen(newPlace);
          },
        ),
      ));
      final newPlaces = List<Place>.from(
          Provider.of<PlacesController>(context, listen: false).places!)
        ..add(newPlace);
      _config = MapConfig(
        places: newPlaces,
        selectedCategory: Provider.of<PlacesController>(context, listen: false)
            .selectedCategory,
      );
      Provider.of<PlacesController>(context, listen: false)
          .setPlaces(newPlaces);
    }
  }

  Future<Marker> _createPlaceMarker(BuildContext context, Place place) async {
    final marker = Marker(
      markerId: MarkerId(place.latLng.toString()),
      position: place.latLng!,
      infoWindow: InfoWindow(
        title: place.name,
        snippet: '${place.rating} Rating',
        onTap: () => _pushPlaceDetailsScreen(place),
      ),
      icon: await _getPlaceMarkerIcon(context, place.category!),
      visible: place.category ==
          Provider.of<PlacesController>(context, listen: false)
              .selectedCategory,
    );
    _markedPlaces![marker] = place;
    return marker;
  }

  Future<void> _updateMapConfig() async {
    _config ??=
        MapConfig.of(Provider.of<PlacesController>(context, listen: false));
    final newConfig =
        MapConfig.of(Provider.of<PlacesController>(context, listen: false));
    if (_config != newConfig && mapController != null) {
      if (_config!.places == newConfig.places &&
          _config!.selectedCategory != newConfig.selectedCategory) {
        await _showPlacesForSelectedCategory(newConfig.selectedCategory!);
      } else {
        newConfig.places!
            .where((p) => !_config!.places!.contains(p))
            .map((value) => _updateExistingPlaceMarker(place: value));
        await _zoomToFitPlaces(
          _getPlacesForCategory(newConfig.selectedCategory!, newConfig.places!),
        );
      }
      _config = newConfig;
    }
  }

  Future<void> _onAddPlacePressed() async {
    setState(() {
      final newMarker = Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition!,
        infoWindow: InfoWindow(title: "New Place"),
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      _markers!.add(newMarker);
      _pendingMarker = newMarker;
    });
  }

  void _onPlaceChanged(Place value) {
    final newPlaces = List<Place>.from(
        Provider.of<PlacesController>(context, listen: false).places!);
    final index = newPlaces.indexWhere((place) => place.id == value.id);
    newPlaces[index] = value;
    _updateExistingPlaceMarker(place: value);

    _config = MapConfig(
      places: newPlaces,
      selectedCategory: Provider.of<PlacesController>(context, listen: false)
          .selectedCategory,
    );
    Provider.of<PlacesController>(context, listen: false).setPlaces(newPlaces);
  }

  void _onToggleMapTypePressed() {
    final nextType =
        MapType.values[(_currentMapType!.index + 1) % MapType.values.length];
    setState(() {
      _currentMapType = nextType;
    });
  }

  void _pushPlaceDetailsScreen(Place place) {
    Navigator.push<void>(
        context,
        MaterialPageRoute(
            builder: (_) => PlaceDetails(
                  place: place,
                  onChanged: (value) => _onPlaceChanged(value),
                )));
  }

  Future<void> _showPlacesForSelectedCategory(PlaceCategory category) async {
    setState(() {
      for (var marker in List.of(_markedPlaces!.keys)) {
        final place = _markedPlaces![marker];
        final updatedMarker = marker.copyWith(
          visibleParam: place!.category == category,
        );
        _updateMarker(
          marker: marker,
          updatedMarker: updatedMarker,
          place: place,
        );
      }
    });

    await _zoomToFitPlaces(_getPlacesForCategory(
      category,
      _markedPlaces!.values.toList(),
    ));
  }

  Future<void> _switchSelectedCategory(PlaceCategory category) async {
    Provider.of<PlacesController>(context, listen: false)
        .setSelectedCategory(category);
    await _showPlacesForSelectedCategory(category);
  }

  void _updateExistingPlaceMarker({@required Place? place}) {
    var marker = _markedPlaces!.keys
        .singleWhere((value) => _markedPlaces![value]!.id == place!.id);

    setState(() {
      final updatedMarker = marker.copyWith(
        infoWindowParam: InfoWindow(
          title: place!.name,
          snippet: place.rating != 0 ? '${place.rating} Rating' : null,
        ),
      );
      _updateMarker(marker: marker, updatedMarker: updatedMarker, place: place);
    });
  }

  void _updateMarker({
    @required Marker? marker,
    @required Marker? updatedMarker,
    @required Place? place,
  }) {
    _markers!.remove(marker);
    _markedPlaces!.remove(marker);

    _markers!.add(updatedMarker!);
    _markedPlaces![updatedMarker] = place!;
  }

  Future<void> _zoomToFitPlaces(List<Place> places) async {
    var controller = await mapController!.future;

    var minLat = widget.center!.latitude;
    var maxLat = widget.center!.latitude;
    var minLong = widget.center!.longitude;
    var maxLong = widget.center!.longitude;

    for (var place in places) {
      minLat = min(minLat, place.latitude);
      maxLat = max(maxLat, place.latitude);
      minLong = min(minLong, place.longitude);
      maxLong = max(maxLong, place.longitude);
    }

    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLong),
          northeast: LatLng(maxLat, maxLong),
        ),
        35.0,
      ),
    );
  }

  static Future<BitmapDescriptor> _getPlaceMarkerIcon(
      BuildContext context, PlaceCategory category) async {
    switch (category) {
      case PlaceCategory.favorite:
        return BitmapDescriptor.fromAssetImage(
            createLocalImageConfiguration(context, size: Size.square(30.0)),
            'assets/images/heart.png');

      case PlaceCategory.visited:
        return BitmapDescriptor.fromAssetImage(
            createLocalImageConfiguration(context, size: Size.square(30.0)),
            'assets/images/visited.png');

      case PlaceCategory.planned:
        return BitmapDescriptor.defaultMarker;
    }
  }

  static List<Place> _getPlacesForCategory(
      PlaceCategory category, List<Place> places) {
    return places.where((place) => place.category == category).toList();
  }
}

class MapConfig {
  final List<Place>? places;
  final PlaceCategory? selectedCategory;

  const MapConfig({this.places, this.selectedCategory});

  @override
  int get hashCode => places.hashCode ^ selectedCategory.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapConfig &&
        other.places == places &&
        other.selectedCategory == selectedCategory;
  }

  static MapConfig of(PlacesController placesState) {
    return MapConfig(
      places: placesState.places,
      selectedCategory: placesState.selectedCategory,
    );
  }
}
