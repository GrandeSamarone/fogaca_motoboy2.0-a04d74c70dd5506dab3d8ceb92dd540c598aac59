import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/utils/my_flutter_app_icons.dart';
import 'package:fogaca_app/view/deliveries/deliveries_view.dart';
import 'package:fogaca_app/view/deliveries/pendency_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class tab_view extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderController>(builder: (c, orderController, child) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(80.0),
                child: AppBar(
                  backgroundColor: Colors.red.withAlpha(90),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                          icon: Icon(FontAwesomeIcons.checkCircle),
                          text: "Aceitos"),
                      Tab(
                          icon: Icon(Icons.watch_later_outlined),
                          text: "Pendentes"),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  DeliveriesView(),
                  PendencyView(),
                ],
              )));
    });
  }
}
