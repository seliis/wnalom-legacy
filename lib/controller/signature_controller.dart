// Dependencies
import "package:http/http.dart" as http;
import "package:get/get.dart";

// Controller
class SignatureControl extends GetxController {
    static SignatureControl get to => Get.find();

    Future saveSignature(String mainServer, Map dataMap) async {
        final resp = await http.post(
            Uri.parse(mainServer + "/signature/save"),
            body: dataMap
        );

        return resp.body;
    }
}