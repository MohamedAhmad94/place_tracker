import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_tracker/models/places_model.dart';

class PlacesData {
  static const List<Place> places = [
    Place(
        id: '1',
        latLng: LatLng(29.95200814796391, 31.266479684184972),
        name: 'Desoky & Soda ',
        category: PlaceCategory.visited,
        description:
            'Experience the Fusion of Authentic Street Food and Electric Cocktails.',
        rating: 4.0),
    Place(
        id: '2',
        latLng: LatLng(30.064661433890866, 31.22079149997012),
        name: 'Buffalo Burger',
        category: PlaceCategory.favorite,
        description:
            'Buffalo Burger is a restaurant located in Egypt, serving a selection of Burgers.',
        rating: 4.6),
    Place(
        id: '3',
        latLng: LatLng(30.073671876847587, 31.34580819999488),
        name: 'City Stars',
        category: PlaceCategory.visited,
        description:
            'Citystars is a world-class fashion,retail and dinning destination in the heart of Cairo.',
        rating: 3.5),
    Place(
        id: '4',
        latLng: LatLng(30.04224828341041, 31.205235200006694),
        name: 'Derby Lounge',
        category: PlaceCategory.favorite,
        description:
            'Derby Lounge is a restaurant located in Egypt serving a selection of International dishes.',
        rating: 4.8),
    Place(
        id: '5',
        latLng: LatLng(29.95636315281908, 31.2618246472495),
        name: 'Braavos Lounge',
        category: PlaceCategory.visited,
        description:
            "A one-of-a-kind café and restaurant located in Maadi's legendary street 9.",
        rating: 4.0),
    Place(
        id: '6',
        latLng: LatLng(30.062252311937748, 31.219871462818073),
        name: 'Tivoli white',
        category: PlaceCategory.planned,
        description: 'Tivoli white is the new food court opened in Zamalek.',
        rating: 4.0),
    Place(
        id: '7',
        latLng: LatLng(30.051547837912644, 31.242906710536708),
        name: 'La poire Cafe',
        category: PlaceCategory.planned,
        description:
            'La Poire Cafe is a restaurant located in Egypt, serving a selection of Sandwiches.',
        rating: 4.3),
  ];

  static const reviews = <String>[
    'My favorite place in Egypt. The employees are wonderful and so is the food. I go here at least once a month!',
    'Staff was very friendly. Great atmosphere and good music. Would reccommend it.',
    'Best Place In Town.'
  ];
}
