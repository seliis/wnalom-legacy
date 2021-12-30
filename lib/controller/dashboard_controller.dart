// Dependencies
import "package:web_socket_channel/status.dart" as status;
import "package:hive_flutter/hive_flutter.dart";
import "package:web_socket_channel/io.dart";
import "package:http/http.dart" as http;
import "package:get/get.dart";
import "dart:convert";
import "dart:async";

// Controller
class DashboardControl extends GetxController {
    // Make Global Reference
    static DashboardControl get to => Get.find();

    // Controller Scoped Variables
    IOWebSocketChannel? channel;
    bool tradeState = false;
    String? endPoint;

    // Dashboard UI Present Data
    Map<String, String> uiData = {
        "price": "Disconnected",
        "balance": "Disconnected"
    };

    // Set Initial State
    void setInitiate(data) {
        endPoint = data["endPoint"];
    }
    
    void coupleChannel(dynamic hiveData) {
        channel = IOWebSocketChannel.connect(
            Uri.parse("ws://$endPoint/websocket/stream"),
            headers: {
                "memberId": hiveData["member"]
            }
        );
        channel?.stream.listen((data) {
            final streamData = jsonDecode(data);
            uiData["price"] = double.parse(streamData["p"]).toStringAsFixed(2);
            update();
        });
    }

    void detachChannel(dynamic hiveData) {
        channel?.sink.add("[WNALOM-APP] DETACHING REQUESTED | MEMBER ID: " + hiveData["member"]);
        channel?.sink.close(status.goingAway);
    }

    bool isHaveData(dynamic hiveData) {
        if (hiveData == null) {
            return false;
        } else if (hiveData["member"] == "") {
            return false;
        } else if (hiveData["apikey"] == "") {
            return false;
        } else if (hiveData["secret"] == "") {
            return false;
        }
        return true;
    }

    Future<http.Response> toggleTrade() async {
        Box hiveBox = Hive.box("db");
        final hiveData = hiveBox.get("signature");

        if (isHaveData(hiveData) == true) {
            try {
                // attempt connect to main server
                final response = await http.post(
                    Uri.parse("http://$endPoint/dashboard/start"),
                    body: hiveData
                ).timeout(
                    const Duration(seconds: 5)
                );
                
                // is normal connect?
                if (response.statusCode == 200) {
                    tradeState? detachChannel(hiveData) : coupleChannel(hiveData);
                    tradeState = !tradeState;
                    update();
                }

                // Reset Dashboard
                if (!tradeState) {
                    // delay for prevent conflict with last web socket response
                    Future.delayed(const Duration(seconds: 3), () {
                        uiData.forEach((key, value) {
                            if (value != "Disconnected") {
                                uiData[key] = "Disconnected";
                            }
                        });
                        update();
                    });
                }

                return response;
            } on TimeoutException catch(_) {
                return http.Response("Server No Response", 444);
            }
        }

        return http.Response("Check Your Signature", 428);
    }
}