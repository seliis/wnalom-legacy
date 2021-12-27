// Dependencies
import "package:hive_flutter/hive_flutter.dart";
import "package:http/http.dart" as http;
import "package:get/get.dart";

// Controller
class SignatureControl extends GetxController {
    static SignatureControl get to => Get.find();

    String memberSaved = "";
    String apikeySaved = "";
    String secretSaved = "";

    @override
    void onInit() {
        getStoredData();
        super.onInit();
    }

    Future getStoredData() async {
        Box hiveBox; try {
            hiveBox = Hive.box("db");
        } catch (err) {
            hiveBox = await Hive.openBox("db");
        }
        var hiveData = hiveBox.get("signature", defaultValue: {
            "member": "not_saved_yet",
            "apikey": "not_saved_yet",
            "secret": "not_saved_yet",
        });
        memberSaved = hiveData["member"];
        apikeySaved = hiveData["apikey"];
        secretSaved = hiveData["secret"];
        update();
    }

    Future<http.Response> saveSignature(String mainServer, Map dataMap) async {
        final resp = await http.post(
            Uri.parse(mainServer + "/signature/save"),
            body: dataMap
        );
        if (resp.statusCode == 200) {
            var hiveBox = await Hive.openBox("db");
            hiveBox.put("signature", dataMap);
            getStoredData();
        }
        return resp;
    }
}