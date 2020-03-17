import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:ifrauser/constants/constants.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

class LocationService {
  static Future<String> fetchLocationFromGps(
      {TextEditingController locationController}) async {
    final geoCoding = new GoogleMapsGeocoding(apiKey: googleMapsAPIKey);
    GeocodingResponse response;
    String city;

    html.Navigator navigator = html.window.navigator;
    await navigator.geolocation
        .getCurrentPosition(enableHighAccuracy: true)
        .then((value) async {
      response = await geoCoding.searchByLocation(
          Location(value.coords.latitude, value.coords.longitude));

      if (response.isOkay && response.results.isNotEmpty) {
        String address = response.results[0].formattedAddress;
        response.results[0].addressComponents.forEach((component) {
          if (component.types.contains('administrative_area_level_2'))
            city = component.longName;
        });
        print(address);
        locationController?.text = address;
      } else if (response.results.isEmpty) {
        locationController?.text = '';
      } else {
        print(response.errorMessage);
      }
    }).catchError((_) => BotToast.showSimpleNotification(
            title: "Error while accessing device location"));

    return city;
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
