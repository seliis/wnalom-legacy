// Dependencies
import "package:flutter/material.dart";
import "package:get/get.dart";

// Controllers
import "package:wnalom/controller/dashboard_controller.dart";

// Component
class Dashboard extends StatelessWidget {
    const Dashboard({Key? key}) : super(key: key);
    
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
                        fontSize: 24
                    ),
                ),
                const Divider(thickness: 2)
            ],
        );
    }

    ElevatedButton getStartAndStopButton(bool tradeActivationState, Function setTradeActivation) {
        return ElevatedButton(
            child: Text(
                tradeActivationState? "STOP" : "START",
                style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1.25,
                    fontSize: 16,
                ),
            ),
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                        vertical: 16
                    )
                )
            ),
            onPressed: () => setTradeActivation()
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
                            getStartAndStopButton(
                                control.tradeActivationState,
                                control.setTradeActivation
                            )
                        ],
                    ),
                )
            ),
        ));
    }
}