// Dependencies
import "package:http/http.dart" as http;
import "package:flutter/material.dart";
import "package:get/get.dart";

// Controllers
import "package:wnalom/controller/signature_controller.dart";

// Component
class Signature extends StatelessWidget {
    Signature({Key? key}) : super(key: key);

    // Find Controller
    final SignatureControl signatureControl = Get.find();

    final Map textEditingControllers = {
        "member": TextEditingController(),
        "apikey": TextEditingController(),
        "secret": TextEditingController()
    };

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
                "Signature",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14
                ),
            ),
            centerTitle: true,
            elevation: 0,
        );
    }

    TextFormField getTextFormField(String hintText, String controlsKey, String labelText) {
        
        // [2021-12-27]: using "hintText" instead "initialValue" due to occur error.

        return TextFormField(
            controller: textEditingControllers[controlsKey],
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.teal.shade100
                ),
                labelText: labelText,
                labelStyle: const TextStyle(
                    fontSize: 12
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always
            ),
        );
    }

    ElevatedButton getSaveButton(BuildContext context) {
        return ElevatedButton(
            child: const Text(
                "Save",
                style: TextStyle(
                    fontWeight: FontWeight.w300
                )
            ),
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 36)
                )
            ),
            onPressed: () async {
                final Map dataMap = {
                    // these keys corresponding with hive
                    "member": textEditingControllers["member"].text,
                    "apikey": textEditingControllers["apikey"].text,
                    "secret": textEditingControllers["secret"].text,
                };
                FocusScope.of(context).unfocus();
                final http.Response response = await signatureControl.saveSignature(dataMap);
                if (response.statusCode == 200) {
                    textEditingControllers.forEach((key, value) {
                        value.text = "";
                    });
                    Get.offAllNamed("/dashboard");
                }
                getDialog(response.body);
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return SafeArea(child: Scaffold(
            appBar: getAppBar(),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: GetBuilder<SignatureControl>(
                    init: SignatureControl(),
                    builder: (_) => Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                            getTextFormField(signatureControl.memberSaved!, "member", "Membership ID"),
                            getTextFormField(signatureControl.apikeySaved!, "apikey", "Your API Key"),
                            getTextFormField(signatureControl.secretSaved!, "secret", "Secret Key"),
                            const SizedBox(height: 8),
                            getSaveButton(context)
                        ],
                    ),
                )
            ),
        ));
    }
}
