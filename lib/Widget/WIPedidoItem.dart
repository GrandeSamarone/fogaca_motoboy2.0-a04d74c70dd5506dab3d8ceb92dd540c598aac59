import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Endereco.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Providers/Prov_AppData.dart';
import 'package:fogaca_app/view/order/order_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../utils/my_flutter_app_icons.dart';
import 'WIToast.dart';
import 'WiDialog.dart';

class WIPedidoItem extends StatelessWidget {
  Map<String, dynamic> pedido = Map();
  WIPedidoItem({required this.pedido});
  Endereco endereco = Endereco();
  bool finalizado = false;
  String? situacao;
  String url =
      "https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Fcapacete.jpg?alt=media&token=55172947-3db3-4edd-9daa-93ceee0abd91";
  Color? ColorButton = Colors.grey[700];
  @override
  Widget build(BuildContext context) {
    situacao=pedido["situacao"];
    if (situacao == "Finalizado") {
      situacao="retorne ao cliente";
      ColorButton = Colors.yellow[700];
    } else if (situacao == "Corrida Aceita") {
      ColorButton = Colors.greenAccent[700];
    } else if (situacao == "Saiu Para Entrega")  {
      ColorButton = Colors.yellow[700];
    }

    // endereco.latitude=double.parse(pedido["cliente_lat"]);
    // endereco.longitude=double.parse(pedido["cliente_long"]);
    return Card(
      elevation: 3,
      color: Color(0xFF4B4545),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Container(
                width: 80,
                child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    onBackgroundImageError: (exception, stackTrace) {},
                    backgroundImage: pedido["icon_loja"] != ""
                        ? NetworkImage(pedido["icon_loja"])
                        : NetworkImage(url)),
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    border: new Border.all(
                      color: Colors.black.withOpacity(0.2),
                      width: 3.0,
                    ),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: new Offset(1, 2.0),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ]),
              ),
              title: new Text(situacao!,
                  style: new TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: ColorButton)),
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      pedido["nome_ponto"],
                      style: new TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Brand Bold",
                          color: Colors.white70),
                    ),
                    new Text(pedido["rua_ponto"],
                        style: new TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70)),
                    new Text(pedido["bairro_ponto"],
                        style: new TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70)),
                    new Text(pedido["num_ponto"],
                        style: new TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70)),
                    new Text('Quantidade: ${pedido["quant_itens"]}',
                        style: new TextStyle(
                            fontSize: 11.0,
                            fontFamily: "Brand-Regular",
                            color: Colors.white70)
                    ),
                  ]),
              //trailing: ,
              onTap: () {
                SituacaoDoPedido(context);
              },
              trailing: Icon(MyFlutterApp.bolsa,color: Colors.white60,),
            )
          ],
        ),
      ),
    );
  }

  SituacaoDoPedido(BuildContext context) {
    if (pedido["situacao"] == "Pedido Finalizado") {
      ToastMensagem("Pedido finalizado.", context);
    } else {
      VerificarGps(context);
    }
  }

  VerificarGps(BuildContext context) async {
    var loc = await Permission.location.status;
    var locAtivado =
        await Permission.locationWhenInUse.serviceStatus.isDisabled;
    if (loc.isDenied) {
      Permission.location.request();
    } else if (loc.isPermanentlyDenied) {
      Geolocator.openLocationSettings();
    } else if (locAtivado) {
      showDialog(
          context: context,
          builder: (BuildContext context) => WIDialog(
                titulo: "Ative sua localização",
                msg:
                    "Para  fazer esse tipo de pesquisa iremos precisar de sua localização.",
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
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderView(
                    Pedido.fromFirestore(pedido),
                  )));

    }
  }
}
