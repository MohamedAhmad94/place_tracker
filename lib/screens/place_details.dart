import 'package:flutter/material.dart';
import 'package:place_tracker/models/places_model.dart';
import 'package:place_tracker/models/places_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetails extends StatefulWidget {
  final Place? place;
  final ValueChanged<Place>? onChanged;

  const PlaceDetails({
    Key? key,
    @required this.place,
    @required this.onChanged,
  }) : super(key: key);
  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  Place? _place;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  TextEditingController? _nameController = TextEditingController();
  TextEditingController? _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_place!.name}',
            style: Theme.of(context).textTheme.headline1),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.green[700],
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.8, 0.0),
            child: IconButton(
              icon: Icon(Icons.save, size: 30),
              onPressed: () {
                widget.onChanged!(_place!);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: detailsBody(),
      ),
    );
  }

  @override
  void initState() {
    _place = widget.place;
    _nameController!.text = _place!.name!;
    _descriptionController!.text = _place!.description!;
    return super.initState();
  }

  Widget detailsBody() {
    return ListView(
      padding: EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
      children: [
        NameField(
            controller: _nameController,
            onChanged: (value) {
              setState(() {
                _place = _place!.copyWith(name: value);
              });
            }),
        DescriptionField(
            controller: _descriptionController,
            onChanged: (value) {
              setState(() {
                _place = _place!.copyWith(description: value);
              });
            }),
        RatingBar(
            rating: _place!.rating,
            onChanged: (value) {
              setState(() {
                _place = _place!.copyWith(rating: value);
              });
            }),
        _Map(
          center: _place!.latLng,
          mapController: _mapController,
          onMapCreated: _onMapCreated,
          markers: _markers,
        ),
        Reviews(),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_place!.latLng.toString()),
        position: _place!.latLng!,
      ));
    });
  }
}

class NameField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const NameField(
      {Key? key, @required this.controller, @required this.onChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.grey, width: 0.5),
          ),
          labelText: "Place Name",
          labelStyle: TextStyle(fontSize: 15.0),
        ),
        style: TextStyle(fontSize: 20, color: Colors.black87),
        autocorrect: true,
        controller: controller,
        onChanged: (value) {
          onChanged!(value);
        },
      ),
    );
  }
}

class DescriptionField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const DescriptionField(
      {Key? key, @required this.controller, @required this.onChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.grey, width: 0.5),
          ),
          labelText: "Description",
          labelStyle: TextStyle(fontSize: 15.0),
        ),
        style: TextStyle(fontSize: 20, color: Colors.black87),
        maxLength: null,
        controller: controller,
        onChanged: (value) {
          onChanged!(value);
        },
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  static const int maxStars = 5;
  final double? rating;
  final ValueChanged<double>? onChanged;

  const RatingBar({Key? key, @required this.rating, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxStars, (index) {
        return IconButton(
          icon: const Icon(Icons.star),
          iconSize: 30,
          color: rating! > index ? Colors.amber : Colors.grey[400],
          onPressed: () {
            onChanged!(index + 1);
          },
        );
      }).toList(),
    );
  }
}

class _Map extends StatelessWidget {
  final LatLng? center;
  final GoogleMapController? mapController;
  final ArgumentCallback<GoogleMapController>? onMapCreated;
  final Set<Marker>? markers;

  const _Map(
      {Key? key,
      @required this.center,
      @required this.mapController,
      @required this.onMapCreated,
      @required this.markers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      elevation: 4.0,
      child: SizedBox(
        width: 300,
        height: 200,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: center!, zoom: 16),
          onMapCreated: onMapCreated,
          markers: markers!,
          zoomControlsEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          scrollGesturesEnabled: false,
        ),
      ),
    );
  }
}

class Reviews extends StatelessWidget {
  const Reviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Reviews',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        Column(
          children: PlacesData.reviews
              .map((reviewText) => singleReview(reviewText))
              .toList(),
        )
      ],
    );
  }

  Widget singleReview(String reviewText) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 3.0,
                    color: Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '5',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 30,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  reviewText,
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 8,
          color: Colors.grey[700],
        ),
      ],
    );
  }
}
