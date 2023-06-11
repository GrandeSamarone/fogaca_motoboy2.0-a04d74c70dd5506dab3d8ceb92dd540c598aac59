import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WICarregandoBtnOnline extends StatefulWidget {

  final Function()? callback;

  WICarregandoBtnOnline({
    this.callback,
});

  @override
  _WICarregandoBtnOnlineState createState() => _WICarregandoBtnOnlineState();
}

class _WICarregandoBtnOnlineState extends State<WICarregandoBtnOnline>
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
      color: Colors.black.withAlpha(140),
      alignment: Alignment.center,
      child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
         Container(
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
            SizedBox(height:20.0),
          Container(
            width:150,
            height: 50.0,
            child: ElevatedButton.icon(
              icon: Icon(FontAwesomeIcons.times, color: Colors.white54,size:18.0,),
              label:Text("Cancelar"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),

                primary:Colors.red.shade800,
                //  onPrimary: Colors.white,
                onSurface: Colors.grey,
                shape: const BeveledRectangleBorder
                  (borderRadius: BorderRadius.all(Radius.circular(5))),

                textStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: 20,
                    fontFamily: "Brand Bold"
                    ,fontWeight: FontWeight.bold
                ),
              ),

              onPressed: widget.callback,
            ),
          )
    ]
      ),
    );
  }
}
