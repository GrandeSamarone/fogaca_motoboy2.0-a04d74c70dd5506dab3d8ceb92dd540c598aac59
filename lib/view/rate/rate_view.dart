import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/view/rate/rate_model.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';

class RateView extends StatefulWidget {
  const RateView({Key? key}) : super(key: key);

  @override
  _RateViewState createState() => _RateViewState();
}

class _RateViewState extends RateModel {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      if (userController.motoboy != null) {
        estrelaDouble = double.parse(userController.motoboy!.estrela);
        num mod = pow(10.0, 2);
        estrela = ((estrelaDouble! * mod).round().toDouble() / mod).toString();
      }
      return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 50.0,
          ),
          Center(
            child: Text(
              estrela != null ? estrela : "",
              style: new TextStyle(
                fontSize: 65.0,
                color: Colors.white70,
                fontFamily: "Brand-Regular",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // RatingBar.builder(
          //   wrapAlignment: WrapAlignment.center,
          //   initialRating: estrelaDouble,
          //   minRating: 1,
          //   allowHalfRating: true,
          //   ignoreGestures: true,
          //   itemSize: 60,
          //   itemCount: 5,
          //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          //   itemBuilder: (context, _) => Icon(
          //     Icons.star,
          //     color: Colors.red.shade400,
          //   ),
          //   onRatingUpdate: (rating) {
          //     estrelaDouble = rating;
          //     print(rating);
          //   },
          // ),
        ]),
      );
    });
  }
}
