import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Container(
        margin: EdgeInsets.only(top: 80),
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            Card(
              color: Theme.of(context).accentColor,
              elevation: 5,
              child: ListTile(
                title: Text('Map Screen'),
                onTap: (){
                  Navigator.of(context).pushNamed('MapScreen');
                },
              ),
            ),
            Divider(height: 10,),
            Card(
              color: Theme.of(context).accentColor,
              elevation: 5,
              child: ListTile(
                title: Text('Place Screen'),
                onTap: (){
                  Navigator.of(context).pushNamed('PlacesScreen');
                },
              ),
            ),
            Divider(height: 10,),
            Card(
              color: Theme.of(context).accentColor,
              elevation: 5,
              child: ListTile(
                title: Text('add new place Screen'),
                onTap: (){
                  Navigator.of(context).pushNamed('AddNewPlaceScreen');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
