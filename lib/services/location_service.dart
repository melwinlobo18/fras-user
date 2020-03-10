import 'package:flutter/cupertino.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:ifrauser/constants/constants.dart';

class LocationService {
  static Future<void> fetchLocationFromGps(
      {TextEditingController locationController}) async {
    final geolocation = new GoogleMapsGeolocation(apiKey: googleMapsAPIKey);
    GeolocationResponse res;
    final geoCoding = new GoogleMapsGeocoding(apiKey: googleMapsAPIKey);
    GeocodingResponse response;

    res = await geolocation.getGeolocation(considerIp: false);

    if (res.isOkay) {
      print("Latitude: ${res.location.lat}");
      print("Longitude: ${res.location.lng}");
      print("Accuracy: ${res.location.toString()}");

      response = await geoCoding.searchByLocation(res.location);

      if (response.isOkay && response.results.isNotEmpty) {
        String address = response.results[0].formattedAddress;
        print(address);
        locationController.text = address;
      } else if (response.results.isEmpty) {
        locationController.text = '';
      } else {
        print(response.errorMessage);
      }
    } else {
      print(res.errorMessage);
    }
  }

  static Future<Location> fetchLocationFromAddress(
      {TextEditingController locationController}) async {
    Location location = Location(0, 0);
    final geoCoding = new GoogleMapsGeocoding(apiKey: googleMapsAPIKey);
    GeocodingResponse response =
        await geoCoding.searchByAddress(locationController.text);

    if (response.isOkay && response.results.isNotEmpty) {
      location = Location(response.results[0].geometry.location.lat,
          response.results[0].geometry.location.lng);
    } else {
      print(response.errorMessage);
    }

    return location;
  }
}
