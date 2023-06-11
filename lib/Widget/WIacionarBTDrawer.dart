
import 'package:flutter/material.dart';

class WIacionarBTDrawer extends StatelessWidget{
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  final Function() ?callback;
  WIacionarBTDrawer({
    this.callback,
}
);

  @override
  Widget build(BuildContext context) {

    return  //botao do drawer
      Positioned(
        top: 45.0,
        left: 22.0,
        child: GestureDetector(
          onTap: callback,
          child: Container(
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
            //botao do drewaer
            child: CircleAvatar(
              //  backgroundColor: Colors.white,
              child: Icon(
                Icons.menu, /*color: Colors.black*/
              ),
              radius: 20.0,
            ),
          ),
        ),
      );
  }

}