import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/assertions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fogaca_app/Controllers/LocationController.dart';
import 'package:fogaca_app/Controllers/app_controller.dart';
import 'package:fogaca_app/Controllers/auth_controller.dart';
import 'package:fogaca_app/Controllers/chat_controller.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';
import 'package:fogaca_app/api/NavigationService.dart';
import 'package:fogaca_app/view/block/block_screen.dart';
import 'package:fogaca_app/view/chat_list/chat_list_view.dart';
import 'package:fogaca_app/view/main/main_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'Page/SplashScreen.dart';
import 'Pages_user/Tela_Cadastro.dart';
import 'view/login/login_view.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.data['click_action'] == "canceled") {
    requestMotoboy(message);
  } else if (message.data['click_action'] == "request") {
    requestMotoboy(message);
  }else if (message.data['click_action'] == "accepted") {
    notify(message,ChannelAceppted);
  }
}

AndroidNotificationChannel Channelchat = AndroidNotificationChannel(
  'chat', // id
  'Chat',
  'Chat', // description
  sound:RawResourceAndroidNotificationSound("chat"),
  importance: Importance.max,
);
AndroidNotificationChannel ChannelAceppted = AndroidNotificationChannel(
  'accepted', // id
  'Accepted',
  'Accepted',
  sound:RawResourceAndroidNotificationSound("accepted"),
  importance: Importance.max,
);
AndroidNotificationChannel ChannelDelivered = AndroidNotificationChannel(
  'delivered', // id
  'Delivered',
  'Delivered',
  sound:RawResourceAndroidNotificationSound("delivered"),
  importance: Importance.max,
);
AndroidNotificationChannel ChannelFinish = AndroidNotificationChannel(
  'finish', // id
  'Finish',
  'Finish',
  sound:RawResourceAndroidNotificationSound("finish"),
  importance: Importance.max,
);
AndroidNotificationChannel ChannelCanceled = AndroidNotificationChannel(
  'cancel', // id
  'Canceled',
  'Canceled',
  sound:RawResourceAndroidNotificationSound("cancel"),
  importance: Importance.max,
);

AndroidNotificationChannel ChannelEmpty = AndroidNotificationChannel(
  'empty', // id
  'Empty',
  'Empty',
  sound:RawResourceAndroidNotificationSound("empty"),
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  print("message foreground: ${message.data}");
  if (message.data['click_action'] == "chat") {
    var controller = Provider.of<ChatController>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    if (controller.selectedChat != message.data['chat_id']) {
      notify(message,Channelchat);
    }
  }else if (message.data['click_action'] == "canceled") {
    requestMotoboy(message);
  } else if (message.data['click_action'] == "request") {
    requestMotoboy(message);
  } else if (message.data['click_action'] == "accepted") {
    notify(message,ChannelAceppted);
  }
}
void notify(RemoteMessage message,AndroidNotificationChannel channel) {

  final Int64List vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;
  const int insistentFlag = 4;
  var details = AndroidNotificationDetails(
    channel.id,
    channel.name,
    channel.description,
    importance: Importance.max,
    priority: Priority.high,
    vibrationPattern:vibrationPattern ,
    icon: "ic_fogaca",
    color: Colors.redAccent,
    styleInformation: BigTextStyleInformation(''),
    // other properties...
  );

  flutterLocalNotificationsPlugin.show(
    message.notification.hashCode,
    message.data['title'],
    message.data['body'],
    NotificationDetails(android: details),
  );
}

void requestMotoboy(RemoteMessage message) {
  RawDatagramSocket.bind(InternetAddress.anyIPv4, 0)
      .then((RawDatagramSocket socket) {

    socket.send(utf8.encode(jsonEncode(message.data)), InternetAddress.anyIPv4, 3306);
  });
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterExceptionHandler? originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    originalOnError!(errorDetails);
  };
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>
    ()?.createNotificationChannel(Channelchat);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>
    ()?.createNotificationChannel(ChannelAceppted);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>
    ()?.createNotificationChannel(ChannelDelivered);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>
    ()?.createNotificationChannel(ChannelFinish);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>
    ()?.createNotificationChannel(ChannelCanceled);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>
    ()?.createNotificationChannel(ChannelEmpty);


  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthController()),
      ChangeNotifierProvider(create: (_) => LocationController()),
      ChangeNotifierProvider(create: (_) => ChatController()),
      ChangeNotifierProvider(create: (_) => OrderController())
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics =FirebaseAnalytics.instance;

    RouteObserver routeObserver = RouteObserver();
    Get.put(AppController());
    return GetMaterialApp(
      theme: ThemeData(
              primarySwatch: createMaterialColor(Color(4288088072)),
              scaffoldBackgroundColor: Color(0xFF403939),
              cardColor: Color(0xFF403939),
              canvasColor: Color(0xFF403939),
              fontFamily: "Brand-Regular"
              // visualDensity: VisualDensity.adaptivePlatformDensity
              )
          .copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Fogaça Motoboys",
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
        routeObserver
      ],
      home: SplashScreen(),
      routes: {
        SplashScreen.idScreen: (context) => SplashScreen(),
        Tela_Cadastro.idScreen: (context) => Tela_Cadastro(),
        LoginView.idScreen: (context) => LoginView(),
        MainView.idScreen: (context) => MainView(),
        ChatListView.id_screen: (c) => ChatListView(),
        BlockScreen.idScreen: (c) => BlockScreen()
      },
    );
  }

  //Color
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
