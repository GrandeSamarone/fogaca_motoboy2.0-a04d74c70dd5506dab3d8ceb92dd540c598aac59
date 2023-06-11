

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CPButton extends StatelessWidget{

  final String ?text;
  final String ? imagem;
  final Function()? callback;
  final double ?width;
  final double ?height;
  CPButton({
    this.text,
    this.callback,
    this.imagem,
    this.width,
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Container(
      width:width!=null?width:200.0,
      height: height!=null?height:50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
              colors: [
                Color(0xFFC98740),
                Color(0xFFBB6C3F),
                 Color(0xFFC83535)
              ],
          ),
      ),
      child: ElevatedButton(
          child:Text(text!),
          style: ElevatedButton.styleFrom(

              primary: Colors.transparent,
            shadowColor: Colors.transparent,
            textStyle: TextStyle(

                color: Colors.white54,
                fontSize: 23,
                fontFamily: "Brand Bold"
                ,fontWeight: FontWeight.bold
            ),
          ),

          onPressed:callback
      ),

    );
          }





}