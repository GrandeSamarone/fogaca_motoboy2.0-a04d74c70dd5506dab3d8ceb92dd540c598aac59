
import 'package:flutter/cupertino.dart';
import 'package:fogaca_app/Model/Endereco.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppData extends ChangeNotifier {
  Endereco ?localidade,latLgnEntrega;
  LatLng?endereco;

  void LatlngDados(Endereco endereco){

    localidade=endereco;
    notifyListeners();

  }
  void LatLngEntrega(Endereco dropOffendereco){

    latLgnEntrega=dropOffendereco;
    notifyListeners();

  }
}