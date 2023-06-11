import 'dart:async';
import 'dart:convert';
import 'package:fogaca_app/Model/DirecaoDetalhes.dart';
import 'package:fogaca_app/Model/Endereco.dart';
import 'package:fogaca_app/Model/Pedido.dart';
import 'package:fogaca_app/Providers/Prov_AppData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'RequestAssist.dart';

class AssistenciaMetodo{
  static Future<String> seachCoordinateAddress(Position position,context)async
  {
       String placeAdress="";
       String st1,st2,st3,st4;
       String url ="https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyAi0cpmzH5zmsDYyO2FD8wEHzdpXEH0gN8";

  var response= await RequestAssistant.getRequest(url);

  if(response!="failed"){

   // placeAdress=response["results"][0]["formatted_address"];
    st1=placeAdress=response["results"][0]["address_components"][0]["long_name"];
    st2=placeAdress=response["results"][0]["address_components"][1]["long_name"];
    st3=placeAdress=response["results"][0]["address_components"][3]["long_name"];
    st4=placeAdress=response["results"][0]["address_components"][6]["long_name"];
    placeAdress=st1+", "+st2+", "+st3+", "+st4;

    Endereco userPickUpEndereco=new Endereco();
    userPickUpEndereco.longitude=position.longitude;
    userPickUpEndereco.latitude=position.latitude;
  //  userPickUpEndereco.placeName=placeAdress;

//Provider.of<AppData>(context,listen: false).atualizarlocalEndereco(userPickUpEndereco);

  }

  return placeAdress;
  }

  /*static Future<DirecaoDetalhes> obterDirectionDetalhes(LatLng inicialPosicao,LatLng finalPosicao)async{

    String direcaoUrl="https://maps.googleapis.com/maps/api/directions/json?origin=${inicialPosicao.latitude},${inicialPosicao.longitude}&destination=${finalPosicao.latitude},${finalPosicao.longitude}&key=AIzaSyAi0cpmzH5zmsDYyO2FD8wEHzdpXEH0gN8";
 print("DIRECAO::${direcaoUrl}");
    var res=await RequestAssistant.getRequest(direcaoUrl);

    if(res == "failed"){
      return null;
    }

    DirecaoDetalhes direcaoDetalhes= DirecaoDetalhes();
    direcaoDetalhes.encodedPoints=res["routes"][0]["overview_polyline"]["points"];

    direcaoDetalhes.distanciaText=res["routes"][0]["legs"][0]["distance"]["text"];
    direcaoDetalhes.distanciaValue=res["routes"][0]["legs"][0]["distance"]["value"];

    direcaoDetalhes.duracaoValue=res["routes"][0]["legs"][0]["duration"]["value"];
    direcaoDetalhes.duracaotxt=res["routes"][0]["legs"][0]["duration"]["text"];

    return direcaoDetalhes;

  }*/
 static sendNotificationToDriver(Pedido detalheCorrida,String msg) async
 {

   Map<String, String> headerMap =
   {
     'Content-Type': 'application/json',
     'Authorization':"key=AAAAXP58kWU:APA91bEL4vsQb0rJWrZfvYS1JNtPjnNwh-LUPsYHa97sDhU3w-"
         "l8QWx5-vBiPES7p7E-ACOJ0DOMqTfDgPHkDouZ8JVRJSWat54CdgU5gmwy0G1-_kreiAFZ9TBoV1GyEqyNv4fDN88B",

   };

   Map notificationMap =
   {
     'body': "O motoboy "+detalheCorrida.boy_nome+" ${msg}",
     'title':"Bee Bee"
   };

   Map dataMap =
   {
     'click_action': 'FLUTTER_NOTIFICATION_CLICK',
     'id': '1',
     'status': 'done',
     "distrito":"distrito",
     "quant_itens": "quant_itens",
     "total":"total",
     "telefone": "telefone",
     "nome_ponto": "nome_ponto",
     "end_ponto": "end_ponto",
     "lat_ponto":"lat_ponto",
     "long_ponto": "long_ponto",
     "id_doc":"id_doc",
   };

   Map sendNotificationMap =
   {
     "notification": notificationMap,
     "data": dataMap,
     "priority": "high",
     "timeToLive": 60 * 60 * 24,
     "to": detalheCorrida.token_ponto,
   };

   var res = await http.post(
     Uri.parse('https://fcm.googleapis.com/fcm/send'),
     headers: headerMap,
     body: jsonEncode(sendNotificationMap),
   );
 }

}