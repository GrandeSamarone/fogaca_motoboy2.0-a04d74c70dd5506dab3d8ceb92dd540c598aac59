import 'dart:async';

import 'package:app_tutorial/app_tutorial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/api/Api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../Assistencia/SharedPreference.dart';
import '../../Interfaces/InterfaceLocalStorage.dart';
import 'order_view.dart';

abstract class OrderModel extends State<OrderView> {
  var isCollapsed = true;
  PanelController panelController = PanelController();

  GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();

  Position? position;
  late Pedido order;
  late Size size;
  GoogleMapController? mapController;
  var loadingMap = true;
  Map<MarkerId, Marker> markers = {};
  final Set<Polyline> polylines = Set();
  Timer? debounce;
  final ILocalStorage iLocalStorage = SharedPreference();
  final keybarrainferior = GlobalKey();
  final keyConversas = GlobalKey();
  final keyHistorico = GlobalKey();
  final keyPerfil = GlobalKey();
  final keybotao = GlobalKey();
  List<TutorialItems> itens = [];

  changeMapMode() {
    rootBundle.loadString('imagens/maps_styles/mapsdark.json').then((string) {
      mapController!.setMapStyle(string);
    });
  }



  init() async {
    TimeEsperaMapa();

    Future.delayed(Duration(milliseconds: 300), () {
      FirebaseFirestore.instance
          .collection(PEDIDOS)
          .doc(order.id_doc)
          .snapshots()
          .listen((event) {
        this.order = Pedido.fromFirestore(event.data()!);
        if (mounted) setState(() {});
      });
    });
  }

  addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  setMarkers() {
    var storePosition =
        LatLng(double.parse(order.lat_ponto), double.parse(order.long_ponto));
    var boyPosition = LatLng(position!.latitude, position!.longitude);
    var orderController = Provider.of<OrderController>(context, listen: false);
    print("SET MARKERS");
    ImageConfiguration imageConfiguration =
        createLocalImageConfiguration(context, size: Size(4, 4));
    BitmapDescriptor.fromAssetImage(
      imageConfiguration,
      "imagens/moto_decima.png",
    ).then((value) {
      addMarker(boyPosition, "Você", value);
    });

    imageConfiguration =
        createLocalImageConfiguration(context, size: Size(4, 4));
    BitmapDescriptor.fromAssetImage(imageConfiguration, "imagens/icon_shop.png")
        .then((value) {
      addMarker(storePosition, "cliente", value);
    });

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(
        getBounds(boyPosition, storePosition), 80));
    setState(() {});
  }

  setPolyline() {
    polylines.add(Polyline(
      polylineId: PolylineId("line 1"),
      visible: true,
      width: 2,
      geodesic: true,
      jointType: JointType.bevel,
      points: MapsCurvedLines.getPointsOnCurve(
          LatLng(position!.latitude, position!.longitude),
          LatLng(
              double.parse(order.lat_ponto),
              double.parse(
                  order.long_ponto))), // Invoke lib to get curved line points
      color: Colors.red,
    ));
  }

  TimeEsperaMapa() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(seconds: 1), () {
      loadingMap = false;
      getLocation();

      setState(() {});
    });
  }

  getLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      this.position = position;
      setMarkers();
      setPolyline();
    }).catchError((error) {
      print(error);
    });
  }

  LatLngBounds getBounds(LatLng from, LatLng to) {
    var southLat =
        from!.latitude <= to!.latitude ? from!.latitude : to!.latitude;
    var southLng =
        from!.longitude <= to!.longitude ? from!.longitude : to!.longitude;

    var northLat =
        from!.latitude >= to!.latitude ? from!.latitude : to!.latitude;
    var northLng =
        from!.longitude >= to!.longitude ? from!.longitude : to!.longitude;

    return LatLngBounds(
        southwest: LatLng(southLat, southLng),
        northeast: LatLng(northLat, northLng));
  }


}
