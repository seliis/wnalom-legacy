// Dependencies
import 'dart:async';

import "package:hive_flutter/hive_flutter.dart";
import "package:http/http.dart" as http;
import "package:get/get.dart";

// Controller
class SignatureControl extends GetxController {
    static SignatureControl get to => Get.find();

    String? memberSaved;
    String? apikeySaved;
    String? secretSaved;
    String? endPoint;

    void setInitiate(data) {
        endPoint = data["endPoint"];
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

    Future<http.Response> saveSignature(Map dataMap) async {
        // filters
        if (dataMap["member"] == null || dataMap["member"] == "") {
            return http.Response("No Membership ID", 428);
        }

        if (dataMap["apikey"] == null || dataMap["apikey"] == "") {
            return http.Response("No API Key", 428);
        }

        if (dataMap["secret"] == null || dataMap["secret"] == "") {
            return http.Response("No Secret Key", 428);
        }

        // attempt connect to server
        try {
            final response = await http.post(
                Uri.parse("http://$endPoint/signature/save"),
                body: dataMap["member"]
            ).timeout(
                const Duration(seconds: 5)
            );

            if (response.statusCode == 200) {
                final Box hiveBox = Hive.box("db");
                hiveBox.put("signature", dataMap);
                getStoredData();
            }

            return response;
        } on TimeoutException catch(_) {
            return http.Response("Server No Response", 444);
        }
    }
}