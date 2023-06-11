import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Pages_user/Tela_updatedados.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:fogaca_app/view/login/login_view.dart';
import 'package:fogaca_app/view/profile/profile_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

abstract class ProfileModel extends State<Tela_updatedados> {
  String? idUsuarioLogado;
  var scaffold = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late Size size;
  var isReset;
  var busy = false;
  var nomeController = TextEditingController();
  var modeloController = TextEditingController();
  var placaController = TextEditingController();
  var corController = TextEditingController();
  var telefoneController = TextEditingController();
  var emailController = TextEditingController();

  String dropdownValue = 'Selecione uma cidade';
  List<String> spinnerItems = [
    'Selecione uma cidade',
    'Ji-Paraná',
    'Ouro Preto',
    'Jaru',
    'Ariquemes',
    'Cacoal',
    'Médici',
  ];
  final _picker = ImagePicker();
  var _imagemSelecionada;
  File? _imagem;
  var _db = FirebaseFirestore.instance.collection("user_motoboy");
  ReactionDisposer? reactionDisposer;

  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<String> pickerImage() async {
    var userController = Get.find<UserController>();
    setState(() {
      busy = true;
    });
    try {
      _imagemSelecionada = (await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 100, maxWidth: 400));

      if (_imagemSelecionada != null) {
        _imagem = File(_imagemSelecionada.path);

        FirebaseStorage storage = FirebaseStorage.instance;
        Reference pastaRaiz = storage.ref();
        Reference arquivo = pastaRaiz
            .child("perfil")
            .child(userController.motoboy!.id + ".jpg");

        //Upload da imagem
        UploadTask task = arquivo.putFile(_imagem!);

        task.snapshotEvents.listen((TaskSnapshot storageEvent) {
          if (storageEvent.state == TaskState.running) {
            print("resultado:: Carregando...");
            // return "resultado:: Carregando...";
          } else if (storageEvent.state == TaskState.success) {
            print("resultado:: Sucesso...");

            // return "resultado:: Sucesso";
          }
        });

        //Recuperar URL da imagem
        task.then((TaskSnapshot taskSnapshot) async {
          String url = await taskSnapshot.ref.getDownloadURL();
          Map<String, dynamic> dadosAtualizar = {"icon_foto": url};

          _db.doc(userController.motoboy!.id).update(dadosAtualizar);

          setState(() {
            busy = false;
          });
          return "Carregada com sucesso!";
        });
      } else {
        return "resultado::Imagem nao selecionada";
      }
    } catch (erro) {
      return erro.toString();
    }
    return "sss";
  }

  Future AlterarDados() async {
    var userController = Get.find<UserController>();
    setState(() {
      busy = true;
    });

    String cod = dropdownValue.replaceAll(
        RegExp(r'[-ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊË'
            r'èéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž ]'),
        '');

    Map<String, dynamic> Atualizando = {
      "cidade": dropdownValue,
      "cod": cod.toLowerCase(),
      "nome": nomeController.text.trim(),
      "telefone": telefoneController.text,
      "modelo": modeloController.text.trim(),
      "cor": corController.text.trim(),
      "placa": placaController.text.trim()
    };
    await _db
        .doc(userController.motoboy!.id)
        .update(Atualizando)
        .whenComplete(() {
      setState(() {
        busy = false;
      });

      ToastMensagem("Atualizado com sucesso!", context);
    });
  }

  Future Logout() async {
    setState(() {
      busy = true;
    });
    await FirebaseFirestore.instance.terminate();
    await FirebaseAuth.instance.signOut().then((value) {
      setState(() {
        busy = false;
      });

      Navigator.pushNamedAndRemoveUntil(
          context, LoginView.idScreen, (route) => false);
    }).catchError((error) {
      setState(() {
        busy = false;
      });
    });
  }
}
