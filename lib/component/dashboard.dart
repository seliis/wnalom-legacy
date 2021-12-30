// Dependencies
import "package:http/http.dart" as http;
import "package:flutter/material.dart";
import "package:get/get.dart";

// Controllers
import "package:wnalom/controller/dashboard_controller.dart";

// Component
class Dashboard extends StatelessWidget {
    Dashboard({Key? key}) : super(key: key);

    // Find Controller
    final DashboardControl dashboardControl = Get.find();

    void getDialog(String middleText) {
        Get.defaultDialog(
            title: "WNALOM",
            middleText: middleText,
            titleStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.75,
                color: Colors.teal,
                fontSize: 10,
            ),
            middleTextStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12
            )
        );
    }

    AppBar getAppBar() {
        return AppBar(
            title: const Text(
                "WNALOM",
                style: TextStyle(
                    letterSpacing: 1.25,
                    fontWeight: FontWeight.w300,
                    fontSize: 14
                ),
            ),
            actions: <Widget>[
                IconButton(
                    icon: const Icon(
                        Icons.vpn_key
                    ),
                    onPressed: () {
                        Get.toNamed("/signature");
                    },
                ),
            ],
            elevation: 0,
        );
    }

    Column getDataBox(String title, String? textData) {
        Color getTextColor() {
            if (dashboardControl.tradeState && textData != "Disconnected") {
                return Colors.black;
            } else {
                return Colors.pink;
            }
        }

        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 8
                    )
                ),
                const SizedBox(height: 16),
                SizedBox(
                    height: 50,
                    child: Text(
                        textData!,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: getTextColor()
                        ),
                    ),
                ),
                const Divider(thickness: 2)
            ],
        );
    }

    ElevatedButton getStartAndStopButton() {
        return ElevatedButton(
            child: Text(
                dashboardControl.tradeState? "DISCONNECT" : "CONNECT",
                style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.25,
                    fontSize: 12,
                ),
            ),
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                        vertical: 16
                    )
                )
            ),
            onPressed: () async {
                final http.Response response = await dashboardControl.toggleTrade();
                if (response.statusCode != 200) {
                    getDialog(response.body);
                }
            }
        );
    }

    @override
    Widget build(BuildContext context) {
        return SafeArea(child: Scaffold(
            appBar: getAppBar(),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: GetBuilder<DashboardControl>(
                    init: DashboardControl(),
                    builder: (_) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            getDataBox("STREAMED TICKER PRICE", dashboardControl.uiData["price"]),
                            getDataBox("YOUR ACCOUNT BALANCE", dashboardControl.uiData["balance"]),
                            getStartAndStopButton()
                        ],
                    ),
                )
            ),
        ));
    }
}