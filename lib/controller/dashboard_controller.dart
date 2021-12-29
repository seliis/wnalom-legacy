// Dependencies
import "package:web_socket_channel/status.dart" as status;
import "package:hive_flutter/hive_flutter.dart";
import "package:web_socket_channel/io.dart";
import "package:http/http.dart" as http;
import "package:get/get.dart";
import "dart:async";

// Controller
class DashboardControl extends GetxController {
    // Make Global Reference
    static DashboardControl get to => Get.find();

    // Controller Scoped Variables
    IOWebSocketChannel? channel;
    bool tradeState = false;
    String? endPoint;

    // Set Initial State
    void setInitiate(data) {
        endPoint = data["endPoint"];
    }
    
    void coupleChannel() async {
        channel = IOWebSocketChannel.connect(
            Uri.parse("ws://$endPoint/websocket/stream"),
            pingInterval: const Duration(seconds: 10)
        );
        channel?.stream.listen((data) {
            print(data);
        });
    }

    void decoupleChannel() {
        channel?.sink.add("[wnalomApp]: decouple");
        channel?.sink.close(status.goingAway);
    }

    Future<http.Response> toggleTrade() async {
        Box hiveBox = Hive.box("db");
        final hiveData = hiveBox.get("signature");

        if (hiveData != null && hiveData["member"] != "" && hiveData["apikey"] != "" && hiveData["secret"] != "") {
            final resp = await http.post(
                Uri.parse("http://$endPoint/dashboard/start"),
                body: hiveBox.get("signature")
            );
            if (resp.statusCode == 200) {
                tradeState? decoupleChannel() : coupleChannel();
                tradeState = !tradeState;
                update();
            }
            return resp;
        }

        return http.Response("Check Your Signature", 428);
    }
}