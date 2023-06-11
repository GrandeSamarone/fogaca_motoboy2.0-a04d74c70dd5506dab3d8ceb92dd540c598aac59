import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Pedido {
  var _id_usuario;
  var _id_doc;
  var _nome_ponto;
  var _token_ponto;
  var _icon_loja;
  var _telefone;
  var _situacao;
  var _end_ponto;
  var _bairro_ponto;
  var _num_ponto;
  var _distrito;
  var _lat_ponto;
  var _long_ponto;
  var _estado;
  var _quant_itens;
  var _boy_nome;
  var _boy_telefone;
  var _boy_moto_modelo;
  var _boy_moto_placa;
  var _boy_moto_cor;
  var _boy_foto;
  var _boy_token;
  var _boy_id;
  var _situacao_id;
  var _pendency;
  var comentario;
  var need_return;
  Timestamp? createdAt;
  Timestamp? acceptedAt;
  Timestamp? canceledAt;
  Timestamp? deliveredAt;
  Timestamp? deliveryAt;

  Pedido();



  Pedido.fromFirestore(Map<String, dynamic> dados)
      : _id_usuario = dados["id_usuario"],
        _id_doc = dados["id_doc"],
        _nome_ponto = dados["nome_ponto"],
        _token_ponto = dados["token_ponto"],
        _icon_loja = dados["icon_loja"],
        _telefone = dados["telefone"],
        _end_ponto = dados["rua_ponto"],
        _bairro_ponto = dados["bairro_ponto"],
        _num_ponto = dados["num_ponto"],
        _distrito = dados["distrito"],
        _situacao = dados["situacao"],
        _lat_ponto = dados["lat_ponto"],
        _long_ponto = dados["long_ponto"],
        _estado = dados["estado"],
        _pendency = dados["pendency"],
        _quant_itens = dados["quant_itens"],
        _boy_id = dados["boy_id"],
        _boy_nome = dados["boy_nome"],
        _boy_foto = dados["boy_foto"],
        _boy_token = dados["boy_token"],
        _boy_telefone = dados["boy_telefone"],
        _boy_moto_modelo = dados["boy_moto_modelo"],
        _boy_moto_placa = dados["boy_moto_placa"],
        _boy_moto_cor = dados["boy_moto_cor"],
        _situacao_id = dados["situacao_id"],
        createdAt = dados['createdAt'],
        acceptedAt = dados['acceptedAt'],
        canceledAt = dados['canceledAt'],
        deliveredAt = dados['deliveredAt'],
        deliveryAt = dados['deliveryAt'],
        need_return = dados['need_return'],
        comentario= dados['comentario'];


  String get boy_id => _boy_id;

  set boy_id(String value) {
    _boy_id = value;
  }

  String get token_ponto => _token_ponto;

  set token_ponto(String value) {
    _token_ponto = value;
  }

  String get boy_token => _boy_token;

  set boy_token(String value) {
    _boy_token = value;
  }

  get pendency => _pendency;

  set pendency(value) {
    _pendency = value;
  }



  String get icon_loja => _icon_loja;

  set icon_loja(String value) {
    _icon_loja = value;
  }

  String get quant_itens => _quant_itens;

  set quant_itens(String value) {
    _quant_itens = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get situacao => _situacao;

  set situacao(String value) {
    _situacao = value;
  }

  String get lat_ponto => _lat_ponto;

  set lat_ponto(String value) {
    _lat_ponto = value;
  }

  String get distrito => _distrito;

  set distrito(String value) {
    _distrito = value;
  }

  String get end_ponto => _end_ponto;

  set end_ponto(String value) {
    _end_ponto = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get nome_ponto => _nome_ponto;

  set nome_ponto(String value) {
    _nome_ponto = value;
  }

  String get id_doc => _id_doc;

  set id_doc(String value) {
    _id_doc = value;
  }

  String get id_usuario => _id_usuario;

  set id_usuario(String value) {
    _id_usuario = value;
  }

  String get boy_foto => _boy_foto;

  set boy_foto(String value) {
    _boy_foto = value;
  }

  String get boy_moto_cor => _boy_moto_cor;

  set boy_moto_cor(String value) {
    _boy_moto_cor = value;
  }

  String get boy_moto_placa => _boy_moto_placa;

  set boy_moto_placa(String value) {
    _boy_moto_placa = value;
  }

  String get boy_moto_modelo => _boy_moto_modelo;

  set boy_moto_modelo(String value) {
    _boy_moto_modelo = value;
  }

  String get boy_telefone => _boy_telefone;

  set boy_telefone(String value) {
    _boy_telefone = value;
  }

  String get boy_nome => _boy_nome;

  set boy_nome(String value) {
    _boy_nome = value;
  }

  String get long_ponto => _long_ponto;

  set long_ponto(String value) {
    _long_ponto = value;
  }

  get bairro_ponto => _bairro_ponto;

  set bairro_ponto(value) {
    _bairro_ponto = value;
  }

  get situacao_id => _situacao_id;

  get num_ponto => _num_ponto;

  set num_ponto(value) {
    _num_ponto = value;
  }
}
