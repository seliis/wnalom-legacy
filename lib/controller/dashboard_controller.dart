// Dependencies
import "package:hive_flutter/hive_flutter.dart";
import "package:http/http.dart" as http;
import "package:get/get.dart";

// Controller
class DashboardControl extends GetxController {
    static DashboardControl get to => Get.find();

    bool tradeActivationState = false;

    Future<String> toggleTradeActivation(String mainServer) async {
        Box hiveBox = Hive.box("db");
        final hiveData = hiveBox.get("signature");

        if (hiveData == null || hiveData["member"] != "" && hiveData["apikey"] != "" && hiveData["secret"] != "") {
            final resp = await http.post(
                Uri.parse(mainServer + "/dashboard/start"),
                body: hiveBox.get("signature")
            );
            if (resp.statusCode == 200) {
                tradeActivationState = !tradeActivationState;
                update();
                return tradeActivationState? "Started" : "Stopped";
            }
        }

        return "No Signature";
    }
}