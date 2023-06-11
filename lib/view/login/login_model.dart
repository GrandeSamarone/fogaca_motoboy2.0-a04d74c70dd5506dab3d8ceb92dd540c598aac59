import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:fogaca_app/Assistencia/SocialSignInModel.dart';

import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Page/SplashScreen.dart';
import 'package:fogaca_app/Widget/WiAlerts.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../Assistencia/SharedPreference.dart';
import '../../Interfaces/InterfaceLocalStorage.dart';
import 'login_view.dart';

abstract class LoginModel extends State<LoginView> with SocialSignInModel {
  Motoboy? lojista;
  var isRegister = false;
  var loading = false;
  var isReset = false;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var scaffold = GlobalKey<ScaffoldState>();
  var busy = false;
  String? email;
  String? senha;
  final formKey = GlobalKey<FormState>();
  late Size size;
  final _formKey = GlobalKey<FormState>();
  final ILocalStorage iLocalStorage = SharedPreference();

  @override
  void initState() {

  }

  Widget LoginButton() {
    return TextButton(
        style: ButtonStyle(
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14)),
          overlayColor: MaterialStateProperty.all(Colors.white.withAlpha(50)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width))),
          backgroundColor: MaterialStateProperty.all(Color(0xf2c83535)),
        ),
        child: Container(
          alignment: Alignment.center,
          //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(
            "ENTRAR",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        onPressed: () {
          signIn();
        });
  }

  signIn() {
    setState(() {
      loading = true;
    });
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      LoginEmail(email!.trim(), senha!.trim()).then((data) {
        print("INFORMAÇÃO RETORNADA::" + data.toString());

        if (data.toString() == "sucesso") {
          onSucessEmail();
        } else if (data.toString() ==
            "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
          WiAlerts.of(context).snack("Senha incorreta.");
        } else if (data.toString() ==
            "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
          WiAlerts.of(context).snack("Conta não cadastrada.");
        } else if (data.toString() == "esta conta não existe.") {
          WiAlerts.of(context).snack("esta conta nao existe.");
        }
      }).catchError((err) {
        onErrorEmail(err.toString());
      }).whenComplete(() {
        onCompleteEmail();
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  onSucessEmail() {
    Navigator.pushNamedAndRemoveUntil(
        context, SplashScreen.idScreen, (route) => false);
  }

  onErrorEmail(String erro) {
    print("Erro::" + erro);
  }

  onCompleteEmail() {
    setState(() {
      loading = false;
    });
  }

  late PersistentBottomSheetController bottom;
  void TrocarSenha() {
    setState(() {
      isReset = true;
      print("TROCAR SENHA::$isReset");
    });
    var resetEmailController = TextEditingController();
    bool load = false;
    bottom = scaffold.currentState!.showBottomSheet((c) {
      return Container(
        decoration: BoxDecoration(color: Color(0xFF4B4343), boxShadow: [
          new BoxShadow(
              color: Colors.black45,
              offset: new Offset(1, 2.0),
              blurRadius: 5,
              spreadRadius: 2)
        ]),
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        height: size.height / 2,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  "Insira o endereço de e-mail associado à sua conta, siga o link "
                  "no e-mail enviado a você para escolher uma nova senha.",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Brand-Regular",
                      color: const Color(0xf2FDFDFD),
                      fontWeight: FontWeight.w700)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "E-mail",
                      style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xbfFDFDFD),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFF4B4343),
                        boxShadow: [
                          new BoxShadow(
                              color: Colors.black45,
                              offset: new Offset(1, 2.0),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ]),
                    child: TextFormField(
                      controller: resetEmailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '*e-mail é obrigatório.';
                        } else if (Validator.email(value)) {
                          return '*Digite um e-mail válido.';
                        } else if (value.contains(" ")) {
                          return '*erro: e-mail contém espaço.';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(width: 2, color: Color(0x8dc83535))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(width: 2, color: Color(0x8dc83535)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(width: 2, color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(width: 2, color: Colors.red),
                        ),
                        labelStyle: TextStyle(
                          fontFamily: "Brand-Regular",
                          color: const Color(0xFFCECACA),
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                        hintStyle: TextStyle(
                          color: const Color(0xFFCECACA),
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(
                        color: const Color(0xFFCECACA),
                        fontSize: 14.0,
                        fontFamily: "Brand-Regular",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              TextButton(
                style: ButtonStyle(
                  overlayColor:
                      MaterialStateProperty.all(Colors.white.withAlpha(50)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width))),
                  backgroundColor: MaterialStateProperty.all(Color(0xf2c83535)),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  child: load
                      ? Center(
                          child: Container(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              value: null,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        )
                      : Text(
                          "Enviar",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                ),
                onPressed: () async {
                  {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (resetEmailController.text.isNotEmpty) {
                        bottom.setState!(() {
                          load = true;
                        });

                        sendPasswordResetEmail(resetEmailController.text)
                            .then((dados_retornados) {
                          print("Dados Retornados::" +
                              dados_retornados.toString());
                          bottom.setState!(() {
                            load = false;
                          });
                          if (dados_retornados.toString() ==
                              "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.") {
                            WiAlerts.of(context).snack(
                                "Tentativas excedidas,tente novamente mais tarde.");
                          } else if (dados_retornados.toString() ==
                              "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
                            WiAlerts.of(context)
                                .snack("E-mail não encontrado.");
                          } else if (dados_retornados.toString() ==
                              "[firebase_auth/unknown] com.google.firebase.FirebaseException: An internal error has occurred.") {
                            WiAlerts.of(context).snack(
                                "Ocorreu um erro, tente novamente mais tarde.");
                          } else if (dados_retornados.toString() ==
                              "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.") {
                            WiAlerts.of(context).snack(
                                "Tentativas excedidas,tente novamente mais tarde.");
                          } else if (dados_retornados == null) {
                            WiAlerts.of(context).snack(
                                "E-mail Enviado,verifique sua caixa de mensagem.");
                          }
                        });
                      } else {
                        WiAlerts.of(context).snack("Digite um e-mail.");
                      }
                    }
                  }
                },
              )
            ],
          ),
        ),
      );
    });
    bottom.closed.then((value) {
      setState(() {
        isReset = false;
      });
    });
  }
}
