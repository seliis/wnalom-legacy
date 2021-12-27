// Dependencies
import "package:flutter/material.dart";
import "package:get/get.dart";

// Components
import "package:wnalom/component/dashboard/dashboard.dart";
import "package:wnalom/component/signature/signature.dart";

// Controllers
import "package:wnalom/controller/signature_controller.dart";

void main() {
    // Global Variables
    // const String mainServer = "http://61.110.177.153:8080";
    // const String mainServer = "http://192.168.0.6:8080";
    const String mainServer = "http://192.168.193.137:8080";

    // Initialize Controllers
    Get.put(SignatureControl());

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