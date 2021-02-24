import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:mask_up_ph/pages/MainDrawer.dart';
import 'package:mask_up_ph/widgets/consts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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
  List<String> listOfPhotos = [];

  GoogleMapController mapController;
  Position currentPosition;
  var geoLocator = Geolocator();

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  String checkIfOpen(i) {
    String status;
    if (listOfResults[i]['opening_hours'] == null) {
      status = '';
    } else if (listOfResults[i]['opening_hours']['open_now'] == false) {
      status = 'Closed Now';
    } else if (listOfResults[i]['opening_hours']['open_now'] == true) {
      status = 'Open Now';
    } else {
      status = '';
    }
    return status;
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
                        return Container(
                          color: Colors.transparent,
                          height: 200,
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: Colors.purple[50],
                                contentPadding: EdgeInsets.all(10),
                                leading: (listOfResults[i]['photos'] == null)
                                    ? Image.asset(
                                        'lib/assets/images/hospital.png')
                                    : Image.network(
                                        'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${listOfResults[i]['photos'][0]['photo_reference']}&key=AIzaSyDmGhS77Xm9peRvlmiPYGF4vYOZQrV0ei0'),
                                title: Text(listOfResults[i]['name'],
                                    style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                subtitle:
                                    Text(listOfResults[i]['formatted_address'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        )),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: (checkIfOpen(i).toString() ==
                                            'Open now')
                                        ? Text(checkIfOpen(i),
                                            style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.red))
                                        : Text(checkIfOpen(i),
                                            style: GoogleFonts.montserrat(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.green)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: (listOfResults[i]['rating'] == 0)
                                        ? Text('')
                                        : Text(
                                            'User Rating: ' +
                                                listOfResults[i]['rating']
                                                    .toString() +
                                                '/5',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
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

                //TODO: implement nearby search from location entered in search bar
              },
            ),
            Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .65,
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
                            zoom: 12.0,
                            target: LatLng(currentPosition.latitude,
                                currentPosition.longitude));
                        googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(cameraPosition));
                      });
                    },
                    initialCameraPosition: CameraPosition(
                        zoom: 8, target: LatLng(12.8797, 121.7740)),
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
