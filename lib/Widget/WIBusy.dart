import 'package:flutter/material.dart';

class WIBusy extends StatelessWidget{
  bool busy =false;
  Widget ?child;

  WIBusy({
    required this.busy,
          this.child,
  });
  @override
  Widget build(BuildContext context) {

    return busy?
    Container(
      width: double.infinity,
      height: 100,
      child:Center(
        child: CircularProgressIndicator(),
      ),
    ):child!;

  }
}