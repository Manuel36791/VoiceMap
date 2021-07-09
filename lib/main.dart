import 'package:flutter/material.dart';
import 'package:flutter_map/Database/MyDatabase.dart';
import 'package:flutter_map/screens/PlacesScreen.dart';
import 'package:flutter_map/screens/AddNewPlaceScreen.dart';
import 'screens/ChooseOnMapScreen.dart';
import 'screens/MapScreen.dart';
import 'widget/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MyDatabase myDatabase = MyDatabase();
  await myDatabase.database();
  runApp(MyApp());
}

//api key = AIzaSyALjjwZbWSzttJvYm6QinIn-o9xTV1l2QY
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myThemeData,
      initialRoute: 'MapScreen',
      routes: {
        'MapScreen': (context) => MapScreen(),
        'PlacesScreen': (context) => PlacesScreen(),
        'AddNewPlaceScreen': (context) => AddNewPlaceScreen(),
        'ChooseOnMapScreen': (context) => ChooseOnMap(),
      },
    );
  }
}
