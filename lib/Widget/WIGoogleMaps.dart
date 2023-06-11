
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class WIGoogleMaps extends StatefulWidget{

  @override
  _WIGooleMapsState createState() => _WIGooleMapsState();
}

class _WIGooleMapsState extends State<WIGoogleMaps> {
  GoogleMapController? controllerMaps;



  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      //padding: EdgeInsets.only(top: 300),
      // mapType: MapType.normal,
      //  myLocationButtonEnabled: true,
     // myLocationEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      initialCameraPosition: CameraPosition(
          target: LatLng(-10.877628756313518, -61.95153213548445), zoom: 13.4746),
      onMapCreated: (GoogleMapController controller) {
        controllerMaps=controller;
        changeMapMode();
      },
    );
  }

  changeMapMode() {
    rootBundle.loadString('imagens/maps_styles/mapsdark.json').then((string) {
      setMapStyle(string);
    });
    //getJsonFile("imagens/maps_styles/mapsdark.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    controllerMaps!.setMapStyle(mapStyle);


  }
}