import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:mask_up_ph/pages/MainDrawer.dart';
import 'package:mask_up_ph/widgets/consts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

//TODO: try bottom pop up w/ loc info on marker tap (info also on json)
//TODO: test w/ diff location via search - need ata ng new endpoint

class Hospital extends StatefulWidget {
  @override
  _HospitalState createState() => _HospitalState();
}

class MapData {
  List<dynamic> html_attributions;
  String next_page_token;
  List<dynamic> results;
  String status;

  MapData(
      this.html_attributions, this.next_page_token, this.results, this.status);
}

class _HospitalState extends State<Hospital> {
  final String url =
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=covid+test&key=AIzaSyDmGhS77Xm9peRvlmiPYGF4vYOZQrV0ei0';
  MapData mapData;
  List<dynamic> html_attributions;
  String next_page_token;
  List<dynamic> results;
  String status;
  List<dynamic> listOfResults = [];
  Set<Marker> setOfMarkers = {};

  GoogleMapController mapController;
  Position currentPosition;
  var geoLocator = Geolocator();

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      html_attributions = convertDataToJson['html_attributions'];
      next_page_token = convertDataToJson['next_page_token'];
      results = convertDataToJson['results'];
      status = convertDataToJson['status'];

      mapData = MapData(html_attributions, next_page_token, results, status);

      for (var i = 0; i < results.length - 1; i++) {
        listOfResults.add(results[i]);
        setOfMarkers.add(Marker(
            markerId: MarkerId(listOfResults[i]['name']),
            position: LatLng(listOfResults[i]['geometry']['location']['lat'],
                listOfResults[i]['geometry']['location']['lng']),
            infoWindow: InfoWindow(
                title: listOfResults[i]['name'],
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Text(listOfResults[i]['formatted_address']);
                      });
                }),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet)));
      }

      print('set of markers $setOfMarkers');
      print('lor $listOfResults');
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SearchMapPlaceWidget(
              hasClearButton: true,
              placeType: PlaceType.address,
              placeholder: 'Enter the location',
              apiKey: 'AIzaSyDmGhS77Xm9peRvlmiPYGF4vYOZQrV0ei0',
              onSelected: (Place place) async {
                Geolocation geolocation = await place.geolocation;
                mapController.animateCamera(
                    CameraUpdate.newLatLng(geolocation.coordinates));
                mapController.animateCamera(
                    CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
              },
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: SizedBox(
                  height: 400,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    onMapCreated:
                        (GoogleMapController googleMapController) async {
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.best);
                      currentPosition = position;

                      setState(() {
                        mapController = googleMapController;
                        CameraPosition cameraPosition = new CameraPosition(
                            zoom: 15.0,
                            target: LatLng(currentPosition.latitude,
                                currentPosition.longitude));
                        googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(cameraPosition));
                      });
                    },
                    initialCameraPosition: CameraPosition(
                        zoom: 6, target: LatLng(12.8797, 121.7740)),
                    mapType: MapType.normal,
                    markers: setOfMarkers,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
