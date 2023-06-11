import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Page/SplashScreen.dart';
import 'package:fogaca_app/view/main/main_view.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockScreen extends StatelessWidget {
  static var idScreen = "block_screen";
  const BlockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      return Future.value(false);
    }, child: GetBuilder<UserController>(builder: (userController) {
      if (userController.motoboy!.permissao) {
        Future.delayed(
          Duration(milliseconds: 300),
           () => Navigator.of(context).pop(),
        );
      }
      return Scaffold(
        backgroundColor: Colors.black12.withAlpha(50),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Image.asset(
                "imagens/ad.png",
                width: 128,
                height: 128,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Você não tem permissão",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "Para ter sua conta liberada",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "por favor entrar em contato",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "conosco pelo whatsapp.",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton.icon(
                  onPressed: () {
                    launchWhatsapp();
                  },
                  icon: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Falar agora",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                              side: BorderSide(color: Colors.white))))),
            ])),
      );
    }));
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
}
