import 'package:flutter/material.dart';
import 'package:adventures_app/functions/tripAdvisor_connect.dart';
import 'package:geolocator/geolocator.dart';

class Places extends StatefulWidget {
  const Places({super.key});

  @override
  State<Places> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  Future<Position> getCurrentLocation() async {
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();

    if (!locationEnabled) {
      return Future.error('El servicio de localización está desactivado');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('La localización fue negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'La localización fue negada para siempre, no podemos proveer recomendaciones');
    }

    return await Geolocator.getCurrentPosition();
  }

  String? location;
  String lat = '';
  String lng = '';

  void getPosition() async {
    Position position = await getCurrentLocation();
    setState(() {
      lat = '${position.latitude}';
      lng = '${position.longitude}';
    });
  }

  @override
  void initState() {
    getPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getNearbyLocations(lat, lng),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Error al cargar las localizaciones cercanas'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No se encontraron localizaciones cercanas'));
        } else {
          var locations = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: locations.length,
            itemBuilder: (context, index) {
              var location = locations[index];
              var locationName = location['name'] as String;
              var locationId = location['location_id'] as String;

              return FutureBuilder<List<String>>(
                future: getPhotosForLocation(locationId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error al cargar las fotos');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    String locationImg = snapshot.data![1];
                    return GestureDetector(
                      onTap: () {
                        // Aquí puedes implementar la navegación a una pantalla de detalles, por ejemplo
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(locationImg),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            locationName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
