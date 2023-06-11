import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/LocationController.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../api/Api.dart';

class UserController extends GetxController {
  List<String> cities = ['Selecione uma cidade'];
  User? user;
  StreamSubscription? stream;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ImagePicker _picker = ImagePicker();
  var serviceStatus = false;

  var status = -1;
  var avaiable = true;
  var isLogged = false;
  Motoboy? _motoboy;
  geo.Position? _posicao;
  bool _isConnected = true;

  Motoboy? get motoboy => _motoboy;
  geo.Position? get posicao => _posicao;
  bool get connected => _isConnected;

  setStatus(s) {
    status = s;
    update();
  }

  UserController() {
    init();
  }

  init() async {
    user = FirebaseAuth.instance.currentUser;
    listenUserData();
    getCities();
    listenSession();
    lastView();
   Position();

    SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()
      ..setLookUpAddress(
          'google.com'); //Optional method to pass the lookup string
    _simpleConnectionChecker.onConnectionChange.listen((connected) async {
      print("CONNECTIONINTERNET TESTANDO");
      try {
        HttpClient c = HttpClient();
        c.connectionTimeout = Duration(seconds: 2);

        var request = await c.getUrl(Uri.parse("http://pub.dev"));
        var result = await request.close();
        _isConnected = result.statusCode == 200;
        print("CONNECTIONINTERNET ${_isConnected}");
      } catch (e) {
        print("CONNECTIONINTERNET ${e.toString()}");
        _isConnected = false;
      }

      listenUserData();
    });
  }

  void getCities() async {
    var result = await FirebaseFirestore.instance.collection('cidades').get();
    cities.clear();
    result.docs.forEach((element) {
      cities.add(element.data()['cidade']);
    });
    update();
  }

  void lastView() {
    DateTime now = DateTime.now();
    Map<String, dynamic> atualizardata = {
      "ultvisualizacao": now.toUtc(),
    };

    if (user != null)
      firestore.collection("user_motoboy").doc(user!.uid).update(atualizardata);
  }

  listenUserData() {
    if (stream != null) stream!.cancel();
    stream = FirebaseFirestore.instance
        .collection('user_motoboy')
        .doc(user!.uid)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        try {
          _motoboy = Motoboy.fromFirestore(doc.data()!);

          avaiable = _motoboy!.avaiable;
         print("ONLINEEEEEEE::::");
         print(_motoboy!.nome);
         print(_motoboy!.permissao);

        } catch (e) {
          // checkStatusService();
        }
      }

      update();
    });
  }

  void checkStatusUser(context) {
    if (motoboy != null && !motoboy!.permissao ) {
      Future.delayed(Duration(milliseconds: 300),
          () => Navigator.of(context).pushNamed("block_screen"));
    }else{
      print("MOTOBOY NULLO::::");
    }

  }

  listenSession() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        user = user;
      } else {
        isLogged = false;
      }
      update();
    });
  }

  setAvaiable(bool mode, context) async {
    await Provider.of<LocationController>(context, listen: false).enableGps();
    if (Provider.of<LocationController>(context, listen: false).gpsEnabled)
      FirebaseFirestore.instance
          .collection("user_motoboy")
          .doc(user!.uid)
          .update({"avaiable": mode});
    else
      ToastMensagem("Ative o GPS", context);
  }

  Position() async {

      _posicao = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("position");
      print(_posicao!.latitude.toString());
      print(_posicao!.longitude.toString());


  }

  void checkConnection() async {
    try {
      var response = await get(Uri.parse(await Api.Host() + "/teste"), headers: {
        "authorization":
            await FirebaseAuth.instance.currentUser!.getIdToken(true),
        "type": "1"
      });
      if (response.statusCode == 200) {
        Get.showSnackbar(GetSnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          messageText: Text(
            "Você esta conectado e receberá um pedido teste",
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else
        throw new Error();
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
        messageText: Text(
          "Há algo errado com sua conexão, fique offline e online novamente",
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
  }


}
