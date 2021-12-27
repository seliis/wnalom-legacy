// Dependencies
import "package:hive_flutter/hive_flutter.dart";
import "package:http/http.dart" as http;
import "package:get/get.dart";

// Controller
class SignatureControl extends GetxController {
    static SignatureControl get to => Get.find();

    String member = "?";
    String apikey = "?";
    String secret = "?";

    @override
    void onInit() {
        getStoredData();
        super.onInit();
    }

    Future getStoredData() async {
        Box box; try {
            box = Hive.box("db");
        } catch (err) {
            box = await Hive.openBox("db");
        }
        var stored = box.get("signature", defaultValue: {
            "member": "empty",
            "apikey": "empty",
            "secret": "empty",
        });
        member = stored["member"];
        apikey = stored["apikey"];
        secret = stored["secret"];
        update();
    }

    Future saveSignature(String mainServer, Map dataMap) async {
        final resp = await http.post(
            Uri.parse(mainServer + "/signature/save"),
            body: dataMap
        );

        if (resp.statusCode == 200) {
            var box = await Hive.openBox("db");
            box.put("signature", dataMap);
            getStoredData();
        }

        return resp.body;
    }
}