import "package:flutter/material.dart";
import "package:get/get.dart";

import "component/dashboard/dashboard.dart";
import 'component/signature/signature.dart';

void main() {
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
                    page: () => Signature(),
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