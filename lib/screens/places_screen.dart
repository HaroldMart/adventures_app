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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
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
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                mainAxisExtent: 250
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
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error al cargar la fotos');
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      String locationImg = snapshot.data![0];
                      return GestureDetector(
                        onTap: () {
                          // Aquí puedes implementar la navegación a una pantalla de detalles, por ejemplo
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [BoxShadow(
                              color: Colors.grey.withOpacity(0.2), //color of shadow
                              spreadRadius: 2, //spread radius
                              blurRadius: 10, // blur radius
                              offset: const Offset(0, 0),
                            ),
                          ]),
                          child: Column( children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                ),
                                child: Image.network(locationImg,
                                  height: 170,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text( locationName,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ]
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
      ),
    );
  }
}
