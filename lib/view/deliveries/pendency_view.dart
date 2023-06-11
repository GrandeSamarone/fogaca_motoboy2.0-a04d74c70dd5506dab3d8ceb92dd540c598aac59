import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Widget/WIPedidoItem.dart';
import 'package:fogaca_app/Widget/WIPendencyItem.dart';
import 'package:fogaca_app/api/Api.dart';
import 'package:fogaca_app/utils/Utils.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';

class PendencyView extends StatelessWidget {
  var showAppBar;

  PendencyView({this.showAppBar: false});

  late Size size;


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GetBuilder<UserController>(builder: (userController) {

      final Query  result = FirebaseFirestore.instance
          .collection(PEDIDOS)
          .where('pendency', isEqualTo:true);


      return Scaffold(
        appBar: showAppBar
            ? new AppBar(
          backgroundColor: Colors.red.withAlpha(50),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: "",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: new Text("Pendência"),
        )
            : null,
        body: StreamBuilder<QuerySnapshot>(
          stream: result.snapshots(includeMetadataChanges: true),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text("Erro",style: TextStyle(color: Colors.white),));
            }
            if(snapshot.data!=null){
              print(snapshot.data!.metadata.isFromCache ? "Cached" : "Not Cached");
              if(snapshot.data!.metadata.isFromCache){
                FirebaseCrashlytics.instance.log("Cached ${userController.user!.uid} ");
              }

            }

            print("snapshot:::${snapshot.connectionState}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Text("Carregando...",style: TextStyle(color: Colors.white),));
            }

           else if (snapshot.connectionState == ConnectionState.active) {
              print("snapshot:::${snapshot.requireData.size}");
              if (snapshot.requireData.size > 0) {
                return ListView(children: <Widget>[
                  Column(
                    children:
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic>? pedidos = new Map();
                      pedidos = document.data() as Map<String, dynamic>?;

                      return WIPendencyItem(pedido: pedidos!);
                    }).toList(),
                  )
                ]);
              } else {
                return Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.watch_later_outlined,
                        size: 40,
                        color: Colors.white70,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        " (0) pedidos pendentes, Parabèns!",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )
                    ],
                  ),
                );
              }
            }
            return Container();
          },
        ),

      );

    });
  }
}
