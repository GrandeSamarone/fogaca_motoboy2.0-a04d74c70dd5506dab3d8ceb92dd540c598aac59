import 'dart:io';

import 'package:app_tutorial/app_tutorial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Pages_user/Tela_Login.dart';
import 'package:fogaca_app/Pages_user/Tela_updatedados.dart';
import 'package:fogaca_app/Widget/WIBusy.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:fogaca_app/Widget/WiDialog.dart';
import 'package:fogaca_app/view/profile/profile_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optimization_battery/optimization_battery.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Assistencia/SharedPreference.dart';
import '../../Interfaces/InterfaceLocalStorage.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Size size;

  late ScrollController scrollController = ScrollController();

  var isTop = false;
  bool busy = false;
  bool busyImg = false;
  final keyFoto = GlobalKey();
  final keyEconomiaEnergia = GlobalKey();
  final keyConexao = GlobalKey();
  final keyalterarperfil = GlobalKey();
  final keySobre = GlobalKey();
  final keySair = GlobalKey();
  List<TutorialItems> itens = [];
  final ILocalStorage iLocalStorage = SharedPreference();
  @override
  void initState() {
    // TODO: implement initState
    VerificarsharedPreferences();
    scrollController.addListener(() {
      if (scrollController.offset >= size.height * 0.1 && !isTop) {
        setState(() {
          isTop = true;
        });
      } else if (scrollController.offset < size.height * 0.1 && isTop) {
        setState(() {
          isTop = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.of(context).padding;
    size = MediaQuery.of(context).size;
    var userController = Get.find<UserController>();
    return  Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            Column(children: [
              SizedBox(
                height: padding.top + size.height * 0.01,
              ),
              Container(
                alignment: Alignment.center,
                height: size.height * 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("imagens/logoicon.png",
                        width: size.width * 0.4, color: Colors.white54),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
            ]),
            SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    SizedBox(height: padding.top + size.height * 0.1),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      margin: EdgeInsets.only(),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  !isTop ? size.width * 0.5 : 0))
                        //color: Colors.indigo,
                      ),
                      child: Container(
                        width: size.width,
                        height: size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 32,
                            ),
                            GestureDetector(

                              child:WIBusy(
                                busy: busyImg,
                                child: CircleAvatar(
                                  key: keyFoto,
                                  radius: 50,

                                  backgroundColor: Colors.grey,
                                  onBackgroundImageError: (exception, stackTrace){},
                                  backgroundImage: userController.motoboy!.icon_foto != null
                                      ? NetworkImage(userController.motoboy!.icon_foto)
                                      : NetworkImage("https://firebasestorage.googleapis.com/v0/b/fogaca-app.appspot.com/o/perfil%2Ficonusernfoto.jpg?alt=media&token=370e2f4a-a059-453e-a2f3-a4d8e5d7d7ef"),
                                  child: Container(
                                    alignment: Alignment.center,
                                    height:110,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.4),
                                        borderRadius: BorderRadius.all(Radius.circular(50))
                                    ),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[
                                          Text(
                                            "alterar"
                                            ,style:
                                          TextStyle(
                                              fontFamily:"Brand-Regular",
                                              color: Colors.white,
                                              fontSize: 16
                                          ),
                                          ),
                                          Icon(Icons.camera_alt
                                            ,color: Colors.white,)
                                        ]
                                    ),
                                  ),


                                ),
                              ),
                              onTap: () {
                                pickerImage();
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  userController.motoboy!.nome,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.1,
                            ),
                            Card(
                              margin:
                              EdgeInsets.only(left: 32, right: 32),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                        EdgeInsets.only(right: 16),
                                        leading: Container(
                                          width: 8,
                                          color: Colors.white,
                                        ),
                                        title: Text(

                                          "Teste de conexão",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        trailing: Icon(

                                          Icons.wifi_outlined,
                                          color: Colors.white,
                                          key: keyConexao,
                                        ),
                                        onTap: () { userController.checkConnection();},
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            Card(
                              margin:
                              EdgeInsets.only(left: 32, top: 8, right: 32),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                        EdgeInsets.only(right: 16),
                                        leading: Container(
                                          width: 8,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          "Economia de energia",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        trailing: Icon(
                                          Icons.battery_alert_outlined,
                                          color: Colors.white,
                                          key: keyEconomiaEnergia,
                                        ),
                                        onTap: () { checkLignoreBatteryOptimizations();},
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.0,
                            ),
                            Card(
                              margin: EdgeInsets.only(left: 32, top: 8, right: 32),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                        EdgeInsets.only(right: 16),
                                        leading: Container(
                                          width: 8,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          "Alterar Perfil",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        trailing: Icon(
                                          Icons.person_pin_outlined,
                                          color: Colors.white,
                                          key: keyalterarperfil,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Tela_updatedados()));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              margin:
                              EdgeInsets.only(left: 32, top: 8, right: 32),
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        contentPadding:
                                        EdgeInsets.only(right: 16),
                                        leading: Container(
                                          width: 8,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          "Sobre",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        trailing: Icon(
                                          Icons.info,
                                          color: Colors.white,
                                          key: keySobre,
                                        ),
                                        onTap: () {
                                          _launchInBrowser("https://www.iubenda.com/privacy-policy/71153807");
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            WIBusy(
                              busy: busy,
                              child: Card(
                                margin:
                                EdgeInsets.only(left: 32, top: 8, right: 32),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          contentPadding:
                                          EdgeInsets.only(right: 16),
                                          leading: Container(
                                            width: 8,
                                            color: Colors.red,
                                          ),
                                          title: Text(
                                            "Sair",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          trailing: Icon(
                                            Icons.exit_to_app,
                                            color: Colors.red,
                                            key: keySair,
                                          ),
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => WIDialog(
                                                    titulo: "Deseja realmente sair?",
                                                    msg:
                                                    "Você será redirecionado para a tela de login.",
                                                    textoButton1: "NÃO",
                                                    textoButton2: "SIM",
                                                    img: "imagens/alerta.png",
                                                    button1: () {
                                                      Navigator.pop(context);
                                                    },
                                                    button2: () {
                                                      if (!userController.motoboy!.online) {
                                                        Navigator.pop(context);
                                                        Logout();
                                                      } else {
                                                        ToastMensagem(
                                                            "Fique Offline antes de sair",
                                                            context);
                                                        Navigator.pop(context);
                                                      }
                                                    })
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text("versão: 1.0.0+36",style: TextStyle(color: Colors.white70),),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      );
  }
  void Tutorialinit(){
    itens.addAll({
      TutorialItems(
          globalKey: keyFoto,
          touchScreen: true,
          color: Color.fromRGBO(0, 0, 0, 0.8),
          bottom: 80,
          left: 30,

          children: [
            Text(
              "Coloque uma foto sua de rosto visível,é importante para o cliente.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              height: 50,
            )
          ],
          widgetNext: Text(
            "Toque para continuar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          shapeFocus: ShapeFocus.oval),
      TutorialItems(
        globalKey: keyConexao,
        touchScreen: true,
        top: 80,
        color: Color.fromRGBO(0, 0, 0, 0.8),
        left: 30,
        children: [
          Text(
            "Teste de Conexão:Você receberá uma chamada teste para confirmar que esta tudo OK.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(
            height: 100,
          )
        ],
        widgetNext: Text(
          "Toque para continuar",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shapeFocus: ShapeFocus.oval,
      ),
      TutorialItems(
          globalKey:keyEconomiaEnergia ,
          touchScreen: true,
          color: Color.fromRGBO(0, 0, 0, 0.8),
          top: 50,
          left: 30,

          children: [
            Text(
              "Por padrão todo APP vem configurado com economia de energia, você pode desativar, isso ajuda"
                  " a melhorar o desempenho do Fogaça Motoboys.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              height: 50,
            )
          ],
          widgetNext: Text(
            "Toque para continuar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          shapeFocus: ShapeFocus.oval),
      TutorialItems(
        globalKey: keyalterarperfil,
        touchScreen: true,
        color: Color.fromRGBO(0, 0, 0, 0.8),
        top: 70,
        left: 30,
        children: [
          Text(
            "Perfil:Aqui você altera seus dados.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(
            height: 10,
          )
        ],
        widgetNext: Text(
          "Toque para continuar",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shapeFocus: ShapeFocus.oval,
      ),
      TutorialItems(
        globalKey: keySobre,
        touchScreen: true,
        top: 70,
        color: Color.fromRGBO(0, 0, 0, 0.8),
        left: 30,
        children: [
          Text(
            "Nossa política de privacidade",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(
            height: 10,
          )
        ],
        widgetNext: Text(
          "Fechar",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shapeFocus: ShapeFocus.oval,
      )
    });
    Future.delayed(Duration(seconds: 2)).then((value) {
      print("delayed");
      Tutorial.showTutorial(context, itens);
    });
  }
  pickerImage() async {
    setState(() {
      busyImg=true;
    });
    var userController = Get.find<UserController>();
    ImagePicker _picker = ImagePicker();
    try {
      var picked = (await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 100, maxWidth: 400));

      if (picked != null) {
        var _imagem = File(picked.path);

        FirebaseStorage storage = FirebaseStorage.instance;
        Reference pastaRaiz = storage.ref();
        Reference arquivo =
        pastaRaiz.child("perfil").child(userController.user!.uid + ".jpg");

        //Upload da imagem
        UploadTask task = arquivo.putFile(_imagem);

        task.snapshotEvents.listen((TaskSnapshot storageEvent) {
          if (storageEvent.state == TaskState.running) {
            print("resultado:: Carregando...");
            // return "resultado:: Carregando...";
          } else if (storageEvent.state == TaskState.success) {
            print("resultado:: Sucesso...");
            setState(() {
              busyImg=false;
            });
            // return "resultado:: Sucesso";
          }
        });

        //Recuperar URL da imagem
        task.then((TaskSnapshot taskSnapshot) async {
          String url = await taskSnapshot.ref.getDownloadURL();
          Map<String, dynamic> dadosAtualizar = {"icon_foto": url};

          FirebaseFirestore.instance
              .collection("user_motoboy")
              .doc(userController.user!.uid)
              .update(dadosAtualizar);

          setState(() {
            busyImg=false;
          });
        });
      } else {
        setState(() {
          busyImg=false;
        });
      }
    } catch (erro) {
      setState(() {
        busyImg=false;
      });

    }
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
          context, Tela_Login.idScreen, (route) => false);
    }).catchError((error) {
      setState(() {
        busy = false;
      });
    });
  }
  void VerificarsharedPreferences()async{
    var perfil =
    await iLocalStorage.readData("perfil");
    print("perfil");
    print(perfil);
    if (perfil != null && perfil==0) {

        Tutorialinit();
        iLocalStorage.saveData('perfil', 1);
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  checkLignoreBatteryOptimizations()  {
    print("checkLignoreBatteryOptimizations");
    OptimizationBattery.isIgnoringBatteryOptimizations().then((onValue) {
      print("checkLignoreBatteryOptimizations1");
      print(onValue);
      setState(() {
        if (onValue) {
          ToastMensagem("Configuração OK!", context);
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => WIDialog(
                titulo: "Economia de energia",
                msg:
                "Alguns aparelhos podem fazer o app parar de funcionar em segundo plano para otimizar o uso de energia!" +
                    "\n\nPara garantir que o sistema de otimização de energia não faça o app parar de funcionar, é preciso adicionar o app a lista de não otimizados\n\nNa próxima tela, selecione a opção \"Nenhuma Restrição\"\n\n",
                textoButton1: "depois",
                textoButton2: "Adicionar",
                button1: () {
                  Navigator.pop(context);
                },
                button2: () {
                  OptimizationBattery.openBatteryOptimizationSettings();
                  Navigator.pop(context);
                },
                img: "imagens/alerta.png",
              )
          );

        }
      });
    });
  }
}
