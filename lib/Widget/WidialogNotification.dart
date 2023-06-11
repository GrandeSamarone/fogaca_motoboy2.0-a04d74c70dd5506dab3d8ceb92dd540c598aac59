

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/api/Api.dart';
import 'package:fogaca_app/api/controller/api_order_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'WIToast.dart';

class WidialogNotification extends StatefulWidget{

  Map<String, dynamic> detalheCorrida = Map();

  WidialogNotification({required this.detalheCorrida});

  WidialogNotificationState createState() =>WidialogNotificationState();

}

class WidialogNotificationState extends State<WidialogNotification> {

  String ButtonTxt="Aceitar";
  Color? ColorButton = Colors.red[900];
  Timer? debounce;
  var result;
  bool _clicked = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    debounce!.cancel();
  }
  @override
  Widget build(BuildContext context) {

   //var distance= Geolocator.distanceBetween(-10.8605659, -61.9803161, double.parse(widget.detalheCorrida["lat_ponto"]),double.parse(widget.detalheCorrida["long_ponto"]));
    var apiOrderController = ApiOrderController(context);
    // TODO: implement build
    return Dialog(
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12.0)),
      backgroundColor:Colors.transparent,
      elevation:1.0,
      child:Container(
        margin:EdgeInsets.all(5.0),
        width:double.infinity,
        decoration:BoxDecoration(
          color: Color(0xFF403939),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 18.0,),
            Text(widget.detalheCorrida["nome_ponto"]!=null?widget.detalheCorrida["nome_ponto"]:"",
              style:TextStyle(
                  fontSize:20.0,
              color: Colors.white),),
            SizedBox(height: 10.0,),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                         Text(
                                widget.detalheCorrida["rua_ponto"]!=null?
                          widget.detalheCorrida["rua_ponto"]:"",
                                style:TextStyle(
                                    fontSize:18.0,
                                color: Colors.white
                                ),
                              ),
                  SizedBox(height: 15.0,),
                  Text("N:"+
                    widget.detalheCorrida["num_ponto"],
                    style:TextStyle(
                        fontSize:18.0,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Text(
                    "Bairro:"+widget.detalheCorrida["bairro_ponto"],
                    style:TextStyle(
                        fontSize:18.0,
                        color: Colors.white
                    ),
                  ),

                  SizedBox(height: 15.0,),
                  Text(
                  widget.detalheCorrida["quant_itens"]+" entregas",
                    style:TextStyle(fontSize:18.0,
                        color: Colors.white
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
                padding: EdgeInsets.all(20.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 200.0,
                        height: 50.0,
                        child:ElevatedButton.icon(
                            icon: Icon(FontAwesomeIcons.conciergeBell, color: Colors.white54,size:18.0,),
                            label:Text(ButtonTxt),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),

                              primary:ColorButton,
                              //  onPrimary: Colors.white,
                              onSurface: Colors.grey,
                              shape: const BeveledRectangleBorder
                                (borderRadius: BorderRadius.all(Radius.circular(5))),

                              textStyle: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 20,
                                  fontFamily: "Brand Bold"
                                  ,fontWeight: FontWeight.bold
                              ),
                            ),

                          onPressed:()async {

                            if(!_clicked){
                              setState(() {
                             _clicked=true;
                             ButtonTxt="Aguarde...";
                             ColorButton=Colors.grey[800];
                           });

                             result = await apiOrderController.accepted(
                                 widget.detalheCorrida["id_doc"]);


                            print("result::::");
                            print(result);
                           Valor(result);

                          };
                          },
                    ),
                    ),
                  ],
                ))



          ],
        ),
      ),
    );
  }

  Valor(int valor){
    switch(valor){

      case 200:
        setState(() {
          ButtonTxt="Aceito";
          ColorButton=Colors.green[800];
        });
        TimeClosed();
        break;
      case 398:
        setState(() {
          ButtonTxt="PEGARAM";
          ColorButton=Colors.red[800];
        });
        TimeClosed();
        break;
      case 399:
        setState(() {
          ButtonTxt="CANCELADO";
          ColorButton=Colors.red[800];
        });
        TimeClosed();
        break;
      case 400:
        setState(() {
          ButtonTxt="PEGARAM";
          ColorButton=Colors.red[800];
        });
        TimeClosed();
        break;
      case 403:
        setState(() {
          ButtonTxt="FIQUE ON-LINE";
          ColorButton=Colors.red[800];
        });
        TimeClosed();
        break;
      case 404:
        setState(() {
          ButtonTxt="NÃO EXISTE MAIS";
          ColorButton=Colors.red[800];
        });
        TimeClosed();
        break;
    }
  }

  TimeClosed() {
  if (debounce?.isActive ?? false) debounce!.cancel();
  debounce = Timer(const Duration(milliseconds: 1000), () {
    Navigator.of(context).pop();
  });
}
}