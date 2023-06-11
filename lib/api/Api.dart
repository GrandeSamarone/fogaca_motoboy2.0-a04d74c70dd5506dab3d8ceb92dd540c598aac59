import 'package:flutter/foundation.dart';

import '../Assistencia/SharedPreference.dart';
import '../Interfaces/InterfaceLocalStorage.dart';

 const PEDIDOS = kReleaseMode ? "Chamadas" : "Chamadas";
 const MOTOBOYS = kReleaseMode ? "MotoboysOn" : "MotoboysOn";

class Api{
 static Future<String> Host()async{
  final ILocalStorage iLocalStorage = SharedPreference();
  var host = await iLocalStorage.readData("HOST");
  if(host==0){
   return 'https://fogacaexpress.com/dev';
  }else{
   return 'https://fogacaexpress.shop/dev';
  }
 }
}