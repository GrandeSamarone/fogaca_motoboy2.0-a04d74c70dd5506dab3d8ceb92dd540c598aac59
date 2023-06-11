import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:fogaca_app/Pages_user/Tela_Cadastro.dart';
import 'package:fogaca_app/Widget/WICarregando.dart';
import 'package:fogaca_app/view/register/register_view.dart';

import 'login_model.dart';

class LoginView extends StatefulWidget {
  static const String idScreen = "login";
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends LoginModel {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffold,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: padding.top,
                ),
                Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Hero(
                            tag: "logo",
                            child: Image.asset(
                              "imagens/logoicon.png",
                              width: size.width * 0.50,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Fogaça MOTOBOYS",
                          style: TextStyle(
                              fontFamily: "Brand Bold",
                              color: Color(0xf2c83535),
                              fontSize: 22,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w800),
                        )
                      ],
                    )),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: size.width * 0.1, right: size.width * 0.1),
                    child: Form(
                      key: formKey,
                      child: ListView(
                        children: [
                          Card(
                            elevation: 1,
                            child: TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '*e-mail é obrigatório.';
                                }  else if (value.contains(" ")) {
                                  return '*erro: e-mail contém espaço.';
                                }
                                else if (Validator.email(value)) {
                                  return '*Digite um e-mail válido.';
                                }
                                return null;
                              },
                              onSaved: (input) => email = input,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s")),
                             //   FilteringTextInputFormatter.allow(RegExp("[a-z,@,.,0-9,_,-]")),
                              ],
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                labelText: "E-mail",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.red),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
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
                          SizedBox(
                            height: 12,
                          ),
                          Card(
                            elevation: 1,
                            child: TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "*Digite uma senha.";
                                } else if (value.length <= 5) {
                                  return '*Senha no mínimo 6 dígitos';
                                }
                                return null;
                              },
                              onSaved: (input) => senha = input,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                labelText: "Senha",
                                // enabledBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(8),
                                //   borderSide: BorderSide(
                                //       width: 1, color: Color(0x8dc83535)),
                                // ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.red,
                                    )),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      BorderSide(width: 2, color: Colors.red),
                                ),
                                labelStyle: TextStyle(
                                  fontFamily: "Brand-Regular",
                                  color: const Color(0xFFCECACA),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                              style: TextStyle(
                                color: const Color(0xFFCECACA),
                                fontSize: 14.0,
                                fontFamily: "Brand-Regular",
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 4),
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  TrocarSenha();
                                },
                                child: Text(
                                  "Esqueceu a senha?",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xffFDFDFD),
                                      fontFamily: "Brand-Regular",
                                      fontWeight: FontWeight.w100),
                                ),
                              )),
                          SizedBox(
                            height: 16,
                          ),
                          LoginButton(),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  "Não tem uma conta?",
                                  style: TextStyle(
                                    color: const Color(0xf2FDFDFD),
                                    fontFamily: "Brand-Regular",
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      Tela_Cadastro.idScreen);
                                },
                                child: Text(
                                  "Cadastre-se!",
                                  style: TextStyle(
                                      color: Color(0xffc83535),
                                      fontFamily: "Brand-Regular",
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
              child: Container(
                width: size.width,
                height: size.height,
                color: Colors.black.withAlpha(140),
              ),
              visible: isReset),
          Visibility(visible: loading, child: WICarregando()),
        ],
      ),
      floatingActionButton: isReset
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  isReset = false;
                });
              },
              label: Text("Fechar"),
              icon: Icon(Icons.cancel),
            )
          : null,
    );
  }
}
