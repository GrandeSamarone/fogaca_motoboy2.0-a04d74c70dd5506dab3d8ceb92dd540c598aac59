import 'package:app_tutorial/app_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fogaca_app/Controllers/order_controller.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Widget/WICarregando.dart';
import 'package:fogaca_app/Widget/WICustomFutureBuilder.dart';
import 'package:fogaca_app/utils/Utils.dart';
import 'package:fogaca_app/utils/Utils.dart';
import 'package:fogaca_app/utils/Utils.dart';
import 'package:fogaca_app/utils/Utils.dart';
import 'package:fogaca_app/utils/Utils.dart';
import 'package:fogaca_app/view/order/fragments/accepted.dart';
import 'package:fogaca_app/view/order/fragments/canceled.dart';
import 'package:fogaca_app/view/order/fragments/done.dart';
import 'package:fogaca_app/view/order/fragments/finish.dart';
import 'package:fogaca_app/view/order/fragments/on_way.dart';
import 'package:fogaca_app/view/order/order_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderView extends StatefulWidget {
  Pedido order;
  OrderView(this.order);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends OrderModel {
  late Pedido order;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.order = widget.order;

    init();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffold,
      body: SlidingUpPanel(
        defaultPanelState: PanelState.CLOSED,
        onPanelClosed: () {
          setState(() {
            isCollapsed = true;
          });
        },
        onPanelOpened: () {
          setState(() {
            isCollapsed = false;
          });
        },
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        minHeight: order != null && order.situacao_id == CARREGANDO
            ? size.height * 0.35
            : size.width * 0.45,
        maxHeight: order != null && order.situacao_id != CARREGANDO
            ? size.height * 0.80
            : size.height * 0.35,
        collapsed: Stack(
          children: [
            AnimatedOpacity(
                duration: Duration(milliseconds: 400),
                opacity: order.situacao_id == ACEITO ? 1 : 0,
                child: IgnorePointer(
                    ignoring: order.situacao_id != ACEITO,
                    child: IgnorePointer(
                        key: keybarrainferior,
                        ignoring: !isCollapsed,
                        child: Accepted.Header(order, size, context)))),
            AnimatedOpacity(
              duration: Duration(milliseconds: 400),
              opacity: order.situacao_id == SAIU_PARA_ENTREGA ? 1 : 0,
              child: IgnorePointer(
                  ignoring: order.situacao_id != SAIU_PARA_ENTREGA,
                  child: IgnorePointer(
                      ignoring: !isCollapsed,
                      child: OnWay.Header(order, size, context))),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 400),
              opacity: order.situacao_id == FINALIZADO ? 1 : 0,
              child: IgnorePointer(
                ignoring: order.situacao_id != FINALIZADO,
                child: IgnorePointer(
                    ignoring: !isCollapsed,
                    child: Finish.Header(order, size, context)),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 400),
              opacity: order.situacao_id == CANCELADO ? 1 : 0,
              child: IgnorePointer(
                ignoring: order.situacao_id != CANCELADO,
                child: IgnorePointer(
                    ignoring: !isCollapsed,
                    child: Canceled.Header(order, size, context)),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 400),
              opacity: order.situacao_id == CONCLUIDO ? 1 : 0,
              child: IgnorePointer(
                ignoring: order.situacao_id != CONCLUIDO,
                child: IgnorePointer(
                    ignoring: !isCollapsed,
                    child: Done.Header(order, size, context)),
              ),
            ),
          ],
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        backdropEnabled: false,
        panel: Container(
          child: Stack(
            children: [
              Visibility(
                visible: order.situacao_id == ACEITO,
                child: IgnorePointer(
                    ignoring: order.situacao_id != ACEITO,
                    child: Accepted(order)),
              ),
              Visibility(
                visible: order.situacao_id == SAIU_PARA_ENTREGA,
                child: IgnorePointer(
                    ignoring: order.situacao_id != SAIU_PARA_ENTREGA,
                    child: OnWay(order)),
              ),
              Visibility(
                visible: order.situacao_id == FINALIZADO,
                child: IgnorePointer(
                    ignoring: order.situacao_id != FINALIZADO,
                    child: Finish(order)),
              ),
              Visibility(
                visible: order.situacao_id == CANCELADO,
                child: IgnorePointer(
                    ignoring: order.situacao_id != CANCELADO,
                    child: Canceled(order)),
              ),
              Visibility(
                visible: order.situacao_id == CONCLUIDO,
                child: IgnorePointer(
                    ignoring: order.situacao_id != CONCLUIDO,
                    child: Done(order)),
              )
            ],
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                tiltGesturesEnabled: true,
                // compassEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                markers: Set<Marker>.of(markers.values),
                polylines: polylines,

                initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(widget.order.lat_ponto),
                        double.parse(widget.order.long_ponto)),
                    zoom: 15.4746),
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  changeMapMode();
                },
              ),
            ),
            Positioned(
              top: 45.0,
              left: 22.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      //   color: Colors.white,
                      borderRadius: BorderRadius.circular(22.0),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).dialogBackgroundColor,
                            // color: Theme.of(context).textTheme.headline4.color,
                            blurRadius: 6.0,
                            spreadRadius: 0.5,
                            offset: Offset(
                              0.7,
                              0.7,
                            ))
                      ]),
                  //botao do drewaer
                  child: CircleAvatar(
                    //  backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_back, /*color: Colors.black*/
                    ),
                    radius: 20.0,
                  ),
                ),
              ),
            ),
            Visibility(
                child: Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.black.withAlpha(140),
                ),
                visible: loadingMap),
            Visibility(visible: loadingMap, child: WICarregando()),
          ],
        ),
      ),
    );
  }
}
