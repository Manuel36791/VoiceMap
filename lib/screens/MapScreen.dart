import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/Database/MyDatabase.dart';
import 'package:flutter_map/Database/PlaceList.dart';
import 'package:flutter_map/services/TextToSpeech.dart';
import 'package:flutter_map/widget/menu.dart';
import 'package:location/location.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as map;
import 'package:flutter_mapbox_navigation/library.dart';

import '../services/TextToSpeech.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void _getPosition() async {
    bool isLocationServiceEnabled = await location.serviceEnabled();
    if (!isLocationServiceEnabled) {
      return flutterTts.speak('افتح خدمة تحديد الموقع');
    }
  }

  // GoogleMapController googleMapController;
  Location location = new Location();

  /*void _onMapCreated(GoogleMapController _controller) {
    googleMapController = _controller;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15)));
    });
  }

  Set<Marker> _markers = {};
  void _setMarker(double lat, double lng) {
    Marker newMarker = Marker(
      markerId: MarkerId(lat.toString()),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(lat, lng),
    );
    _markers.add(newMarker);
    setState(() {});
  }*/

  var items = [];
  PlaceList placeList;
  stt.SpeechToText _speech;
  final inputLang = TextEditingController();

  void listen() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      _speech.listen(
        onResult: (val) => setState(() {
          inputLang.text = val.recognizedWords;
          if (inputLang.text != null) {
            Future.delayed(Duration(seconds: 2), () {
              speak(inputLang.text);
            });
          }
        }),
      );
    } else {
      _speech.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    flutterTts.speak('مرحبا اين تريد ان تذهب');
    _getPosition();
    Future.delayed(Duration(seconds: 3), () {
      _speech = stt.SpeechToText();
      listen();
    });
    initialize();
  }

  double destinationLatitude;
  double destinationLongitude;
  double originLatitude;
  double originLongitude;

  void destination() async {
    if (inputLang.text != null) {
      MyDatabase().getRow(inputLang.text).then((value) {
        setState(() {
          items = value;
          placeList = PlaceList.fromMap(items[0]);
          destinationLatitude = placeList.userLat;
          destinationLongitude = placeList.userLng;
        });
      });
    }
    LocationData _locationData = await location.getLocation();
    setState(() {
      originLatitude = _locationData.latitude;
      originLatitude = _locationData.longitude;
    });
  }

  map.DirectionsMode directionsMode = map.DirectionsMode.walking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('map'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.directions),
        onPressed: () async {
          var wayPoints = <WayPoint>[];
          wayPoints.add(_origin);
          wayPoints.add(_stop1);

          await _directions.startNavigation(
              wayPoints: wayPoints,
              options: MapBoxOptions(
                  mode: MapBoxNavigationMode.drivingWithTraffic,
                  simulateRoute: false,
                  language: "en",
                  units: VoiceUnits.metric));
        },
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          /*GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(30.063549, 31.249667),
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: _onMapCreated,
          ),*/
          MapBoxNavigationView(
              options: _options,
              onRouteEvent: _onEmbeddedRouteEvent,
              onCreated: (MapBoxNavigationViewController controller) async {
                _controller = controller;
                controller.initialize();
              }),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                color: Colors.white,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      )),
                  controller: inputLang,
                ),
              ),
              FloatingActionButton(
                onPressed: listen,
                child: Icon(Icons.mic),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _instruction = "";
  final _origin = WayPoint(
      name: "Way Point 1",
      latitude: 38.9111117447887,
      longitude: -77.04012393951416);
  final _stop1 = WayPoint(
      name: "Way Point 2",
      latitude: 38.91113678979344,
      longitude: -77.03847169876099);

  MapBoxNavigation _directions;
  MapBoxOptions _options;

  bool _isMultipleStop = false;
  double _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;

  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
    _options = MapBoxOptions(
        //initialLatitude: 36.1175275,
        //initialLongitude: -115.1839524,
        zoom: 10.0,
        tilt: 0.0,
        bearing: 0.0,
        enableRefresh: false,
        alternatives: true,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        allowsUTurnAtWayPoints: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        units: VoiceUnits.imperial,
        simulateRoute: false,
        animateBuildRoute: true,
        longPressDestinationEnabled: true,
        language: "en");
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await _directions.distanceRemaining;
    _durationRemaining = await _directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null)
          _instruction = progressEvent.currentStepInstruction;
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}
