import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = 'A085720DB77A484F90FA58854D49B6C0';

Future<List<Map<String, dynamic>>> getNearbyLocations(lat, lng) async {

  var apiUrl = 'https://api.content.tripadvisor.com/api/v1/location/nearby_search?latLong=$lat%2C%20$lng&key=$apiKey&language=es';

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'}
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final nearbyLocations = data['data'] as List<dynamic>;

    return nearbyLocations.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Error al obtener las localizaciones cercanas error ${response.statusCode}');
  }
}

Future<List<String>> getPhotosForLocation(String locationId) async {

  final apiUrl = 'https://api.content.tripadvisor.com/api/v1/location/$locationId/photos?key=$apiKey&language=es';

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final photos = data['data'] as List<dynamic>;

    return photos.map((photo) => photo['images']['original']['url'] as String).toList();
  } else {
    throw Exception('Error al obtener las fotos');
  }
}

