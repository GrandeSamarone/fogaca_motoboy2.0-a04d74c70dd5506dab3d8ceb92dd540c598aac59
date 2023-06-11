import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Widget/WIBusy.dart';
import 'package:fogaca_app/Widget/WIDivider.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:fogaca_app/api/controller/api_order_controller.dart';
import 'package:http/http.dart';

import '../../../api/Api.dart';

class order_cancel extends StatefulWidget {
  order_cancelState createState() => order_cancelState();
  static const String idScreen = "Tela_Cancelar_Pedido";

  String? id_doc;

  order_cancel({required this.id_doc});
}

class order_cancelState extends State<order_cancel> {
  List<Pedido>? pedidos;
  Pedido detalheCorrida = Pedido();
  Color? ColorButton = Colors.white;
  late Size size;
  bool opcao = false;
  bool busy = false;
  String? _escolhaUsuario;
  var escolhaint;
  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        return _moveToSignInScreen(context);
      },
      child: Stack(children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, left: 10),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, top: 15.0, right: 25.0, bottom: 20.0),
                    child: WIBusy(
                      busy: busy,
                      child: Column(
                        children: [
                          SizedBox(height: 15.0),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    _moveToSignInScreen(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.0),
                              Center(
                                child: Text(
                                  "Informe o motivo do \n cancelamento",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontFamily: "Brand Bold",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: ThemeData(
                                //here change to your color
                                unselectedWidgetColor: Colors.white,
                                disabledColor: Colors.yellowAccent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: RadioListTile(
                                activeColor: Colors.redAccent,
                                value: "Aceitei por engano",
                                groupValue: _escolhaUsuario,
                                onChanged: (value) {
                                  setState(() {
                                    _escolhaUsuario = value as String?;
                                  });
                                },
                                title: Text(
                                  "Aceitei por engano",
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          WIDividerWidget(),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: ThemeData(
                                //here change to your color
                                unselectedWidgetColor: Colors.white,
                                disabledColor: Colors.yellowAccent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: RadioListTile(
                                activeColor: Colors.redAccent,
                                value:
                                    "Tive problemas no trajeto até o local da coleta",
                                groupValue: _escolhaUsuario,
                                onChanged: (value) {
                                  setState(() {
                                    _escolhaUsuario = value as String?;
                                  });
                                },
                                title: Text(
                                  "Tive problemas no trajeto até o local da coleta",
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          WIDividerWidget(),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: ThemeData(
                                //here change to your color
                                unselectedWidgetColor: Colors.white,
                                disabledColor: Colors.yellowAccent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: RadioListTile(
                                activeColor: Colors.redAccent,
                                value: "Errei o caminho",
                                groupValue: _escolhaUsuario,
                                onChanged: (value) {
                                  setState(() {
                                    _escolhaUsuario = value as String?;
                                  });
                                },
                                title: Text(
                                  "Errei o caminho",
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          WIDividerWidget(),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: ThemeData(
                                //here change to your color
                                unselectedWidgetColor: Colors.white,
                                disabledColor: Colors.yellowAccent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: RadioListTile(
                                activeColor: Colors.redAccent,
                                value:
                                    "Não vale a pena ir até o local da coleta",
                                groupValue: _escolhaUsuario,
                                onChanged: (value) {
                                  setState(() {
                                    _escolhaUsuario = value as String?;
                                  });
                                },
                                title: Text(
                                  "O cliente vai retirar no local",
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          WIDividerWidget(),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: ThemeData(
                                //here change to your color
                                unselectedWidgetColor: Colors.white,
                                disabledColor: Colors.yellowAccent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: RadioListTile(
                                activeColor: Colors.redAccent,
                                value: "Local da coleta não é seguro",
                                groupValue: _escolhaUsuario,
                                onChanged: (value) {
                                  setState(() {
                                    _escolhaUsuario = value as String?;
                                  });
                                },
                                title: Text(
                                  "Local da coleta não é seguro",
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          WIDividerWidget(),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: ThemeData(
                                //here change to your color
                                unselectedWidgetColor: Colors.white,
                                disabledColor: Colors.yellowAccent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: RadioListTile(
                                activeColor: Colors.redAccent,
                                value: "Problema na moto",
                                groupValue: _escolhaUsuario,
                                onChanged: (value) {
                                  setState(() {
                                    _escolhaUsuario = value as String?;
                                  });
                                },
                                title: Text(
                                  "Problema na moto",
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          WIDividerWidget(),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Theme(
                              data: ThemeData(
                                //here change to your color
                                unselectedWidgetColor: Colors.white,
                                disabledColor: Colors.yellowAccent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: RadioListTile(
                                activeColor: Colors.redAccent,
                                value: "O Cliente pediu pra cancelar",
                                groupValue: _escolhaUsuario,
                                onChanged: (value) {
                                  setState(() {
                                    _escolhaUsuario = value as String?;
                                  });
                                },
                                title: Text(
                                  "O Cliente pediu pra cancelar",
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          WIDividerWidget(),
                          SizedBox(height: 30.0),
                          Container(
                              width: 300.0,
                              height: 50.0,
                              child: ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  label: Text('Confirmar'),
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),

                                    primary: Colors.red[900],
                                    //  onPrimary: Colors.white,
                                    onSurface: Colors.grey,
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),

                                    textStyle: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 20,
                                        fontFamily: "Brand Bold",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    if(_escolhaUsuario!=null){
                                      CancelarPedido();
                                    }else{
                                      ToastMensagem("Selecione um motivo.", context);
                                    }

                                  }))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void ResultadoBox(String resultado) {
    setState(() {
      _escolhaUsuario = resultado;
    });
  }

  _moveToSignInScreen(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> CancelarPedido() async {
    var apiOrderController = ApiOrderController(context);
    setState(() {
      busy = true;
    });
    try {
      Map<String, dynamic> dados = Map();
      dados["motivo_cancel"] = _escolhaUsuario;
      dados["id_usuario"] = auth.currentUser!.uid;
      dados["id_doc"] = widget.id_doc;
      Response response = await post(Uri.parse(await Api.Host() + "/mtboy_canceled"),
          headers: {
            "Authorization": await auth.currentUser!.getIdToken(),
            "type": "1"
          },
          body: dados);

      if (response.statusCode == 200) {
        setState(() {
          busy = false;
        });
        ToastMensagem("Pedido cancelado", context);
        Navigator.of(context).pop(false);
        Navigator.of(context).pop(false);
      } else if (response.statusCode == 399) {
        setState(() {
          busy = false;
        });
        ToastMensagem("O pedido já foi aceito.", context);
      } else {
        setState(() {
          busy = false;
        });
        throw new Exception("Não foi possível atualizar o pedido");
      }
    } catch (e) {
      ToastMensagem(e.toString(), context);
      setState(() {
        busy = false;
      });
    }
  }
}
