import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flux_validator_dart/flux_validator_dart.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Widget/WICarregando.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:fogaca_app/Widget/WiAlerts.dart';
import 'package:fogaca_app/Widget/WiDialog.dart';
import 'package:fogaca_app/view/profile/profile_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';

class Tela_updatedados extends StatefulWidget {
  const Tela_updatedados({Key? key}) : super(key: key);

  @override
  _Tela_updatedados createState() => _Tela_updatedados();
}

class _Tela_updatedados extends ProfileModel {

  @override
  void initState() {
    super.initState();

    var userController = Get.find<UserController>();
    if (userController.motoboy != null) {
      nomeController.text = userController.motoboy!.nome;
      telefoneController.text = userController.motoboy!.telefone;
      corController.text = userController.motoboy!.cor;
      placaController.text = userController.motoboy!.placa;
      modeloController.text = userController.motoboy!.modelo;
      dropdownValue = dropdownValue != "Selecione uma cidade"
          ? dropdownValue
          : userController.motoboy!.cidade;
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    var wiCarregando = WICarregando();
    return GetBuilder<UserController>(builder: (userController) {

      return Stack(children: [
        Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding:EdgeInsets.only(
                        top: 20,
                        left: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topLeft,
                    child:TextButton.icon(
                        onPressed:(){
                          Navigator.of(context).pop();
                        },
                        icon:  Icon(Icons.arrow_back,
                            color: Colors.white),
                        label:Text("")) ,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: Color(0xFF4B4343),
                          boxShadow: [
                            new BoxShadow(
                                color: Colors.black45,
                                offset: new Offset(1, 2.0),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ]),
                      padding: EdgeInsets.only(
                        left: 40,
                        right: 40,
                        bottom: 20,
                      ),
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(children: [

                            TextFormField(
                              controller: nomeController,
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              maxLength: 35,

                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '*Digite um nome.';
                                } else if (value.length < 4) {
                                  return '*mínimo 4 caracteres.';
                                }
                                return null;
                              },
                              //onSaved: (input) => _nome = input,

                              decoration: InputDecoration(
                                  labelText: "Nome:",
                                  labelStyle: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    color: const Color(0xFFCECACA),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  counterStyle: TextStyle(
                                    color: const Color(0xFFCECACA),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  hintStyle: TextStyle(
                                    color: const Color(0xFFB6B2B2),
                                    fontSize: 10.0,
                                  )),
                              style: TextStyle(
                                color: const Color(0xffFDFDFD),
                                fontSize: 14.0,
                                fontFamily: "Brand-Regular",
                              ),
                            ),
                            TextFormField(
                              controller: telefoneController,
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.phone,
                              obscureText: false,
                              maxLength: 12,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '*número de telefone é obrigatório.';
                                } else if (Validator.phone(value)) {
                                  return '*Digite um numero válido.';
                                }
                                return null;
                              },
                              onSaved: (input) {
                                // _tel=input;
                              },
                              decoration: InputDecoration(
                                  labelText: "Telefone",
                                  labelStyle: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    color: const Color(0xFFB6B2B2),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  counterStyle: TextStyle(
                                    color: const Color(0xFFCECACA),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  hintStyle: TextStyle(
                                    color: const Color(0xFFB6B2B2),
                                    fontSize: 10.0,
                                  )),
                              style: TextStyle(
                                color: const Color(0xffFDFDFD),
                                fontSize: 14.0,
                                fontFamily: "Brand-Regular",
                              ),
                            ),
                            TextFormField(
                              controller: modeloController,
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              maxLength: 15,

                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '*Digite um modelo.';
                                } else if (value.length < 4) {
                                  return '*mínimo 4 caracteres.';
                                }
                                return null;
                              },
                              //onSaved: (input) => _nome = input,

                              decoration: InputDecoration(
                                  labelText: "Moto:",
                                  labelStyle: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    color: const Color(0xFFCECACA),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  counterStyle: TextStyle(
                                    color: const Color(0xFFCECACA),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  hintStyle: TextStyle(
                                    color: const Color(0xFFB6B2B2),
                                    fontSize: 10.0,
                                  )),
                              style: TextStyle(
                                color: const Color(0xffFDFDFD),
                                fontSize: 14.0,
                                fontFamily: "Brand-Regular",
                              ),
                            ),
                            TextFormField(
                              controller: placaController,
                              textCapitalization: TextCapitalization.characters,
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              maxLength: 7,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '*Digite uma placa';
                                } else if (value.length < 7) {
                                  return '*mínimo 4 caracteres.';
                                } else if (Validator.carPlate(value)) {
                                  return '*incorreto.';
                                }
                                return null;
                              },
                              //onSaved: (input) => _nome = input,

                              decoration: InputDecoration(
                                  labelText: "Placa:",
                                  labelStyle: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    color: const Color(0xFFCECACA),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  counterStyle: TextStyle(
                                    color: const Color(0xFFCECACA),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  hintStyle: TextStyle(
                                    color: const Color(0xFFB6B2B2),
                                    fontSize: 10.0,
                                  )),
                              style: TextStyle(
                                color: const Color(0xffFDFDFD),
                                fontSize: 14.0,
                                fontFamily: "Brand-Regular",
                              ),
                            ),
                            TextFormField(
                              controller: corController,
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              maxLength: 15,

                              validator: (value) {
                                if (value!.isEmpty) {
                                  return '*Digite uma cor.';
                                } else if (value.length < 4) {
                                  return '*mínimo 4 caracteres.';
                                }
                                return null;
                              },
                              //onSaved: (input) => _nome = input,

                              decoration: InputDecoration(
                                  labelText: "Cor:",
                                  labelStyle: TextStyle(
                                    fontFamily: "Brand-Regular",
                                    color: const Color(0xFFCECACA),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                  counterStyle: TextStyle(
                                    color: const Color(0xFFCECACA),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: const Color(0x8dc83535), width: 2),
                                  ),
                                  hintStyle: TextStyle(
                                    color: const Color(0xFFB6B2B2),
                                    fontSize: 10.0,
                                  )),
                              style: TextStyle(
                                color: const Color(0xffFDFDFD),
                                fontSize: 14.0,
                                fontFamily: "Brand-Regular",
                              ),
                            ),
                            // Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     alignment: AlignmentDirectional.center,
                            //     decoration: BoxDecoration(
                            //       color: Color(0xFF665D5D),
                            //       borderRadius: BorderRadius.only(
                            //         topLeft: Radius.circular(12.0),
                            //         topRight: Radius.circular(12.0),
                            //         bottomLeft: Radius.circular(12.0),
                            //         bottomRight: Radius.circular(12.0),
                            //       ),
                            //     ),
                            //     padding: EdgeInsets.symmetric(horizontal: 16),
                            //     child: DropdownButton<String>(
                            //       isExpanded: true,
                            //       value: dropdownValue ?? "Selecione uma cidade",
                            //       dropdownColor: Color(0xFF4B4343),
                            //       icon: Icon(FontAwesomeIcons.chevronDown),
                            //       iconEnabledColor: Color(0xFFCECACA),
                            //       iconSize: 24,
                            //       elevation: 16,
                            //       style: TextStyle(
                            //           color: Color(0xFFCECACA),
                            //           fontSize: 14,
                            //           fontFamily: "Brand-Regular"),
                            //       underline: Container(
                            //         color: Color(0xFFCECACA),
                            //         height: 0,
                            //       ),
                            //       onChanged: (String? data) {
                            //         setState(() {
                            //           dropdownValue = data!;
                            //         });
                            //       },
                            //       items: List.generate(
                            //         userController.cities.length,
                            //             (index) => DropdownMenuItem<String>(
                            //           value: userController.cities[index],
                            //           child: Container(
                            //             child: Text(
                            //               userController.cities[index],
                            //               textAlign: TextAlign.center,
                            //             ),
                            //           ),
                            //         ),
                            //       ).toList(),
                            //     )),
                            SizedBox(
                              height: 20.0,
                            ),

                            Container(
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [Color(0xFFD52626), Color(0xFF901F1F)],
                                ),
                              ),
                              child: ElevatedButton(
                                child: Text("Atualizar"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 23,
                                      fontFamily: "Brand Bold",
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  //if (dropdownValue != "Selecione uma cidade") {
                                    AlterarDados();
                                  // } else {
                                  //   WiAlerts.of(context)
                                  //       .snack("Selecione uma cidade.");
                                  // }
                                },
                              ),
                            ),

                          ]),
                        ),
                      )),
                ],
              ),
            )),
        Visibility(
            child: Container(
              width: size.width,
              height: size.height,
              color: Colors.black.withAlpha(140),
            ),
            visible: busy),
        Visibility(visible: busy, child: wiCarregando),
      ]);
    });
  }
}