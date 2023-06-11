import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/utils/my_flutter_app_icons.dart';
import 'package:fogaca_app/view/chat_list/chat_list_view.dart';
import 'package:fogaca_app/view/deliveries/tab_view.dart';
import 'package:fogaca_app/view/earning/earning_view.dart';
import 'package:fogaca_app/view/home/home_view.dart';
import 'package:fogaca_app/view/profile/profile_view.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'main_model.dart';

class MainView extends StatefulWidget {
  static const String idScreen = "main";
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends MainModel  with WidgetsBindingObserver {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<UserController>(
        builder: (userController) {
             userController.checkStatusUser(context);
               if(userController.motoboy!=null && userController.motoboy!.permissao){
                 VerificarsharedPreferences();
               }
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body:  PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                HomeView(),
                tab_view(),
                ChatListView(),
                EarningView(),
                ProfileView(),
              ],
            ),

          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined,),
                label: "Inicio",

              ),
              BottomNavigationBarItem(
                icon: Icon(
                    MyFlutterApp.bolsa,
                    key:keyEntregas
                ),
                label: "Entregas",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    Icons.forum,
                    key:keyConversas
                ),
                label: "Conversas",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.monetization_on_rounded,
                    key:keyHistorico
                ),
                label: "Ganhos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline,
                    key:keyPerfil
                ),
                label: "Perfil",
              ),
            ],
            selectedItemColor: Colors.red,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.white,
            selectedLabelStyle: TextStyle(fontSize: 12.0),
            showUnselectedLabels: true,
            currentIndex: selectedIndex,
            onTap: onItemClicked,
          ),
        ),
      );
    });
  }

}
