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

    void setInitiate(data) {
        getStoredData();
    }

    void getStoredData() async {
        Box hiveBox; try {
            hiveBox = Hive.box("db");
        } catch (err) {
            // initial recognize database from here.
            hiveBox = await Hive.openBox("db");
        }
        final hiveData = hiveBox.get("signature", defaultValue: {
            // these keys related with signature datamap.
            // please refer signature.dart
            "member": "Insert Your Membership ID",
            "apikey": "Insert Your Binance API Key",
            "secret": "Insert Your Binance Secret Key",
        });
        memberSaved = hiveData["member"];
        apikeySaved = hiveData["apikey"];
        secretSaved = hiveData["secret"];
        update();
    }

    Future<http.Response> saveSignature(String mainServer, Map dataMap) async {
        final resp = await http.post(
            Uri.parse("http://$mainServer/signature/save"),
            body: dataMap["member"]
        );
        if (resp.statusCode == 200) {
            final Box hiveBox = Hive.box("db");
            hiveBox.put("signature", dataMap);
            getStoredData();
        }
        return resp;
    }
}