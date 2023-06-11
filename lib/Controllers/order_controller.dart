import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:fogaca_app/api/Api.dart';
import 'package:fogaca_app/utils/Utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class OrderController extends ChangeNotifier {
  bool loadingMap = true;
  var auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> orderList = [];
  List<Map<String, dynamic>> ListPendency = [];
  List<Map<String, dynamic>> filteredOrderList = [];
  List<Map<String, dynamic>> orderListChamada = [];
  var selectedFilter = 0;
  var initialDate = DateTime.now();
  var endDate = DateTime.now();

  StreamSubscription? pendencyStream;
  StreamSubscription? historyStream;
  StreamSubscription? chamadasStream;

  List<Map<String, dynamic>> get activeOrders => orderList
      .where((element) =>
  element['situacao_id'] == CONCLUIDO
  ).toList();

  OrderController() {
    init();
    getDatesFilter();
  }

  init() {
    listenchamadas();
    listenPendency();
    listenHistory();
  }
  void listenHistory() async {
    DateTime _now = DateTime.now();
    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    print("listenHistory");
    print(auth.currentUser!.uid);

    if (historyStream != null) historyStream!.cancel();
    orderList.clear();
    notifyListeners();
    historyStream=FirebaseFirestore.instance
        .collection(PEDIDOS)
        .where("boy_id", isEqualTo: auth.currentUser!.uid)
        .where('createdAt', isGreaterThanOrEqualTo: _start)
        .where('createdAt', isLessThanOrEqualTo: _end)
        .orderBy('createdAt',descending: false)
    //.orderBy('createdAt', descending: false).startAt([startAtTimestamp])
        .snapshots()
        .listen((data) {
      orderList.clear();
      orderList.addAll(data.docs.map((e) => e.data()));
      filter(fromListen: true);
      print("listenHistory");
      print(orderList.length);
      notifyListeners();
    });
  }
  void listenchamadas() async {
    print("chamadasStream:::Rodando");
    orderListChamada.clear();
    notifyListeners();
    chamadasStream=
        FirebaseFirestore.instance
            .collection(PEDIDOS)
            .where("boy_id", isEqualTo: auth.currentUser!.uid)
            .where('estado_pedido', isEqualTo:"1")
            .orderBy('createdAt', descending: false)
            .snapshots()
            .listen((data) {
          orderListChamada.clear();
          orderListChamada.addAll(data.docs.map((e) => e.data()));
          print(orderListChamada.length);
          notifyListeners();
        });
  }
  void listenPendency() {
    if (pendencyStream != null) pendencyStream!.cancel();
    pendencyStream = FirebaseFirestore.instance
        .collection(PEDIDOS)
        .where('pendency', isEqualTo: true)
        .snapshots()
        .listen((event) {
      print("event ${event.size}");
      if (event.size > 0) {}
      ListPendency.clear();
      ListPendency.addAll(event.docs.map((e) => e.data()));
      notifyListeners();
    });
  }

  void filter({fromListen: false}) {
    filteredOrderList.clear();
    if (selectedFilter < 4) {
      getDatesFilter();
    } else {
      endDate = endDate.add(Duration(hours: 23, minutes: 59));
    }

    print(
        "Filtrando de: ${initialDate.toString()}, Até: ${endDate.toString()}");

    orderList.forEach((element) {
      var pedido = Pedido.fromFirestore(element);
      if (pedido.createdAt != null) {
        if (pedido.createdAt!.toDate().toLocal().isAfter(initialDate) &&
            pedido.createdAt!.toDate().toLocal().isBefore(endDate) &&
            pedido.situacao_id == CONCLUIDO) filteredOrderList.add(element);
      }
    });

    if (!fromListen) notifyListeners();
  }

  void getDatesFilter() {
    var now = DateTime.now();
    switch (selectedFilter) {
      case 0:
        {
          initialDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          return;
        }
      case 1:
        {
          initialDate = DateTime(now.year, now.month, now.day - 1, 0, 0, 0);
          endDate = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
          return;
        }
      case 2:
        {
          initialDate =
              DateTime(now.year, now.month, now.day - (now.weekday), 0, 0, 0);
          endDate = DateTime(
              now.year, now.month, now.day + (7 - now.weekday), 23, 59, 59);
          return;
        }
      case 3:
        {
          initialDate = DateTime(now.year, now.month, 1, 0, 0, 0);
          endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

          return;
        }
      default:
        {
          initialDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
          endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        }
    }
  }
}
