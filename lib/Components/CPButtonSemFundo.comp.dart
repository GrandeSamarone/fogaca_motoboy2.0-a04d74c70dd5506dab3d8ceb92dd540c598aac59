

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CPButtonSFundo extends StatelessWidget{

  final String ?text;
  final String  ?imagem;
  final Function() ?callback;
  final double ?width;
  final double ?height;
  final IconData ?icon;
  CPButtonSFundo({
    @required this.text,
    this.callback,
    this.imagem,
    this.width,
    this.height,
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  TextButton(

      child:Row(
        children:<Widget>[
          Container(
            height: height,
            width: width,
            child:Image.asset(imagem!),
          ),
          Text(text!)
        ],
      ),
      onPressed:callback
    );
          }





}