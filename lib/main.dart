// Dependencies
import "package:hive_flutter/hive_flutter.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";

// Components
import "package:wnalom/component/dashboard/dashboard.dart";
import "package:wnalom/component/signature/signature.dart";

// Controllers
import "package:wnalom/controller/dashboard_controller.dart";
import "package:wnalom/controller/signature_controller.dart";

void main() async {
    // End Points
    const Map endPoints = {
        "phone": "192.168.193.137:8080",
        "home": "61.110.177.153:8080"
    };

    // Switcher
    String endPoint = endPoints["home"];

    // Initialize Hive Database
    await Hive.initFlutter();

    // Initialize Controllers
    final DashboardControl dashboardControl = Get.put(DashboardControl());
    final SignatureControl signatureControl = Get.put(SignatureControl());

    dashboardControl.setInitiate({
        "endPoint": endPoint
    });

    signatureControl.setInitiate({

    });

    // Running Application
    runApp(
        GetMaterialApp(
            initialRoute: "/dashboard",
            getPages: [
                GetPage(
                    name: "/dashboard",
                    page: () => Dashboard(
                        mainServer: endPoint
                    )
                ),
                GetPage(
                    name: "/signature",
                    page: () => Signature(
                        mainServer: endPoint
                    ),
                    transition: Transition.cupertino
                )
            ],
            theme: ThemeData(
                primarySwatch: Colors.teal,
            ),
            debugShowCheckedModeBanner: false,
        )
    );
}