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
    // Global Variables
    const String mainServer = "http://61.110.177.153:8080";

    // Initialize Hive Database
    await Hive.initFlutter();

    // Initialize Controllers
    Get.put(DashboardControl());
    Get.put(SignatureControl());

    // Running Application
    runApp(
        GetMaterialApp(
            initialRoute: "/dashboard",
            getPages: [
                GetPage(
                    name: "/dashboard",
                    page: () => const Dashboard()
                ),
                GetPage(
                    name: "/signature",
                    page: () => Signature(
                        mainServer: mainServer
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