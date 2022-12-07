import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
                "Location"
            ),
            centerTitle: true,
          ),
          body: const MyLocationWidget(),
        )
    );
  }
}

class MyLocationWidget extends StatefulWidget {
  const MyLocationWidget({Key? key}) : super(key: key);

  @override
  State<MyLocationWidget> createState() => _MyLocationWidgetState();
}

class _MyLocationWidgetState extends State<MyLocationWidget> {
  final location = Location();
  String latitude = "";
  String longitude = "";
  LocationData? myLocationData;

  Future<bool> permissionGranted() async {
    // check if location service is enabled, else request
    bool serviceEnabled = false;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    // check if location permission is enabled, else request
    PermissionStatus permissionEnabled;
    permissionEnabled = await location.hasPermission();
    if (permissionEnabled == PermissionStatus.denied) {
      permissionEnabled = await location.requestPermission();
      if (permissionEnabled != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          bool goodToGo = await permissionGranted();
          if (goodToGo) {
            myLocationData = await location.getLocation();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                      "Your Location"
                  ),
                  content: Text(
                    '${myLocationData?.latitude} / ${myLocationData?.longitude}',
                  ),
                );
              }
            );
          }
        },
        child: RichText(
          text: const TextSpan(
            children: [
               TextSpan(
                text: "Get Your ",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.green,
                ),
              ),
              WidgetSpan(
                child: Icon(
                  Icons.location_pin,
                  size: 50,
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}

