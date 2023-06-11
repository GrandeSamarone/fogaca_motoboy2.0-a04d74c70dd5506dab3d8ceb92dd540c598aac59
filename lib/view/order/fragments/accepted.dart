import 'package:app_tutorial/app_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Widget/WIToast.dart';

import 'package:fogaca_app/api/controller/api_order_controller.dart';
import 'package:fogaca_app/utils/Utils.dart';

import 'package:fogaca_app/view/order/fragments/order_cancel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Assistencia/SharedPreference.dart';
import '../../../Interfaces/InterfaceLocalStorage.dart';
import '../../chat/Chat_Page.dart';

class Accepted extends StatefulWidget {

  Pedido pedido;

  Accepted(this.pedido);
  @override
  State<Accepted> createState() => _AcceptedState();

  static confirmAlert(context, order){
    var apiOrderController = ApiOrderController(context);
    bool busy=false;
    showDialog(
       barrierDismissible: false,
        context:context,
       builder: (context)=>
           StatefulBuilder(
               builder: (context, setState) =>
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20,top: 45
                    + 20, right: 20,bottom:20
                ),
                margin: EdgeInsets.only(top: 45),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color:Color(0xFF363030),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black,offset: Offset(0,10),
                          blurRadius: 10
                      ),
                    ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Está com o pedido?",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily:"Brand Bold",
                          fontWeight: FontWeight.w600,
                          color:Colors.white
                      ),),
                    SizedBox(height: 15,),
                    Text("",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily:"Brand-Regular",
                            color:Colors.white),
                        textAlign: TextAlign.center),
                    SizedBox(height: 22,),
                    !busy? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed:(){
                            Navigator.of(context).pop();
                          },
                          child: Text("NÃO",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily:"Brand-Regular",
                                color:Colors.white
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: ()async{
                            setState(() {
                              busy=true;
                            });
                            var result = await apiOrderController.changeStatus(
                                                       order.id_doc, SAIU_PARA_ENTREGA);
                            if (result==200){
                              setState(() {
                                busy=false;
                              });
                              Navigator.of(context).pop();
                            }else if(result==400){
                              setState(() {
                                busy=false;
                              });
                              Navigator.of(context).pop();
                              ToastMensagem("Não foi possível acessar o pedido,verifique a internet.", context);
                            }else if(result==500){
                              setState(() {
                                busy=false;
                              });
                              Navigator.of(context).pop();
                              ToastMensagem("ERRO", context);
                            }
                          },
                          child: Text("SIM",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily:"Brand-Regular",
                                color:Colors.white),
                          ),
                        )
                      ],):Center(
                      child:
                      CircularProgressIndicator(
                        color: Colors.red.shade800,
                      ),
                    ),

                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 45,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                    child: Image.asset("imagens/alerta_chegou.png",width: 64,),
                  ),
                ),
              ),
            ],
          ),
        ),
           )
    );

  }

  static Header(Pedido order, Size size, context) {
    var time_limit = DateFormat("HH:mm");
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFF403939),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Container(
                width: 50,
                height: size.width * 0.018,
                child: Icon(FontAwesomeIcons.chevronUp,
                    color: Colors.white70),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    order.nome_ponto,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.05,
                                        color: Colors.white),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "Chegue antes das ${time_limit.format(DateTime.fromMillisecondsSinceEpoch(order.createdAt!.millisecondsSinceEpoch).toLocal().add(Duration(minutes: 10))) ?? ""}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.04,
                                        color: Colors.white),
                                  ),
                                ),
                              ]),
                        ),
                        FloatingActionButton(
                            heroTag: "a",
                            backgroundColor: Colors.red,
                            onPressed: () {
                            dialogMaps(context,order);
                            },
                            child: Icon(
                              Icons.navigation,
                              color: Colors.white,
                            )),
                      ]),
                      SizedBox(
                        height: size.width * 0.03,
                      ),
      Center(
        child: Container(
          width: size.width,
          height: size.width * 0.12,
          child: ElevatedButton(
            child: Text("Sair para entrega"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              primary: Colors.red.shade800,
              onSurface: Colors.grey,
              shape: const BeveledRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(5))),
              textStyle: TextStyle(
                  color: Colors.white54,
                  fontSize: size.width * 0.05,
                  fontFamily: "Brand Bold",
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              confirmAlert(context, order);
            },
          ),
        ),
      ),
                ]
                  ),
                ),
                SizedBox(
                  width: 16,
                )
              ],
            ),
          ]),
    );
  }

  static dialogMaps(context, order) async {
    return showDialog(
        context:context,
        builder: (
        BuildContext context)=> Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child:Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20,top: 10
                + 20, right: 20,bottom:20
            ),
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color:Color(0xFF363030),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black,offset: Offset(0,10),
                      blurRadius: 10
                  ),
                ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Selecione um navegador para te lever até a local do pedido:",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily:"Brand-Regular",
                      fontWeight: FontWeight.w400,
                      color:Colors.white
                  ),),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "imagens/wazeicon.png",
                              width: 50,
                              height: 50,
                            ),
                            Text('Waze',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Brand-Regular"
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          launchWaze(double.parse(order.lat_ponto),double.parse(order.long_ponto));
                          Navigator.of(context).pop();
                        }),
                    GestureDetector(
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "imagens/googlemapsicon.png",
                              width: 50,
                              height: 50,
                            ),
                            Text('Google Maps',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Brand-Regular"
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          launchGoogleMaps(double.parse(order.lat_ponto),double.parse(order.long_ponto));
                          Navigator.of(context).pop();
                        }),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  static Future<void> launchWaze(double lat, double lng) async {
    var url = 'waze://?ll=${lat.toString()},${lng.toString()}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${lat.toString()},${lng.toString()}&navigate=yes';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

   static Future<void> launchGoogleMaps(double lat, double lng) async {
    var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }
}

class _AcceptedState extends State<Accepted> {
  var format = DateFormat("HH:mm:ss");

  final keybottonMaps = GlobalKey();

  final keyNome = GlobalKey();

  final keyBarrainferior = GlobalKey();

  final keybotao = GlobalKey();

  List<TutorialItems> itens = [];

  @override
  void initState() {
    VerificarsharedPreferences(context);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {



    print("ORDER.COMENTARIO");
    print(widget.pedido.comentario);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: Column(
        key: keyBarrainferior,
        children: [
          Icon(FontAwesomeIcons.chevronDown,
              color: Colors.white70),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Text(
                widget.pedido.situacao ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Brand Bold",
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
                key: keybotao,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) => // Chat_Page(pedido: pedido)
                    Chat_Page( pedido:widget.pedido),
                  ));
                },
                child: Icon(
                  Icons.chat,
                  size: 36,
                  color: Colors.white,
                  key:keybottonMaps,
                ),
              ),
            )
          ]),
          SizedBox(
            height: 8,
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              primary: true,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Endereço da coleta:",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      key:keyNome,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${widget.pedido.end_ponto}",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 16.0,
                              color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ), Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${widget.pedido.num_ponto}",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 16.0,
                              color: Colors.white70),
                          overflow: TextOverflow.ellipsis,

                        ),
                      ),
                      SizedBox(height: 6.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${widget.pedido.bairro_ponto ?? ""}",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 16.0,
                              color: Colors.white70),
                          overflow: TextOverflow.ellipsis,

                        ),
                      ),
                      SizedBox(height: 6.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${widget.pedido.quant_itens + " Entregas" ?? ""}",
                          style: TextStyle(
                              fontFamily: "Brand-Regular",
                              fontSize: 16.0,
                              color: Colors.white70),
                          overflow: TextOverflow.ellipsis,

                        ),
                      ),
                      SizedBox(height: 6.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Retorno?: ${widget.pedido.need_return==true?"Sim":"Não"}',
                            style: new TextStyle(
                                fontSize: 16.0,
                                fontFamily: "Brand-Regular",
                                color: Colors.white70)
                        ),
                      ),
                      SizedBox(height: 12.0),

                      widget.pedido.comentario!=""?
                          Container(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                           icon:Icon( Icons.message_outlined,color: Colors.white,),
                            label:Text("Você tem uma mensagem",
                              style: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  fontSize: 16.0,
                                  color: Colors.white)),
                            onPressed:(){
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (c) => // Chat_Page(pedido: pedido)
                                Chat_Page( pedido:widget.pedido),
                              ));
                            },
                          ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.red.shade800),
                              borderRadius: BorderRadius.circular(8),

                            ),
                        ):Container(),
                      SizedBox(height: 6.0),
                    ]),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Horários:",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Pedido feito as:  ${format.format(DateTime.fromMillisecondsSinceEpoch(widget.pedido.createdAt!.millisecondsSinceEpoch).toLocal()) ?? ""}",
                            style: TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 16.0,
                                color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 6.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Você aceitou as:  ${format.format(DateTime.fromMillisecondsSinceEpoch(widget.pedido.acceptedAt!.millisecondsSinceEpoch).toLocal()) ?? ""}",
                            style: TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 16.0,
                                color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 6.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: Container(
                        width: 300.0,
                        height: 50.0,
                        child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 30,
                            ),
                            label: Text('Cancelar Corrida'),
                            style: ElevatedButton.styleFrom(
                              padding:
                              EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),

                              primary: Colors.red[900],
                              //  onPrimary: Colors.white,
                              onSurface: Colors.grey,
                              shape: const BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5))),

                              textStyle: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 20,
                                  fontFamily: "Brand Bold",
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => order_cancel(
                                        id_doc: widget.pedido.id_doc,
                                      )));

                            })
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void VerificarsharedPreferences(context)async{
    final ILocalStorage iLocalStorage = SharedPreference();

    var order_view = await iLocalStorage.readData("order_view");

    print("order_view");
    print(order_view);

      if(order_view==0){
        TutorialButton(context);
        iLocalStorage.saveData('order_view',1);
      }

  }
  TutorialButton(context){
    itens.addAll({
      TutorialItems(
          globalKey: keybottonMaps,
          touchScreen: true,
          color: Color.fromRGBO(0, 0, 0, 0.8),
          top: 100,
          left: 50,
          children: [
            Text(
              "Esse botão abre a localização do cliente no Mapa.",
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
        globalKey: keyNome,
        touchScreen: true,
        top: 80,
        color: Color.fromRGBO(0, 0, 0, 0.8),
        left: 50,
        children: [
          Text(
            "Nome do seu cliente, você tem no maximo 10 min para chegar até o local.",
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
        shapeFocus: ShapeFocus.oval,
      ),
      TutorialItems(
        globalKey: keybotao,
        touchScreen: true,
        top: 80,
        color: Color.fromRGBO(0, 0, 0, 0.8),
        left: 50,
        children: [
          Text(
            "Quando chegar no local e pegar a entrega atualize o pedido clicando em Sair para entrega",
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
        shapeFocus: ShapeFocus.oval,
      ),TutorialItems(
        globalKey: keyBarrainferior,
        touchScreen: true,
        top: 80,
        color: Color.fromRGBO(0, 0, 0, 0.8),
        left: 50,
        children: [
          Text(
            "Arraste para cima a barra inferior e terá mais detalhes.",
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
}