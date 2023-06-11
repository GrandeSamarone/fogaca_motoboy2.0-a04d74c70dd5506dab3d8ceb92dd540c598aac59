import 'package:fogaca_app/Controllers/user_controller.dart';
import 'package:fogaca_app/Widget/WIToast.dart';
import 'package:fogaca_app/api/Api.dart';
import 'package:fogaca_app/utils/Utils.dart';
import 'package:get/get.dart' as getx;
import 'package:http/http.dart';

class ApiOrderController {
  var context;
  ApiOrderController(this.context);

  Future<String> getToken() {
    var userController = getx.Get.find<UserController>();
    return userController.user!.getIdToken(true);
  }

  Future<int> changeStatus(String id, String status) async {
    try {
      Response response = await post(Uri.parse(await Api.Host() + "/status"), body: {
        "status": status,
        "order_id": id
      }, headers: {
        "authorization": await getToken(),
        "type": "1",
      });
      print(response.body);
      if (response.statusCode == 200) {
        return 200;
      } else if (response.statusCode == 398) {
        return 398;
      } else if (response.statusCode == 400) {
        return 400;
      }else if (response.statusCode == 404) {
        return 404;
      }else if (response.statusCode == 399) {
        return 399;
      }else if (response.statusCode == 403) {
        return 403;
      }
      return 500;
    } catch (e) {
      print(e);
      return 500;
    }
  }

  Future<int> accepted(String id_pedido) async {
    try {
      Response response = await post(Uri.parse(await Api.Host() + "/accept"), body: {
        "pedido": id_pedido,
      }, headers: {
        "authorization": await getToken(),
        "type": "1",
      });
      print(response.body);
      if (response.statusCode == 200) {
        return 200;
      } else if (response.statusCode == 398) {
        return 398;
      } else if (response.statusCode == 400) {
        return 400;
      }else if (response.statusCode == 404) {
        return 404;
      }else if (response.statusCode == 399) {
        return 399;
      }else if (response.statusCode == 403) {
        return 403;
      }
      return 500;
    } catch (e) {
      print(e);
      return 500;
    }
  }
}
