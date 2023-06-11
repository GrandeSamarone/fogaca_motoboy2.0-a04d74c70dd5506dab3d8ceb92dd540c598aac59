import 'package:app_tutorial/app_tutorial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Widget/WIDivider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Assistencia/SharedPreference.dart';
import '../../Components/CPMessages.dart';
import '../../Components/CPNew_message.dart';
import '../../Controllers/chat_controller.dart';
import '../../Interfaces/InterfaceLocalStorage.dart';
import '../../Model/Pedido.dart';
import '../../Widget/WIToast.dart';

class Chat_Page extends StatefulWidget {
  Pedido pedido;
  Chat_Page({
    required this.pedido
  });

  @override
  State<Chat_Page> createState() => _Chat_PageState();
}

class _Chat_PageState extends State<Chat_Page> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Size size;
  var chatController;
  final keycall = GlobalKey();

  List<TutorialItems> itens = [];

  @override
  void initState() {
   VerificarsharedPreferences();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
  chatController = Provider.of<ChatController>(context, listen: false);

    chatController.selectedChat=widget.pedido.id_doc;

    return WillPopScope(
      onWillPop: (){
        return _moveToSignInScreen(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: "",
            onPressed: () {
              _moveToSignInScreen(context);
            },
          ),
          backgroundColor:Colors.red.withAlpha(80),
          title: Container(
            child:
               Column(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.pedido.nome_ponto),
                ],

              ),

          ),
          actions: [
            IconButton(
                onPressed: () {
                  try {

                    _makePhoneCall(widget.pedido.telefone);
                    // launch("tel:${chat.metadata!['boy_telefone']}");
                  } catch (e) {
                    ToastMensagem(
                        "Não foi possível iniciar a chamada", context);
                  }
                },
                icon: Icon(Icons.phone),
              key: keycall,
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Messages(
                      doc:widget.pedido.id_doc,
                      id:widget.pedido.boy_id
                  )
              ),
              WIDividerWidget(),
              NewMessage(
                doc:widget.pedido.id_doc,
                id:widget.pedido.boy_id,
                nome:widget.pedido.boy_nome,
                id_from:widget.pedido.id_usuario,
                token_from:widget.pedido.token_ponto,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _makePhoneCall(String phoneNumber) async {

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  _moveToSignInScreen(BuildContext context) {
    chatController.selectedChat = "";
    Navigator.pop(context);
  }
  void VerificarsharedPreferences()async{
    final ILocalStorage iLocalStorage = SharedPreference();

    var chat = await iLocalStorage.readData("chat");

    print("chat");
    print(chat);

    if(chat==0){
      TutorialButton();
      iLocalStorage.saveData('chat',1);
    }

  }
  TutorialButton(){
    itens.addAll({
      TutorialItems(
          globalKey: keycall,
          touchScreen: true,
          color: Color.fromRGBO(0, 0, 0, 0.8),
          top: 100,
          left: 50,
          children: [
            Text(
              "Caso precise ligar para o cliente, clique aqui.",
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
    });
    Future.delayed(Duration(seconds:2)).then((value) {
      print("delayed");
      Tutorial.showTutorial(context, itens);
    });
  }
}