import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Model/Endereco.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Providers/Prov_AppData.dart';
import 'package:fogaca_app/Widget/WidialogNotification.dart';
import 'package:fogaca_app/view/order/order_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as kit;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'WIToast.dart';
import 'WiDialog.dart';

class WIPendencyItem extends StatelessWidget {
  final cityLondon = kit.LatLng(51.5073509, -0.1277583);
  final cityParis = kit.LatLng(48.856614, 2.3522219);
  Map<String, dynamic> pedido = Map();
  WIPendencyItem({required this.pedido});
  Endereco endereco = Endereco();
  bool finalizado = false;
  String situacao = "";
  double? DistanceInKM;
  String url =
      "https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Fcapacete.jpg?alt=media&token=55172947-3db3-4edd-9daa-93ceee0abd91";

  @override
  Widget build(BuildContext context) {
    var userposition = Get.find<UserController>();

    if (userposition.posicao != null) {
      print("position111");
      print(userposition.posicao!.latitude.toString());
      print(userposition.posicao!.longitude.toString());
      double distanceInMeters = Geolocator.distanceBetween(
              userposition.posicao!.latitude,
              userposition.posicao!.longitude,
              double.parse(pedido["lat_ponto"]),
              double.parse(pedido["long_ponto"])) /
          1000.0;

      DistanceInKM = double.parse((distanceInMeters).toStringAsFixed(1));
    }

    return Card(
      elevation: 3,
      color: Colors.redAccent.withAlpha(50),
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
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      pedido["nome_ponto"],
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Brand Bold",
                          color: Colors.white),
                    ), new Text(
                      pedido["bairro_ponto"],
                      style: new TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Brand Bold",
                          color: Colors.white),
                    ),new Text(
                      pedido["rua_ponto"],
                      style: new TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Brand Bold",
                          color: Colors.white),
                    ), new Text(
                      pedido["num_ponto"],
                      style: new TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Brand Bold",
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    new Text('${pedido["quant_itens"]} entregas',
                        style: new TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    SizedBox(
                      height: 10,
                    ),
                    DistanceInKM != null
                        ? new Text("${DistanceInKM} Km de Você",
                            style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                        : Container(),
                  ]),
              trailing: Icon(
                Icons.notifications_active,
                color: Colors.white70,
              ),
              //trailing: ,
              onTap: () {
                showDialog(
                    context: context,
                    //  barrierDismissible: false,
                    builder: (BuildContext context) =>
                        WidialogNotification(detalheCorrida: pedido));
              },
            )
          ],
        ),
      ),
    );
  }
}
