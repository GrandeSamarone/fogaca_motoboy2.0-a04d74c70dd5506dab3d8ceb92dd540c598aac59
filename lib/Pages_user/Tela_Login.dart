import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:fogaca_app/Controllers/LoginController.dart';
import 'package:fogaca_app/Pages_user/Tela_Cadastro.dart';
import 'package:fogaca_app/Widget/WICarregando.dart';


class Tela_Login extends StatefulWidget{
  static const  String idScreen="login";

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends LoginController {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    return WillPopScope(
      onWillPop: () {
        return  _moveToSignInScreen(context);
      },
      child: Scaffold(
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
                              child: Image.asset("imagens/logoicon.png",
                                width: size.width * 0.50,),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Express Rondon Motoboys",
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
                            Container(

                              decoration:BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  color:Color(0xFF4B4343),
                                  boxShadow:[
                                    new BoxShadow(
                                        color:Colors.black45,
                                        offset:new Offset(1, 2.0),
                                        blurRadius: 5,
                                        spreadRadius: 2
                                    )
                                  ]
                              ),
                              child: TextFormField(

                                controller: emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '*e-mail é obrigatório.';
                                  }else if(Validator.email(value)){
                                    return '*Digite um e-mail válido.';
                                  }else if(value.contains(" ")){
                                    return '*erro: e-mail contém espaço.';
                                  }
                                  return null;
                                },
                                onSaved: (input) => email = input,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText:"E-mail",

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        width: 2,  color:Color(0x8dc83535)),
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
                                  labelStyle:TextStyle(
                                    fontFamily: "Brand-Regular",
                                    color: const Color(0xFFCECACA),
                                    fontWeight:FontWeight.w400,
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
                                  fontFamily: "Brand-Regular",),

                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),

                            Container(
                              decoration:BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  color:Color(0xFF4B4343),
                                  boxShadow:[
                                    new BoxShadow(
                                        color:Colors.black45,
                                        offset:new Offset(1, 2.0),
                                        blurRadius: 5,
                                        spreadRadius: 2
                                    )
                                  ]
                              ),
                              child: TextFormField(
                                controller: passwordController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "*Digite uma senha." ;
                                  }else if(value.length<=5){
                                    return '*Senha no mínimo 6 dígitos';
                                  }
                                  return null;
                                },
                                onSaved: (input) => senha = input,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText:"Senha",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          width: 2,  color:Color(0x8dc83535))
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
                                  labelStyle:TextStyle(
                                    fontFamily: "Brand-Regular",
                                    color: const Color(0xFFCECACA),
                                    fontWeight:FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                                style: TextStyle(
                                  color: const Color(0xFFCECACA),
                                  fontSize: 14.0,
                                  fontFamily: "Brand-Regular",),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 4, top: 8),
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed:(){
                                 TrocarSenha();
                                }, child: Text(
                                "Esqueceu a senha?",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xffFDFDFD),
                                    fontFamily:"Brand-Regular",
                                    fontWeight: FontWeight.w100),
                              ),
                              )
                            ),

                            SizedBox(height: 16,),


                            LoginButton(),

                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text("Não tem uma conta?",
                                    style: TextStyle(
                                      color: const Color(0xf2FDFDFD),
                                      fontFamily:"Brand-Regular",
                                      fontWeight: FontWeight.w100,
                                    ),),
                                ),
                                TextButton(
                                    onPressed:(){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Tela_Cadastro()
                                          )
                                      );
                                    }, child:Text(
                                  "Cadastre-se!",
                                  style: TextStyle(
                                      color:Color(0xffc83535),
                                      fontFamily: "Brand-Regular",
                                      fontWeight: FontWeight.bold),
                                ),
                                )

                              ],
                            ),
                            SizedBox(height: 12,),
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
        floatingActionButton: isReset?FloatingActionButton.extended(
          onPressed: (){
            Navigator.pop(context);
            setState(() {
              isReset=false;
            });
          },
          label: Text("Fechar"),
          icon: Icon( Icons.cancel),
        ):null,
      ),
    );
  }
  _moveToSignInScreen(BuildContext context) {
  }

}




