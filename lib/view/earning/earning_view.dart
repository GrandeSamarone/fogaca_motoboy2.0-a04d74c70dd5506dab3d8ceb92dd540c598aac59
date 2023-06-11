import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Widget/WIHistoricoItem.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'package:provider/provider.dart';

import 'earning_model.dart';

class EarningView extends EarningModel {
  @override
  Widget build(BuildContext context) {
    this.context = context;
    size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child:  Consumer<OrderController>(
                builder: (c, orderController, child) {
              var qtd = orderController.activeOrders.length;
              print("activeOrders");
              print(qtd);
              return Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: size.height * 0.3,
                      flexibleSpace: Card(
                          elevation: 2,
                          margin: EdgeInsets.all(0),
                          color: Theme.of(context).primaryColor,
                          child: Column(
                            children: [
                              AppBar(
                                elevation: 0,
                                title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filterNames[
                                            orderController.selectedFilter],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      orderController.selectedFilter == 4
                                          ? Text(
                                              "${format.format(orderController.initialDate)} até ${format.format(orderController.endDate)}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12))
                                          : SizedBox(),
                                    ]),
                                actions: [
                                  // IconButton(
                                  //   icon: Icon(
                                  //     Icons.filter_list,
                                  //     color: Colors.white,
                                  //   ),
                                  //   onPressed: () {
                                  //     selectFilter();
                                  //   },
                                  // ),
                                ],
                              ),

                              Expanded(
                                child: Center(
                                  child: Text(
                                    "${orderController.activeOrders.length} ${qtd == 1 ? 'Entrega' : 'Entregas'}",
                                    style: TextStyle(
                                        fontSize: size.height * 0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              // ListTile(
                              //   title: Text(
                              //     "50 Entregas",
                              //     style: TextStyle(
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // )
                            ],
                          )),
                      actions: [],
                    ),
                    SliverToBoxAdapter(
                        child: Column(
                            children: List.generate(
                      orderController.activeOrders.length,
                      (index) => WIHistoricoItem(
                          pedido: orderController.activeOrders[index]),
                    ))),
                  ],
                ),
              );
            }),

        ));
  }
}
