import 'dart:convert';
import 'dart:math';

import 'package:app_tutorial/app_tutorial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/view/chat_list/chat_list_view.dart';
import 'package:fogaca_app/view/main/main_view.dart';
import 'package:get/get.dart';
import 'package:maps_curved_line/maps/math_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Assistencia/SharedPreference.dart';
import '../../Interfaces/InterfaceLocalStorage.dart';
import '../../Widget/WiDialog.dart';
import '../../api/NavigationService.dart';

abstract class MainModel extends State<MainView> {
  PageController pageController = PageController(initialPage: 0);
  var userController;
  late Size size;
  int selectedIndex = 0;
  var isShowing = false;
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  final keyEntregas = GlobalKey();
  final keyConversas = GlobalKey();
  final keyHistorico = GlobalKey();
  final keyPerfil = GlobalKey();
  final keybotao = GlobalKey();
  List<TutorialItems> itens = [];
  final ILocalStorage iLocalStorage = SharedPreference();

  void onItemClicked(int index) {
      var a = min(index, selectedIndex);
      var b = max(index, selectedIndex);
      if (b - a > 1) {
        pageController.jumpToPage(index);
      } else
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 350), curve: Curves.ease);
      setState(() {
        selectedIndex = index;
      });

  }

  @override
  void initState() {
    checkUpdates();
    setupNotification();

    Get.put(UserController());
    Provider.of<OrderController>(context, listen: false);
    FirebaseAuth.instance.currentUser!
        .getIdToken()
        .then((value) => print(value));

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  checkUpdates() async {
    final packageInfo = await PackageInfo.fromPlatform();
    await remoteConfig.fetchAndActivate();
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
    } on PlatformException catch (exception) {
      print(exception);
    } catch (exception) {
      print(exception);
    }
    final requiredBuildNumber = remoteConfig.getInt("versao_atualizar");
    final NumberHost = remoteConfig.getInt("HOST");
    iLocalStorage.saveData('HOST',NumberHost);
    final currentBuildNumber = int.parse(packageInfo.buildNumber);
    if(requiredBuildNumber>currentBuildNumber){

      ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
          .showSnackBar(SnackBar (
          content : const Text ("Atualize seu App!",
            style: TextStyle(color: Colors.white,
                fontFamily:'Brand Bold'),
          ),
          action: SnackBarAction(
            textColor: Colors.white,
            label: 'Clique aqui',
            onPressed:() => launchPlayStore(),
          ),
          duration: Duration(seconds:15),
          backgroundColor: Colors.green)
      );

    }
  }


  void VerificarsharedPreferences()async{

    print("VerificarsharedPreferences");
    var main_view = await iLocalStorage.readData("main_view");
    print("main_view");
    print(main_view);

    if (main_view != null) {
      if(main_view==0){
        Tutorialinit();
        iLocalStorage.saveData('main_view',1);
      }
    }else{
      print("main_view");
      print("NULLO");
      Tutorialinit();
      iLocalStorage.saveData('main_view', 1);
      iLocalStorage.saveData('order_view', 0);
      iLocalStorage.saveData('chat', 0);
      iLocalStorage.saveData('perfil', 0);
      iLocalStorage.saveData('home_view', 0);
    }
  }
  void Tutorialinit(){
    itens.addAll({
      TutorialItems(
          globalKey: keyEntregas,
          touchScreen: true,
          color: Color.fromRGBO(0, 0, 0, 0.6),
          bottom: 100,
          left: 30,

          children: [
            Text(
              "Tutorial:As corridas que você aceitará apareceram aqui.",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 50,
            )
          ],
          widgetNext: Text(
            "Toque para continuar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          shapeFocus: ShapeFocus.oval),
      TutorialItems(
        globalKey: keyConversas,
        touchScreen: true,
        bottom: 100,
        color: Color.fromRGBO(0, 0, 0, 0.6),
        left: 30,
        children: [
          Text(
            "Poderá enviar mensagem para clientes.",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            height: 100,
          )
        ],
        widgetNext: Text(
          "Toque para continuar",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shapeFocus: ShapeFocus.oval,
      ),
      TutorialItems(
        globalKey: keyHistorico,
        touchScreen: true,
        color: Color.fromRGBO(0, 0, 0, 0.6),
        bottom: 100,
        left: 30,
        children: [
          Text(
            "Seu histórico do dia com detalhes aparecerá aqui.",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          )
        ],
        widgetNext: Text(
          "Toque para continuar",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shapeFocus: ShapeFocus.oval,
      ),
      TutorialItems(
        globalKey: keyPerfil,
        touchScreen: true,
        bottom: 100,
        color: Color.fromRGBO(0, 0, 0, 0.6),
        left: 30,
        children: [
          Text(
            "Suas informações pessoais,alterar foto e outras configurações.",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          )
        ],
        widgetNext: Text(
          "Fechar",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shapeFocus: ShapeFocus.oval,
      )
    });
    Future.delayed(Duration(seconds: 4)).then((value) {
      print("delayed");
      Tutorial.showTutorial(context, itens);
    });
  }

  void setupNotification() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) _handleMessage(message);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) async {
    final fln = FlutterLocalNotificationsPlugin();
    if (!isShowing) {
      var data = message.data;
      if (data['click_action'] == "chat") {
        isShowing = true;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatListView()));
        isShowing = false;
      }
    }
    await fln.cancelAll();
  }
  launchPlayStore() async {
    const url =
        "https://play.google.com/store/apps/details?id=com.MarlosTrinidad.fogaca_app";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
