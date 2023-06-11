import 'package:flutter/material.dart';

class WiAlerts {
  var context;
  WiAlerts.of(this.context);
  snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style:TextStyle(
            color: Colors.white,
        fontFamily: "Brand Bold"),
        ),
        backgroundColor: Color(0xFF7F3131),
      ),
    );
  }
}