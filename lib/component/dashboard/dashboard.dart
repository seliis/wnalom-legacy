// Dependencies
import "package:http/http.dart" as http;
import "package:flutter/material.dart";
import "package:get/get.dart";

// Controllers
import "package:wnalom/controller/dashboard_controller.dart";

// Component
class Dashboard extends StatelessWidget {
    const Dashboard({
        Key? key,
        required this.mainServer
    }) : super(key: key);
    
    final String mainServer;

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

    Column getDataBox(String title) {
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
                const Text(
                    "0",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16
                    ),
                ),
                const Divider(thickness: 2)
            ],
        );
    }

    ElevatedButton getStartAndStopButton() {
        return ElevatedButton(
            child: Text(
                DashboardControl.to.tradeActivationState? "STOP" : "START",
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
                final http.Response resp = await DashboardControl.to.toggleTradeActivation(mainServer);
                getDialog(resp.body);
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
                    builder: (control) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            getDataBox("STREAMED TICKER PRICE"),
                            getDataBox("YOUR ACCOUNT BALANCE"),
                            getStartAndStopButton()
                        ],
                    ),
                )
            ),
        ));
    }
}