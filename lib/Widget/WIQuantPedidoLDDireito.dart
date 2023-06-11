import 'package:breathing_collection/breathing_collection.dart';
import 'package:flutter/material.dart';

class WIQuantPedidoLDDireito extends StatelessWidget {
  final Function() callback;
  var _N_Pedidos;
  WIQuantPedidoLDDireito({
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 160.0,
      right: 22.0,
      child: Column(
        children:[ Container(
            decoration: BoxDecoration(
                //   color: Colors.white,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ))
                ]),
            child: BreathingGlowingButton(
              width:45,
              height:45,
              icon:Icons.watch_later_outlined,
              glowColor: Colors.redAccent,
              onTap:callback,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text("Pendência",
            style: TextStyle(color: Colors.white,fontFamily:'Brand Bold'),)
        ]
      ),

    );

  }
/*child:Badge(badgeContent: Text("0"),

              )*/
}
