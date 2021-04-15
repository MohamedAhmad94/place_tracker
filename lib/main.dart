import 'package:flutter/material.dart';
import 'package:place_tracker/models/places_controller.dart';
import 'package:place_tracker/screens/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlacesController>(
            create: (_) => PlacesController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey[50],
            textTheme: TextTheme(
              headline1: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              headline2: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
              headline3: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w100),
            )),
      ),
    );
  }
}
