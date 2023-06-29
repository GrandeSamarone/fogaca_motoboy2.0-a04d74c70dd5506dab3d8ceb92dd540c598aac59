import 'package:flutter/foundation.dart';

import '../Assistencia/SharedPreference.dart';
import '../Interfaces/InterfaceLocalStorage.dart';

 const PEDIDOS = kReleaseMode ? "TestePedidos" : "TestePedidos";
 const MOTOBOYS = kReleaseMode ? "TesteMotoboysOnline" : "TesteMotoboysOnline";

class Api{
 static Future<String> Host()async{
  final ILocalStorage iLocalStorage = SharedPreference();
  var host = await iLocalStorage.readData("HOST");
  if(host==0){
   return "http://172.30.192.1:8089/dev";
  }else{
   return "http://172.30.192.1:8089/dev";
  }
 }
}