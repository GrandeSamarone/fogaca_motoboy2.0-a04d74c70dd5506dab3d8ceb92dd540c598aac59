import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/utils/Utils.dart';
import 'package:fogaca_app/view/order/fragments/done.dart';

import 'WIToast.dart';

class WIHistoricoItem extends StatelessWidget {
  Map<String, dynamic> pedido = new Map();
  WIHistoricoItem({required this.pedido});

  bool finalizado = false;
  String url =
      "https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Fcapacete.jpg?alt=media&token=55172947-3db3-4edd-9daa-93ceee0abd91";
  Color? ColorButton = Colors.grey[700];
  @override
  Widget build(BuildContext context) {
    if (pedido["situacao_id"] == FINALIZADO) {
      ColorButton = Colors.redAccent[700];
    } else if (pedido["situacao_id"] == ACEITO) {
      ColorButton = Colors.greenAccent[700];
    } else {
      ColorButton = Colors.yellow[700];
    }

    return Card(
      color: Color(0xFF4B4545),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
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
                    color: Colors.black26,
                    width: 3.0,
                  ),
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black12,
                        offset: new Offset(1, 2.0),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ]),
            ),
            title: new Text(pedido["situacao"],
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
                  new Text('Quantidade: ${pedido["quant_itens"]}',
                      style: new TextStyle(
                          fontSize: 11.0,
                          fontFamily: "Brand-Regular",
                          color: Colors.white70)),
                ]),
            //trailing: ,
            onTap: () {
              if(pedido["situacao_id"]=="4"){
                showModalBottomSheet(
                    context: context,
                    builder: (c) => Done(Pedido.fromFirestore(pedido)));   
              }else{
                ToastMensagem("O Pedido foi cancelado.", context);
              }
             
            },
          )
        ],
      ),
    );
  }
}
