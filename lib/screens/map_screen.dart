import 'package:adventures_app/screens/places_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:adventures_app/functions/tripAdvisor_connect.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final mapBox_token = 'pk.eyJ1IjoidGNyaXNzMjUiLCJhIjoiY2xsYjY1dm80MDNyczNxdDNzMDhveDhoOSJ9.0gLUekHFAbNPUGxONiFxlw';

  LatLng? location;
  var myPosition;
  List<dynamic>? places;

  void getPosition() async {
    Position position = await getCurrentLocation();
    setState(() {
      location = LatLng(position.latitude, position.longitude);
      myPosition = location;
    });
  }

  @override
  void initState(){
    getPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: location == null ? const CircularProgressIndicator() : FlutterMap(
        options:
          MapOptions(
            center: location,
            zoom: 15,
            maxZoom: 30,
            minZoom: 5
          ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accesToken}',
            additionalOptions: {
              'accesToken': mapBox_token,
              'id': 'mapbox/streets-v12'
            },
          ),
          CircleLayer(circles: [
            CircleMarker(
              point: myPosition, 
              radius: 100,
              color: Colors.blue,
              useRadiusInMeter: true,
            )
          ],)
        ],
      ),
    );
  }
}

Future<Position> getCurrentLocation() async {
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();

    if(!locationEnabled){
      return Future.error('El servicio de localización está desactivado');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('La localización fue negada');
      }
    }

    if(permission == LocationPermission.deniedForever){
        return Future.error('La localización fue negada para siempre, no podemos proveer recomendaciones');
    }

    return await Geolocator.getCurrentPosition();
  }