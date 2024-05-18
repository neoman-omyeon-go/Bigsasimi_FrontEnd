import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';


class map extends StatefulWidget {
  const map({super.key});

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
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
    final mapSize =
    Size(mediaQuery.size.width - 32, mediaQuery.size.height - 72);
    final physicalSize =
    Size(mapSize.width * pixelRatio, mapSize.height * pixelRatio);

    print("physicalSize: $physicalSize");
    return Scaffold(
      backgroundColor: const Color(0xFF343945),
      body: Center(
          child: SizedBox(
              // width: mapSize.width,
              // height: mapSize.height,
              // color: Colors.greenAccent,
              child: _naverMapSection()
          )
      ),
    );
  }

  Widget _naverMapSection() =>
      NaverMap(
        options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
            target: NLatLng(37.8854275477545, 127.734962063258),
            zoom: 15,
            bearing: 0,
            tilt: 0
        ),
        indoorEnable: true,
        locationButtonEnable: false,
        consumeSymbolTapEvents: false
        ),
    onMapReady: (controller) async {
      _mapController = controller;
      mapControllerCompleter.complete(controller);
      log("onMapReady", name: "onMapReady");
    },
  );
}

