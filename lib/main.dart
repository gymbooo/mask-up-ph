import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place/search_map_place.dart';

void main() => runApp(MyApp());





class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, title: 'Flutter', home: Homepage()
    );
  }
}

class Homepage extends StatefulWidget{
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>{
  GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: [
          /*  SearchMapPlaceWidget(
              hasClearButton: true,
              placeType: PlaceType.address,
              placeholder: 'Enter the location',
              apiKey: 'AIzaSyDmGhS77Xm9peRvlmiPYGF4vYOZQrV0ei0',
              onSelected: (Place place) async{
                Geolocation geolocation = await place.geolocation;
                mapController.animateCamera(
                  CameraUpdate.newLatLng(
                    geolocation.coordinates
                  )
                );
                mapController.animateCamera(
                  CameraUpdate.newLatLngBounds(geolocation.bounds, 0)
                );
              },
            ),*/

                SizedBox(
                  height: 500.0,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController googleMapController){
                      setState((){
                        mapController = googleMapController;
                      });
                    },
                    initialCameraPosition: CameraPosition(
                        zoom: 15.0,
                        target: LatLng(9.8969, 124.5307)
                    ),
                    mapType: MapType.satellite,
                  ),
                )
          ],
        ),
      ),
    );
  }
}
