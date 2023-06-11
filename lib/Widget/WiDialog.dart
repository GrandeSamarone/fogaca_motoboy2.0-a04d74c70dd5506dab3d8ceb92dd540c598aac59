import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class WIDialog extends StatefulWidget {
  var titulo, msg, textoButton1,textoButton2;
  final String img;
  void Function()? button1;
  void Function()? button2;

  WIDialog({Key? key,
    this.titulo,
    this.msg,
    this.textoButton1,
    this.textoButton2,
    required this.img,
    this.button1,
    this.button2
  }) : super(key: key);

  @override
  _WIDialogState createState() => _WIDialogState();
}

class _WIDialogState extends State<WIDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20,top: 45
              + 20, right: 20,bottom:20
          ),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color:Color(0xFF363030),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.titulo,
                style: TextStyle(
                    fontSize: 22,
                    fontFamily:"Brand Bold",
                    fontWeight: FontWeight.w600,
                    color:Colors.white
                ),),
              SizedBox(height: 15,),
              Text(widget.msg,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily:"Brand-Regular",
                      color:Colors.white),
                  textAlign: TextAlign.center),
              SizedBox(height: 22,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
              TextButton(
                     onPressed: widget.button1,
                     child: Text(widget.textoButton1,
                       style: TextStyle(
                           fontSize: 18,
                           fontFamily:"Brand-Regular",
                           color:Colors.white
                       ),
                     ),
              ),
               TextButton(
                   onPressed: widget.button2,
                   child: Text(widget.textoButton2,
                     style: TextStyle(
                         fontSize: 18,
                         fontFamily:"Brand-Regular",
                         color:Colors.white),
                   ),
               )
             ],),

            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(45)),
                child: Image.asset(widget.img,width: 64,),
            ),
          ),
        ),
      ],
    );
  }
}