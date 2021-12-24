import "package:flutter/material.dart";
import 'package:get/route_manager.dart';
import "package:http/http.dart" as http;

void main() {
    runApp(
        GetMaterialApp(
            home: const SafeArea(
                child: Home(),
            ),
            theme: ThemeData(
                primarySwatch: Colors.teal,
            ),
            debugShowCheckedModeBanner: false,
        )
    );
}

class Home extends StatelessWidget {
    const Home({Key? key}) : super(key: key);
    
    AppBar getAppBar() {
        return AppBar(
            title: const Text(
                "appName",
                style: TextStyle(
                    fontWeight: FontWeight.w300
                ),
            ),
            actions: [
                IconButton(
                    icon: Icon(
                        Icons.vpn_key,
                        color: Colors.amber.shade200,
                    ),
                    onPressed: () {},
                )
            ],
            elevation: 0,
        );
    }

    ElevatedButton getConnectButton() {
        return ElevatedButton(
            child: const Text(
                "Connect",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20
                ),
            ),
            onPressed: () async {
                var resp = await http.get(Uri.http("10.0.2.2:8000", "/connect"));
                if (resp.statusCode == 200) {
                    Get.defaultDialog(
                        title: "Message from Fiber",
                        titleStyle: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.w400,
                            fontSize: 16
                        ),
                        content: Text(
                            resp.body,
                            style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 20
                            ),
                        )
                    );
                }
            },
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                        horizontal: 72,
                        vertical: 16
                    )
                )
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: getAppBar(),
            body: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.teal.shade50,
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8
                    ),
                    child: Stack(
                        alignment: Alignment.center,
                        children: [
                            Positioned(
                                child: getConnectButton(),
                                bottom: 48,
                            )
                        ],
                    )
                )
            ),
        );
    }
}