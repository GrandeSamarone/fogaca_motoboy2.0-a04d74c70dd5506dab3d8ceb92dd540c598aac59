import 'package:flutter/material.dart';
import 'package:fogaca_app/view/register/register_view.dart';

abstract class RegisterModel extends StatelessWidget {
  var busy = false;
  final formKey = GlobalKey<FormState>();
  var nome;
  var tel;
  var senha;
  var repetirsenha;
  var email;
  var cpf_cnpj;
  var tipoDado;
  TextEditingController cpf_Controller = TextEditingController();
  TextEditingController cnpj_Controller = TextEditingController();
  bool CPFValid = false;
  bool CNPJValid = false;
}
