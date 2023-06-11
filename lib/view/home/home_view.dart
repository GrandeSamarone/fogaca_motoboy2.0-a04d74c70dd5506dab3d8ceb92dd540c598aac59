import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/LocationController.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Widget/WICarregandoBtnOnline.dart';
import 'package:fogaca_app/Widget/WIQuantPedidoLDDireito.dart';
import 'package:fogaca_app/Widget/WISplash.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:fogaca_app/utils/my_flutter_app_icons.dart';
import 'package:fogaca_app/view/deliveries/pendency_view.dart';
import 'package:fogaca_app/view/home/home_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as kit;
import 'package:provider/provider.dart';
import 'package:sliding_switch/sliding_switch.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends HomeModel {

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

      return GetBuilder<UserController>(builder: (userController) {
        return  Stack(children: [
            GoogleMap(
              padding: EdgeInsets.only(top: 300),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: LatLng(-10.877628756313518, -61.95153213548445),
                  zoom: 13.4746),
              onMapCreated: (GoogleMapController controller) {
                controller_Maps = controller;
                changeMapMode();
              },
            ),
            //online offline driver container
            Container(
                height: 140.00, width: double.infinity, color: Colors.black54),

            Consumer<OrderController>(builder: (c, orderController, child) {
              return Visibility(
                visible: orderController.ListPendency.isNotEmpty,
                child: WIQuantPedidoLDDireito(
                  callback: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PendencyView(
                                  showAppBar: true,
                                )
                        )
                    );
                  },
                ),
              );
            }),

            Positioned(
              top: 30.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Você está:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Brand Bold"),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      width: 200.0,
                      height: 50.0,
                      child: ElevatedButton.icon(
                          key:keyBotaoFicarOn,
                          icon: Icon(
                            Icons.motorcycle,
                            color: Colors.white54,
                            size: 25.0,
                          ),
                          label: userController.motoboy != null
                              ? Text(userController.status != 0
                                  ? userController.status == 1
                                      ? "ONLINE"
                                      : "OFFLINE"
                                  : "CARREGANDO")
                              : Text("CARREGANDO"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                            primary: userController.status != 0
                                ? userController.status == 1
                                    ? Colors.green
                                    : Colors.red
                                : Colors.grey,
                            //  onPrimary: Colors.white,
                            onSurface: Colors.grey,
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),

                            textStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 15,
                                fontFamily: "Brand Bold",
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {

                             VerificandoDados();
                          }),
                    ),
                  ),
                ],
              ),
            ),

            Visibility(
                child: Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.black.withAlpha(140),
                ),
                visible: Splash),
            Visibility(visible: Splash, child: WISplash()),

            Positioned(
              bottom: 28,
              key: keyPararChamada,
              left: size.width * 0.1,
              right: size.width * 0.1,
              child: userController.status == 1
                  ? GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        child: Container(
                          width: size.width * 0.7,
                          height: size.width * 0.13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withAlpha(200),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 16),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Liberado",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(),
                                  Container(
                                    margin: EdgeInsets.only(right: 16),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Bloqueado",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedContainer(
                                curve: Curves.ease,
                                alignment: userController.avaiable
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                duration: Duration(milliseconds: 400),
                                child: Container(
                                  width: size.width * 0.35,
                                  height: size.width * 0.15,
                                  child: Center(
                                    child: userController.avaiable
                                        ? Icon(
                                            FontAwesomeIcons.conciergeBell,
                                            color: Colors.white,
                                            size: size.width * 0.08,
                                          )
                                        : Icon(
                                            MyFlutterApp.concierge_bell_solid,
                                            color: Colors.white,
                                            size: size.width * 0.08,
                                          ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: userController.avaiable
                                          ? Colors.green
                                          : Theme.of(context).primaryColor),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        userController.setAvaiable(
                            !userController.avaiable, context);
                      },
                    )
                  : SizedBox(),
            ),
          ]);

      });
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
