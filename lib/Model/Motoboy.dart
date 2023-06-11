import 'package:google_maps_flutter/google_maps_flutter.dart';

class Motoboy {
  var _id;
  var _token;
  var _nome;
  var _tipo_user;
  var _icon_foto;
  var _tipo_dados;
  var _cpf_cnpj;
  var _email;
  var _senha;
  var _telefone;
  var _cidade;
  var _cod;
  var _modelo;
  var _cor;
  var _placa;
  var _permissao;
  var _online;
  var _estado;
  var _estrela;
  var _n_pedidos;
  var _avaiable;

  Motoboy();

  Map<String, dynamic> userDataMap() {
    Map<String, dynamic> userDataMap = {
      "id": this._id,
      "token": this._token,
      "nome": this._nome,
      "estrela": this._estrela,
      "email": this._email,
      "tipo_user": this._tipo_user,
      "tipo_dados": this.tipo_dados,
      "cpf_cnpj": this._cpf_cnpj,
      "permissao": false,
      "telefone": this._telefone,
      "icon_foto": "",
      "modelo": _modelo,
      "placa": _placa,
      "cidade": _cidade,
      "cod": cod,
      "cor": _cor,
      "online": false,
      "estado": "Rondônia",
      "n_pedidos": 0,
      "avaiable": true,
    };
    return userDataMap;
  }

  Motoboy.fromFirestore(Map<String, dynamic> dados)
      : _id = dados["id"],
        _token = dados["token"],
        _nome = dados["nome"],
        _estrela = dados["estrela"],
        _email = dados["email"],
        _icon_foto = dados["icon_foto"],
        _tipo_user = dados["tipo_user"],
        _tipo_dados = dados["tipo_dados"],
        _cpf_cnpj = dados["cpf_cnpj"],
        _permissao = dados["permissao"],
        _online = dados["online"],
        _estado = dados["estado"],
        _cidade = dados["cidade"],
        _cod = dados["cod"],
        _n_pedidos = dados["n_pedidos"],
        _modelo = dados["modelo"],
        _placa = dados["placa"],
        _cor = dados["cor"],
        _telefone = dados["telefone"],
        _avaiable = dados['avaiable'];

  String get cod => _cod;

  set cod(String value) {
    _cod = value;
  }

  bool get avaiable => _avaiable;

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get estrela => _estrela;

  set estrela(String value) {
    _estrela = value;
  }

  String get token => _token;

  set token(String value) {
    _token = value;
  }

  String get tipo_user => _tipo_user;

  set tipo_user(String value) {
    _tipo_user = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  bool get permissao => _permissao;

  set permissao(bool value) {
    _permissao = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get cpf_cnpj => _cpf_cnpj;

  set cpf_cnpj(String value) {
    _cpf_cnpj = value;
  }

  String get tipo_dados => _tipo_dados;

  set tipo_dados(String value) {
    _tipo_dados = value;
  }

  String get icon_foto => _icon_foto;

  set icon_foto(String value) {
    _icon_foto = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get modelo => _modelo;

  set modelo(String value) {
    _modelo = value;
  }

  String get cor => _cor;

  set cor(String value) {
    _cor = value;
  }

  String get placa => _placa;

  set placa(String value) {
    _placa = value;
  }

  bool get online => _online;

  set online(bool value) {
    _online = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  int get n_pedidos => _n_pedidos;

  set n_pedidos(int value) {
    _n_pedidos = value;
  }
}
