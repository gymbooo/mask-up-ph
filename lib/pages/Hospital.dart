import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:mask_up_ph/pages/MainDrawer.dart';
import 'package:mask_up_ph/widgets/consts.dart';
import 'package:geolocator/geolocator.dart';

class Hospital extends StatefulWidget {
  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  GoogleMapController mapController;
  Position currentPosition;
  var geoLocator = Geolocator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.mainAppBarColor),
      drawer: MainDrawer(),
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
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
                    height: 550.0,
                    child: GoogleMap(
                      myLocationButtonEnabled: true,
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
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
