import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  LatLng? location;

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

  void getPosition() async {
    Position position = await getCurrentLocation();
    setState(() {
      location = LatLng(position.latitude, position.longitude);
      print('tu localizacion es: ${location}');
    });
  }

  @override
  void initState(){
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlutterMap(
        options:
          MapOptions(
            center: location,
            zoom: 15,
            maxZoom: 25,
            minZoom: 5
          ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          )
        ],
      ),
    );
  }
}