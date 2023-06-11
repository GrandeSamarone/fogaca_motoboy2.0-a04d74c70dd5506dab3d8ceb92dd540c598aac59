
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CPTextFormField extends StatefulWidget{

  final String ?labeltext;
  String Function() ?errotext;
  String Function(String?) ?validator;
  Function(String?) ?onSaved;
  final bool? obscureText;
  final TextCapitalization? textCapitalization;
  Function(dynamic) ?changed;
  final int? maxlenght;
  final TextInputType? type;
  TextEditingController ?Controller = TextEditingController();
  CPTextFormField({
    this.labeltext,
    this.changed,
    this.maxlenght,
    this.textCapitalization,
    this.obscureText,
    this.errotext,
    this.type,
    this.Controller,
   required this.validator,
    this.onSaved
  });

  @override
  _CPTextFieldState createState() => _CPTextFieldState();
}

class _CPTextFieldState extends State<CPTextFormField> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      TextFormField(
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
        textCapitalization: widget.textCapitalization!,
        validator:widget.validator,
        obscureText: widget.obscureText!,
        maxLength:widget.maxlenght,
        controller: widget.Controller,
        keyboardType: widget.type,

        onSaved:widget.onSaved,
        decoration: InputDecoration(
            labelText: widget.labeltext,
            labelStyle:TextStyle(
              fontFamily: "Brand-Regular",
              color: const Color(0xFF242323),
              fontWeight:FontWeight.w400,
              fontSize: 12,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color:const Color(0xFFC83535),
                  width:2
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(

                  color:const Color(0xFFC83535),
                  width:2
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                  color:const Color(0xFFC83535),
                  width:2
              ),
            ),
            hintStyle: TextStyle(
              color: const Color(0xFFB6B2B2),
              fontSize: 10.0,
            )
        ),
        style: TextStyle(
          color: const Color(0xFF242323),
          fontSize: 14.0,
          fontFamily: "Brand-Regular",),

      );
  }
}