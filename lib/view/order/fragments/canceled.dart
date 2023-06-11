import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Page/SplashScreen.dart';
import 'package:fogaca_app/Widget/WIDivider.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:fogaca_app/api/controller/api_order_controller.dart';
import 'package:fogaca_app/utils/Utils.dart';

import 'package:fogaca_app/view/chat_list/chat_list_view.dart';
import 'package:fogaca_app/view/order/fragments/order_cancel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

class Canceled extends StatelessWidget {
  Pedido pedido;
  var format = DateFormat("HH:mm:ss");

  Canceled(this.pedido);
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
                    margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SizedBox(height: 6.0),
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
                        pedido.deliveryAt != null
                            ? Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Saiu para entrega as:  ${format.format(DateTime.fromMillisecondsSinceEpoch(pedido.deliveryAt!.millisecondsSinceEpoch).toLocal()) ?? ""}",
                                  style: TextStyle(
                                      fontFamily: "Brand-Regular",
                                      fontSize: 16.0,
                                      color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: 6.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Cancelado as:  ${format.format(DateTime.fromMillisecondsSinceEpoch(pedido.canceledAt!.millisecondsSinceEpoch).toLocal()) ?? ""}",
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
                  SizedBox(height: 20.0),
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
                    width: 8,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: size.width,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    order.nome_ponto+" cancelado",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.05,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Center(
                                  child: Container(
                                      width: 300,
                                      height: 50.0,
                                      child: TextButton(
                                        child: Text(
                                          'Retornar ao inicio',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: "Brand Bold",
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          side: BorderSide(color: Colors.red, width: 1),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context, SplashScreen.idScreen, (route) => false);
                                        },
                                      )),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
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
