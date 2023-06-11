import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Controllers/order_controller.dart';
import '../../Controllers/user_controller.dart';
import '../../Widget/WIChatItem.dart';
import '../../Widget/WIPedidoItem.dart';
import '../../api/Api.dart';
import '../../utils/Utils.dart';

class ChatListView extends StatelessWidget {

  static var id_screen = "chat_list";

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

      return Consumer<OrderController>(builder: (c, orderController, child) {
        return Scaffold(
          appBar: new AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: SizedBox(),
            leadingWidth: 0,
            title: Center(
              child: new Text(
                "Conversas",
                style: TextStyle(
                    fontFamily: 'Brand Bold',
                    fontWeight: FontWeight.w700,
                    fontSize: 22),
              ),
            ),
          ),
          body: Column(
            children: [
              Flexible(
                child: orderController.orderListChamada.length > 0
                    ? RefreshIndicator(
                  onRefresh: () {
                    orderController.listenchamadas();
                    return Future.delayed(Duration(seconds: 1));
                  },
                  child: ListView.builder(
                      itemCount: orderController.orderListChamada.length,
                      itemBuilder: (c, i) {
                        return WIChatItem(
                            pedido: orderController.orderListChamada[i]);
                      }),
                )
                    : RefreshIndicator(
                  onRefresh: () {
                    orderController.listenchamadas();
                    return Future.delayed(Duration(seconds: 1));
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height * 0.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.chat
                            ,size:50,
                            color: Colors.white70,),
                          Text(
                            "Aqui suas conversas com clientes.",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white70),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
  }
}
