import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';
import 'package:fogaca_app/Widget/WIPedidoItem.dart';
import 'package:fogaca_app/utils/my_flutter_app_icons.dart';
import 'package:provider/provider.dart';

class DeliveriesView extends StatelessWidget {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Consumer<OrderController>(builder: (c, orderController, child) {
      return Scaffold(
        body: orderController.orderListChamada.length > 0
            ? RefreshIndicator(
            onRefresh: () {
              orderController.init();
              return Future.delayed(Duration(seconds: 1));
            },
            child: ListView.builder(
                itemCount: orderController.orderListChamada.length,
                itemBuilder: (c, i) {
                  return WIPedidoItem(
                      pedido: orderController.orderListChamada[i]);
                }))
            : RefreshIndicator(
          onRefresh: () {
            orderController.init();
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
                    Icon(
                      MyFlutterApp.bolsa,
                      size: 60,
                      color: Colors.white70,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Você não possui corridas no momento",
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600),
                    )
                  ]),
            ),
          ),
        ),
      );
    });
  }
}