import 'package:flutter/material.dart';
import 'package:flutter_map/Database/MyDatabase.dart';
import 'package:flutter_map/Database/PlaceList.dart';
import 'package:flutter_map/widget/menu.dart';

class PlacesScreen extends StatefulWidget {
  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {

  MyDatabase mydatabase =MyDatabase();
  var places = [];

  @override
  void initState() {
    super.initState();
    MyDatabase().getAll().then((value) {
      setState(() {
        places = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Saved Places'),
      ),
      body: Center(
        child:  ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, i) {
                    PlaceList placeList = PlaceList.fromMap(places[i]);
                    return Card(
                      child: ListTile(
                        title: Text('${placeList.placeName}'),
                        subtitle:
                            Text('${placeList.userLat} , ${placeList.userLng}'),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              mydatabase.delete(placeList.placeName);
                            });
                          },
                        ),
                      ),
                    );
                  }),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('AddNewPlaceScreen');
        },
      ),
    );
  }
}
