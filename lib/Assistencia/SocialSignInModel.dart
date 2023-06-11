import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Model/Motoboy.dart';
import 'package:fogaca_app/Pages_user/Tela_Login.dart';
import 'package:get/get.dart';

abstract class SocialSignInModel {
  var CODE_EXISTS_ANOTHER_METHOD = 01;
  var CODE_INVALID_CREDENTIAL = 02;
  var erro;
  var codcity;
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference _db =
      FirebaseFirestore.instance.collection("user_motoboy");


  Future<String> LoginEmail(String email, String senha) async {
    final firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    UserCredential? userCredential;

    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      print("erro!!feiao::${e}");
      erro = e.toString();
      if (e.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        return 'e-mail já existe.';
      } else if (e.toString == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      // erro=e.toString();
    }

    if (userCredential != null) {
      print("PASSOU!$token}");
      print("PASSOU!}" + userCredential.user!.uid);

      final consult = await FirebaseFirestore.instance
          .collection("user_motoboy")
          .where("email", isEqualTo: email)
          .get()
          .then((value) => value.size);

      print("Size:: $consult");
      if (consult > 0) {
        Map<String, dynamic> dados = Map();
        dados["token"] = token;

        _db.doc(userCredential.user!.uid).update(dados);

        //Get.find<UserController>().init();
        return "sucesso";
      } else {
        await FirebaseFirestore.instance.terminate();
        await FirebaseAuth.instance.signOut();
        return "esta conta não existe.";
      }
    } else {
      return erro;
    }
  }

  Future Logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushNamedAndRemoveUntil(
          context, Tela_Login.idScreen, (route) => false);
    }).catchError((error) {});
    await FirebaseFirestore.instance.terminate();
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      return await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("ERRO RESETA::" + e.toString());
      return e.toString();
    }
  }

  Future<String> RegistrarNovoUsuario(Motoboy motoboy) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    User? firebaseUser;
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    try {
      firebaseUser = (await _firebaseAuth
              .createUserWithEmailAndPassword(
                  email: motoboy.email, password: motoboy.senha)
              .catchError((errMsg) {
        print("errocimaa:::${errMsg.toString()}");
        return errMsg.toString();
      }))
          .user!;
    } on FirebaseAuthException catch (e) {
      erro = e.toString();
      print("errocatch:::${e.toString()}");
    }

    print("UID:::!${firebaseUser!.uid}");
    if (firebaseUser.uid != null) {
      print("PASSOU!${firebaseUser.toString()}");

      final consult = await FirebaseFirestore.instance
          .collection("user_motoboy")
          .where("email", isEqualTo: firebaseUser.email)
          .get()
          .then((value) => value.size);

      print("Size:: $consult");
      if (consult <= 0) {
        print("ID DO ANIMAL::${firebaseUser.uid}");

        String cod = motoboy.cidade.replaceAll(
            RegExp(r'[-ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊË'
                r'èéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž]'),
            '');

        Map<String, dynamic> dados = Map();
        dados["id"] = firebaseUser.uid;
        dados["nome"] = motoboy.nome;
        dados["icon_foto"] =
            "https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Fcapacete.jpg?alt=media&token=55172947-3db3-4edd-9daa-93ceee0abd91";
        dados["tipo_dados"] = motoboy.tipo_dados;
        dados["cpf_cnpj"] = motoboy.cpf_cnpj;
        dados["tipo_user"] = "newUser";
        dados["telefone"] = motoboy.telefone;
        dados["email"] = motoboy.email;
        dados["token"] = token;
        dados["estrela"] = "5.0";
        dados["cidade"] = motoboy.cidade;
       // dados["cod"] = cod.toLowerCase();
        dados["cod"] = "jiparan";
        dados["estado"] = "Rondônia";
        dados["online"] = false;
        dados["permissao"] = false;
        dados["modelo"] = motoboy.modelo;
        dados["placa"] = motoboy.placa;
        dados["cor"] = motoboy.cor;

        _db.doc(firebaseUser.uid).set(dados);

        return "sucesso";
      } else {
        return "esta conta já existe.";
      }
    } else {
      return erro;
    }

    return "esta conta já existe.";
  }

  void onError(Exception? e, int code) {}
  void onSuccess(UserCredential? user) {}
}
