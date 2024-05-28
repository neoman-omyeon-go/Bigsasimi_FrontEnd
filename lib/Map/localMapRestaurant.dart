import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class map extends StatefulWidget {
  const map({super.key});

  @override
  State<map> createState() => _MapPageState();
}

class _MapPageState extends State<map> {
  late NaverMapController _mapController;
  final Completer<NaverMapController> mapControllerCompleter = Completer();

  double latitude = 0;
  double longitude = 0;

  getGeoData() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitude = position.latitude;
    longitude = position.longitude;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }
    
    setState(() {
      latitude;
      longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    getGeoData();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final pixelRatio = mediaQuery.devicePixelRatio;
    final mapSize = Size(mediaQuery.size.width - 32, mediaQuery.size.height - 72);
    final physicalSize = Size(mapSize.width * pixelRatio, mapSize.height * pixelRatio);

    print("physicalSize: $physicalSize");
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 245, 235, 1.0),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              child: _naverMapSection(),
            ),
          ),
          Positioned(
            top: kToolbarHeight + 10,  // AppBar height + some padding
            left: 10,
            right: 10,
            child: Container(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintText: "Search Your location, restaurant...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(238, 245, 235, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMenuItem(Icons.home, "MyHome", () {
                        print("MyHome 버튼 클릭됨");
                      }),
                      _buildMenuItem(Icons.favorite, "MyPick", () {
                        print("MyPick 버튼 클릭됨");
                      }),
                      _buildMenuItem(Icons.eco, "GreenFood", () {
                        print("GreenFood 버튼 클릭됨");
                      }),
                      _buildMenuItem(Icons.emoji_emotions, "People's Pick", () {
                        print("People's Pick 버튼 클릭됨");
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _naverMapSection() => NaverMap(
    options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
            target: NLatLng(37.8854275477545, 127.734962063258),
            zoom: 15,
            bearing: 0,
            tilt: 0),
        indoorEnable: true,
        locationButtonEnable: false,
        consumeSymbolTapEvents: false),
    onMapReady: (controller) async {
      _mapController = controller;
      mapControllerCompleter.complete(controller);
      log("onMapReady", name: "onMapReady");
    },
  );

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 30, color: Color.fromRGBO(90,154,68,1.0)),
          onPressed: onPressed,
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 13,),
      ],
    );
  }
}
