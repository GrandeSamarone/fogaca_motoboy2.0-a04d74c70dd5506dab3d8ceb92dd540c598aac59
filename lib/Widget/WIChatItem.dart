import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Model/Pedido.dart';
import '../view/chat/Chat_Page.dart';
import 'WIToast.dart';

class WIChatItem extends StatelessWidget {
  Map<String, dynamic> pedido = Map();
  WIChatItem({required this.pedido});
  bool finalizado = false;
  Pedido pedidoescolhido=Pedido();
  String url =
      "https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Fcapacete.jpg?alt=media&token=55172947-3db3-4edd-9daa-93ceee0abd91";
  Color? ColorButton = Colors.white;
  String TxtAvaliar = "";
  @override
  Widget build(BuildContext context) {
    pedidoescolhido=Pedido.fromFirestore(pedido);
   // print("Situacao dos Pedidos:" + pedido["situacao"]);
    return Card(
      color: Color(0xFF4B4545),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Container(
                width:50,
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
              title: new Column(
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
                  ]),
              //trailing: ,
              onTap: () {
                SituacaoDoPedido(context);
              },
              trailing: Icon(Icons.forum,color: Colors.white60,),
            ),
            Text(TxtAvaliar,
                style: new TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: ColorButton)),
          ],
        ),
      ),
    );
  }

  SituacaoDoPedido(BuildContext context) {
   if (pedido["situacao"] == "Buscando...") {
     Navigator.of(context).pushNamed("order", arguments: {
       "isNew": true,
       "orderId": (pedido["id_doc"]),
       "source": LatLng(double.parse(pedido["lat_ponto"]),
           double.parse(pedido["long_ponto"])),
     });
    } else {
     Navigator.of(context).push(MaterialPageRoute(
       builder: (c) => // Chat_Page(pedido: pedido)
       Chat_Page( pedido:pedidoescolhido),
     ));

    }
  }
}
