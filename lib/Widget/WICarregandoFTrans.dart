import 'dart:ffi';

import 'package:flutter/material.dart';

class WICarregandoFTrans extends StatefulWidget {
  @override
  _WICarregandoState createState() => _WICarregandoState();
}

class _WICarregandoState extends State<WICarregandoFTrans>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  var animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.transparent,
      alignment: Alignment.topCenter,
      child: Container(
        width: 60,
        height: 60,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Color(0xf2c83535),
            borderRadius: BorderRadius.circular(500),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(180),
                spreadRadius: 0,
                blurRadius: 8,
              )
            ]),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
          value: null,
        ),
      ),
    );
  }
}
