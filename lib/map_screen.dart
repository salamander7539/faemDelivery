import 'package:faem_delivery/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapScreen extends StatefulWidget {

  final lat;
  final lng;
  MapScreen(this.lat, this.lng);

  @override
  _MapScreenState createState() => _MapScreenState(lat, lng);
}

class _MapScreenState extends State<MapScreen> {

  final lat;
  final lng;
  _MapScreenState(this.lat, this.lng);

  @override
  Widget build(BuildContext context) {

    final Map point = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          Navigator.pop(context);
        },
        child: FlutterMap(
          options: new MapOptions(
            center: new LatLng(lat, lng),
            minZoom: 10.0,
          ),
          layers: [
            new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            new MarkerLayerOptions(
              markers: [
                new Marker(
                  width: 45.0,
                  height: 45.0,
                  point: new LatLng(lat, lng),
                  builder: (context) => new Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 45.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
