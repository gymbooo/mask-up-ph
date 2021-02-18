import 'package:flutter/material.dart';
import 'package:flutterauth0/widgets/custom_appbar_widget.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';

class Hospital extends StatefulWidget {
  @override
  _HospitalState createState() => _HospitalState();
}

class _HospitalState extends State<Hospital> {
  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      body: Container(
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
                  height: 400.0,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController googleMapController) {
                      setState(() {
                        mapController = googleMapController;
                      });
                    },
                    initialCameraPosition: CameraPosition(
                        zoom: 15.0, target: LatLng(9.8969, 124.5307)),
                    mapType: MapType.normal,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
