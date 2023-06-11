

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CPTextFieldForm extends StatelessWidget{

  final String ?labeltext;
  String Function() ?errotext;
  final bool ?obscureText;
  final TextCapitalization? textCapitalization;
  Function(String)? changed;
  final int? maxlenght;
  final TextInputType? type;
  TextEditingController? Controller = TextEditingController();
  CPTextFieldForm({
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
  Widget build(BuildContext context) {

    return TextFormField(
      onChanged:changed,
      controller: Controller,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration:InputDecoration(
          errorText:errotext==null?null:errotext!() ,
          labelText:labeltext,
          labelStyle:TextStyle(
            fontWeight:FontWeight.w400,
            fontSize: 12,
          )
      ),
      style:TextStyle(
          fontSize:16
      ),
    );
  }


}