import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../api/Api.dart';

class AppController extends GetxController {
  EventChannel? eventChannel;
  bool _isOnline = false;

  get isOnline => _isOnline;
  MethodChannel androidChannel = MethodChannel("motoboy");
  AppController() {
    listen();
    checkStatusService(notify: true);
  }

  listen() async {
    if (eventChannel == null) {
      print("SOCKET LISTENING ON FLUTTER");
      eventChannel = EventChannel("event");
      eventChannel!.receiveBroadcastStream().listen((event) {
        print("SOCKET STATUS ${event.toString()}");
        _isOnline = event as bool;

        checkStatusService(notify: true);
      });
    }
  }

  void checkStatusService({notify: false}) async {
    try {
      var userController = Get.find<UserController>();
      var serviceStatus = await androidChannel.invokeMethod("serviceStatus");

      if (serviceStatus) listen();

      print("serviceStatus:::::");
      print(serviceStatus);
      if (serviceStatus && Get.find<AppController>().isOnline) {
        userController.setStatus(1);
        FirebaseMessaging.instance.subscribeToTopic("pending_order");
      }

      if (!serviceStatus) userController.setStatus(-1);

      if (serviceStatus && !Get.find<AppController>().isOnline)
        userController.setStatus(0);

      if (!serviceStatus && userController.motoboy!.online) {
        userController.setStatus(-1);
        forceOffline();
        FirebaseMessaging.instance.unsubscribeFromTopic("pending_order");
      }
      // if (serviceStatus && status == -1) {
      //   status = 0;
      //   print("CARREGANDO");
      // } else if (!serviceStatus && status == 1) {
      //   status = -1;
      //   forceOffline();
      //   FirebaseMessaging.instance.unsubscribeFromTopic("pending_order");
      // } else if (!serviceStatus && status == 0) {
      //   status = -1;
      //   FirebaseMessaging.instance.unsubscribeFromTopic("pending_order");
      // }

      // if (status == 1) {
      //   FirebaseMessaging.instance.subscribeToTopic("pending_order");
      // }

      // if (serviceStatus && !isConnected) status = 0;
      // if (!serviceStatus && !isConnected) status = -1;

      print("STATUS: $_isOnline");
      if (notify) update();
    } catch (e) {
      print(e);
    }
  }

  forceOffline() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var response = await post(Uri.parse(await Api.Host() + "/ficaroffline"),
          body: {"id": user!.uid},
          headers: {"authorization": await user.getIdToken(true), "type": "1"});
    } catch (e) {}
  }
}
