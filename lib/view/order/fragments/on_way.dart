import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Widget/WIBusy.dart';
import 'package:fogaca_app/Widget/WIDivider.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:fogaca_app/Widget/WiDialog.dart';
import 'package:fogaca_app/api/controller/api_order_controller.dart';
import 'package:fogaca_app/utils/Utils.dart';

import 'package:fogaca_app/view/chat_list/chat_list_view.dart';
import 'package:fogaca_app/view/order/fragments/order_cancel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../chat/Chat_Page.dart';

class OnWay extends StatelessWidget {
  Pedido pedido;
  var format = DateFormat("HH:mm:ss");

  OnWay(this.pedido);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: Column(
        children: [
          Icon(FontAwesomeIcons.chevronDown,
              color: Colors.white70),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Text(
                pedido.situacao ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Brand Bold",
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) => // Chat_Page(pedido: pedido)
                    Chat_Page( pedido:pedido),
                  ));
                  //launch(('tel://${widget.detalheCorrida!["telefone"]!=null?widget.detalheCorrida!["telefone"]:""}'));
                },
                child: Icon(
                  Icons.chat,
                  size: 36,
                  color: Colors.white70,
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
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(8),
                      child: Column(children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${pedido.end_ponto + "  N:" + pedido.num_ponto ?? ""}",
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
                            "${pedido.bairro_ponto ?? ""}",
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
                            "${pedido.quant_itens + " Entregas" ?? ""}",
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
                          child: Text('Retorno?: ${pedido.need_return==true?"Sim":"Não"}',
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: "Brand-Regular",
                                  color: Colors.white70)
                          ),
                        ),
                        SizedBox(height: 6.0),
                      ])),
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
                            "Pedido feito as:  ${format.format(DateTime.fromMillisecondsSinceEpoch(pedido.createdAt!.millisecondsSinceEpoch).toLocal()) ?? ""}",
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
                            "Você aceitou as:  ${format.format(DateTime.fromMillisecondsSinceEpoch(pedido.acceptedAt!.millisecondsSinceEpoch).toLocal()) ?? ""}",
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
                            "Saiu para entrega as:  ${format.format(DateTime.fromMillisecondsSinceEpoch(pedido.deliveryAt!.millisecondsSinceEpoch).toLocal()) ?? ""}",
                            style: TextStyle(
                                fontFamily: "Brand-Regular",
                                fontSize: 16.0,
                                color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  static confirmAlert(context, order,String estado,String text){
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
                              Text(text,
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
                                          order.id_doc, estado);
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
      decoration: BoxDecoration(
        color: Color(0xFF403939),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.topCenter,
          child: Container(
            width: 50,
            height: 6,
            child: Icon(FontAwesomeIcons.chevronUp,
                color: Colors.white70),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width:16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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

                                ]),
                          ),

                        ]),
                        SizedBox(
                          height: size.width * 0.03,
                        ),
                        Center(
                          child: Container(
                            width: size.width,
                            height: size.width * 0.12,
                            child: ElevatedButton(
                                child: order.need_return
                                    ? Text("FINALIZAR ENTREGA")
                                    : Text("FINALIZAR"),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                                  primary: Colors.red.shade800,
                                  onSurface: Colors.grey,
                                  shape: const BeveledRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 20,
                                      fontFamily: "Brand Bold",
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  if (!order.need_return)
                                    confirmAlert(context, order,CONCLUIDO,"Já retornou até o cliente?");
                                  else
                                    confirmAlert(context, order,FINALIZADO,"Entregou o pedido?");
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width:size.width * 0.03,
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
