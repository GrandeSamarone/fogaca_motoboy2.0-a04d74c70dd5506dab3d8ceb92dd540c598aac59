import 'package:url_launcher/url_launcher.dart';

const String CARREGANDO = "0";
const String CANCELADO = "-1";
const String ACEITO = "1";
const String SAIU_PARA_ENTREGA = "2";
const String FINALIZADO = "3";
const String CONCLUIDO = "4";

const _status = [
  "Buscando...",
  "Corrida Aceita",
  "Saiu Para Entrega",
  "Finalizado",
  "Concluido"
];

String getStatusName(String status) {
  return status == "-1" ? "Cancelado" : _status[int.parse(status)];
}

Future<void> launchGoogleMaps(double lat, double lng) async {
  var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';
  var fallbackUrl =
      'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
  try {
    bool launched =
        await launch(url, forceSafariVC: false, forceWebView: false);
    if (!launched) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  } catch (e) {
    await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
  }
}
