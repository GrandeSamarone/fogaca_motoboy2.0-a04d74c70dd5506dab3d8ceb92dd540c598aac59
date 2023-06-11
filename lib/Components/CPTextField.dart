
import 'package:flutter/material.dart';

class CPTextField extends StatefulWidget{

  final String? labeltext;
  String Function()? errotext;
  final bool ?obscureText;
  final TextCapitalization ?textCapitalization;
   Function(dynamic)? changed;
  final int ?maxlenght;
  final TextInputType ?type;
  TextEditingController ?Controller = TextEditingController();
  CPTextField({
    this.labeltext,
    this.changed,
    this.maxlenght,
    this.textCapitalization,
    this.obscureText,
    this.errotext,
  this.type,
   this.Controller,
  });

  @override
  _CPTextFieldState createState() => _CPTextFieldState();
}

class _CPTextFieldState extends State<CPTextField> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      TextField(
      maxLength:widget.maxlenght,
      controller: widget.Controller,
      keyboardType: widget.type,
      decoration: InputDecoration(
          labelText: widget.labeltext,
          errorText: widget.errotext==null?null:widget.errotext!(),
          labelStyle:TextStyle(
            fontWeight:FontWeight.w400,
            fontSize: 12,
          ),
          hintStyle: TextStyle(
            color: Theme
                .of(context)
                .textTheme
                .subtitle1
                !.color,
            fontSize: 10.0,
          )
      ),
      style: TextStyle(fontSize: 14.0),
    );
  }
}