import 'dart:async';

import 'package:app_tutorial/app_tutorial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fogaca_app/Controllers/LocationController.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:fogaca_app/Widget/WiDialog.dart';
import 'package:fogaca_app/view/login/login_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lc;
import 'package:optimization_battery/optimization_battery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import '../../Assistencia/SharedPreference.dart';
import '../../Interfaces/InterfaceLocalStorage.dart';
import 'home_view.dart';


abstract class HomeModel extends State<HomeView>
    with
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver,
        SingleTickerProviderStateMixin {
  late AnimationController avaiableController;
  GoogleMapController? controller_Maps;
  Timer? debounce;
  bool Splash = true;
  bool Loading = false;
  late Size size;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final ILocalStorage iLocalStorage = SharedPreference();
  Position? posicao_atual;
  final keyBotaoFicarOn = GlobalKey();
  final keyPararChamada = GlobalKey();
  List<TutorialItems> itens = [];
  lc.Location location = new lc.Location();
  var OffouOnline = false;
  var permissao = false;
  var auth = FirebaseAuth.instance;
  MethodChannel serviceChannel = MethodChannel("motoboy");
  var serviceStatus;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  logout() async {
    makeOffline();
    await FirebaseFirestore.instance.terminate();
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, LoginView.idScreen, (route) => false);
    }).catchError((error) {});
  }

  verifyPermission() async {
    var loc = await Permission.location.status;
    switch (loc) {
      case PermissionStatus.denied:
        showDialog(
            context: context,
            builder: (BuildContext context) => WIDialog(
                  titulo: "Permissão da localização",
                  msg:
                      "Para continuar iremos precisar da permissão da localização.",
                  textoButton1: "Entendi",
                  textoButton2: "Autorizar",
                  button1: () {
                    Navigator.pop(context);
                  },
                  button2: () {
                    Navigator.pop(context);
                    Geolocator.openLocationSettings();
                  },
                  img: "imagens/alerta.png",
                ));
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.limited:
        showDialog(
            context: context,
            builder: (BuildContext context) => WIDialog(
                  titulo: "Permissão da localização",
                  msg:
                      "Precisamos da autorização monitorar sempre ou quando usar esse app.",
                  textoButton1: "Entendi",
                  textoButton2: "Autorizar",
                  button1: () {
                    Navigator.pop(context);
                  },
                  button2: () {
                    Navigator.pop(context);
                    Geolocator.openLocationSettings();
                  },
                  img: "imagens/alerta.png",
                ));
        break;
      case PermissionStatus.permanentlyDenied:
        showDialog(
            context: context,
            builder: (BuildContext context) => WIDialog(
                  titulo: "Permissão da localização",
                  msg: "Permissão negada não é possivel usar o app.",
                  textoButton1: "Entendi",
                  textoButton2: "Autorizar",
                  button1: () {
                    Navigator.pop(context);
                  },
                  button2: () {
                    Navigator.pop(context);
                    Geolocator.openLocationSettings();
                  },
                  img: "imagens/alerta.png",
                ));
        break;
    }
  }

  void locatePosition() async {
    posicao_atual = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLatPosition =
        LatLng(posicao_atual!.latitude, posicao_atual!.longitude);
    //localizacao fim
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    controller_Maps!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<bool> checkOverlayPermission() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt! > 22) {
      var overlayStatus = await serviceChannel.invokeMethod("checkOverlay");
      return overlayStatus;
    } else
      return true;
  }

  Future<bool> checkLocationPermission() async {
    print("request permission");
    var android = await deviceInfo.androidInfo;

    var permission = await Permission.location.request();

    if (android.version.sdkInt! > 22) {
      if (permission.isGranted) {
        return true;
      } else
        return false;
    } else {
      var permission = await Permission.location.isGranted;
      return permission;
    }
  }



  void VerificandoDados() async {
    var userController = Get.find<UserController>();
    var locationController = Provider.of<LocationController>(context, listen: false);
    if (userController.motoboy!.permissao) {
      if (await checkLocationPermission()) {
        if (await checkOverlayPermission()) {
          if ( await Geolocator.isLocationServiceEnabled()) {
            locatePosition();
            changeStatus();
          } else {
            locationController.enableGps();
            ToastMensagem(
                "Ative seu GPS antes de começar a aceitar pedidos.", context);
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => WIDialog(
                    titulo: "Atenção",
                    msg:
                        "Para receber corridas é preciso autorização para sobrepor outros aplicativos.",
                    textoButton1: "Depois",
                    textoButton2: "Autorizar",
                    button1: () {
                      Navigator.pop(context);
                    },
                    button2: () {
                      serviceChannel.invokeMethod("ativarOverlay");
                      Navigator.pop(context);
                    },
                    img: "imagens/alerta.png",
                  )
          );
        }
      }
    }else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WIDialog(
            titulo: "Atenção",
            msg:
            "Para ter sua conta liberada  por favor entrar em contato conosco pelo whatsapp.",
            textoButton1: "Depois",
            textoButton2: "Falar agora",
            button1: () {
              Navigator.pop(context);
            },
            button2: () {
              launchWhatsapp();
              Navigator.pop(context);
            },
            img: "imagens/alerta.png",
          ));
    }
  }

  Future<void> makeOnline() async {
    var userController = Get.find<UserController>();

    firebaseMessaging.subscribeToTopic(userController.motoboy!.cod);

    Wakelock.enable();
    serviceChannel.invokeMethod("startService");

    VerificarsharedPreferences();
    //FirebaseMessaging.instance.subscribeToTopic("pending_order");
    //Get.find<AppController>().checkStatusService();

  }

  Future<void> makeOffline() async {
    print("makeOffline::::::::");
    var userController = Get.find<UserController>();

    firebaseMessaging.unsubscribeFromTopic(userController.motoboy!.cod);

    Wakelock.disable();
    serviceChannel.invokeMethod("stopService");
    ToastMensagem("Não receberá pedidos.", context);
    //Get.find<AppController>().checkStatusService();
  }

  launchWhatsapp() async {
    const url =
        "https://api.whatsapp.com/send?phone=556992107870&text=ol%C3%A1";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void verifyGpsStatus() async {
    var locationController =
        Provider.of<LocationController>(context, listen: false);

    if (!locationController.gpsEnabled && OffouOnline) {
      makeOffline();
      showDialog(
          context: context,
          builder: (BuildContext context) => WIDialog(
                titulo: "Localização",
                msg: "Para continuar iremos precisar da sua localização.",
                textoButton1: "Entendi",
                textoButton2: "Configurações",
                button1: () {
                  Navigator.pop(context);
                },
                button2: () {
                  Navigator.pop(context);
                  Geolocator.openLocationSettings();
                },
                img: "imagens/alerta.png",
              ));
    }
  }

  @override
  void initState(){
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(seconds: 1, milliseconds: 500), () {
      setState(() {
        Splash = false;
      });
      verifyGpsStatus();
    });
    super.initState();

    WidgetsBinding.instance!.addObserver(this);

   //   serviceStatus = await serviceChannel.invokeMethod("serviceStatus");
   // if(serviceStatus!=null){
   //   print("serviceStatus::::");
   //   print(serviceStatus);
   // }else{
   //   print("serviceStatus::::");
   //   print("FALSE");
   // }

    avaiableController = AnimationController.unbounded(
        vsync: this,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500));

  }

  void VerificarsharedPreferences()async{
    var userController = Get.find<UserController>();
    var order_view =
    await iLocalStorage.readData("home_view");
    print("home_view");
    print(order_view);
    if (order_view != null && order_view==0 && userController.connected) {
      TutorialButton();
      iLocalStorage.saveData('home_view', 1);
    }
  }
  TutorialButton(){
    itens.addAll({
      TutorialItems(
          globalKey: keyBotaoFicarOn,
          touchScreen: true,
          color: Color.fromRGBO(0, 0, 0, 0.8),
          bottom: 100,
          left: 50,
          children: [
            Text(
              "Tudo Certo!\n Você já pode aceitar corridas,\n não esqueça de ficar OFFLINE quando parar de trabalhar.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              height: 20,
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
        globalKey: keyPararChamada,
        touchScreen: true,
        top: 80,
        color: Color.fromRGBO(0, 0, 0, 0.8),
        left: 50,
        children: [
          Text(
            "Caso esteja ocupado nas entregas e não quer ser incomodado\n"
                "você pode bloquear as chamadas.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(
            height: 20,
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
      ),

    });
    Future.delayed(Duration(seconds:3)).then((value) {
      print("delayed");
       Tutorial.showTutorial(context, itens);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    try {
      debounce!.cancel();
      controller_Maps!.dispose();
      WidgetsBinding.instance!.removeObserver(this);
    } catch (e) {}
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('\n\nresumed');

        verifyGpsStatus();
        // UserController userController = Get.find<UserController>();
        // print("USER CONTROLLER");
        // print(userController.status);
        break;
      case AppLifecycleState.inactive:
        print('\n\ninactive');
        break;
      case AppLifecycleState.paused:
        print('\n\npaused');
        break;
      case AppLifecycleState.detached:
        print('\n\ndetached');

        //makeOffline();
        break;
    }
  }

  changeMapMode() {
    rootBundle
        .loadString(
      'imagens/maps_styles/mapsdark.json',
    )
        .then((string) {
      try {
        controller_Maps!.setMapStyle(string);
      } catch (e) {}
    });
  }

  void changeStatus() async {
    UserController userController = Get.find<UserController>();

    OrderController orderController = Provider.of<OrderController>(context, listen: false);
    if (userController.status == -1){
      if(userController.connected){
        await makeOnline();
      }else{
        ToastMensagem("Verifique sua conexão com internet.", context);
      }

    } else {
      if (orderController.orderListChamada.isNotEmpty)
        return ToastMensagem("Finalize as entregas", context);
      await makeOffline();
    }
  }


}

