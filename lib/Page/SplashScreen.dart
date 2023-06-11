import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Model/UserStateModel.dart';
import 'package:fogaca_app/Pages_user/Tela_Login.dart';
import 'package:fogaca_app/view/login/login_view.dart';
import 'package:fogaca_app/view/main/main_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../Controllers/app_controller.dart';

class SplashScreen extends StatefulWidget {
  static const String idScreen = "splash_screen";
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<SplashScreen> with UserStateModel {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1500), () async {
      initialize();
    });
  }

  initialize() async {
    await reloadUser();
    if (!isLogged()) {
      Navigator.of(context).pushReplacementNamed(LoginView.idScreen);
    } else {
      Navigator.of(context).pushReplacementNamed(MainView.idScreen);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4279900442),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("imagens/screen_dark.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
