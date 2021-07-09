import 'package:flutter/material.dart';
import 'package:flutter_map/widget/menu.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChooseOnMap extends StatefulWidget {
  @override
  _ChooseOnMapState createState() => _ChooseOnMapState();
}
class _ChooseOnMapState extends State<ChooseOnMap> {
  Set<Marker> markers;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers = Set.from([]);

  }
  LatLng position;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text('choose location'),),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            markers: markers,
            onTap: (pos) {
              Marker marker = Marker(markerId: MarkerId('1'),position: pos ,);
              setState(() {
                position = pos;
                markers.add(marker);
              });
            },
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(30.063549, 31.249667),
              zoom: 8,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              child: Text('save'),
              onPressed: () {
                _sendDataBack(context);
                },
            ),
          ),
        ],
      ),
    );
  }
  void _sendDataBack(BuildContext context) {
    var sendBack = position;
    Navigator.pop(context, sendBack);
  }
}
