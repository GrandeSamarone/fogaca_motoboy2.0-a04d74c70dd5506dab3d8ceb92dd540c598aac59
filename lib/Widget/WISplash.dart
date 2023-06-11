import 'dart:ffi';

import 'package:flutter/material.dart';

class WISplash extends StatefulWidget {
  @override
  _WICarregandoState createState() => _WICarregandoState();
}

class _WICarregandoState extends State<WISplash>
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
    return Stack(
      children: [
         Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("imagens/screen_dark.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],





    );
  }
}
