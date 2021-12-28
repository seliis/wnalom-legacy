// Dependencies
import "package:web_socket_channel/status.dart" as status;
import "package:hive_flutter/hive_flutter.dart";
import "package:web_socket_channel/io.dart";
import "package:http/http.dart" as http;
import "package:get/get.dart";

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
    
    void coupleChannel() {
        channel = IOWebSocketChannel.connect(
            Uri.parse("ws://$endPoint/websocket"),
            headers: { // what's wrong?
                "connection": "upgrade",
                "Upgrade": "websocket"
            }
        );
        print("opened");
        channel?.stream.listen((event) {
            print(event);
        });
        print("listen");
    }

    void detachChannel() {
        channel?.sink.close(status.goingAway);
        print("closed");
    }

    Future<http.Response> toggleTrade(String mainServer) async {
        Box hiveBox = Hive.box("db");
        final hiveData = hiveBox.get("signature");

        if (hiveData != null && hiveData["member"] != "" && hiveData["apikey"] != "" && hiveData["secret"] != "") {
            final resp = await http.post(
                Uri.parse("http://$mainServer/dashboard/start"),
                body: hiveBox.get("signature")
            );
            if (resp.statusCode == 200) {
                tradeState? detachChannel() : coupleChannel();
                tradeState = !tradeState;
                update();
            }
            return resp;
        }

        return http.Response("Check Your Signature", 428);
    }
}