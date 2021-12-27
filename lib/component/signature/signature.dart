// Dependencies
import "package:flutter/material.dart";
import "package:get/get.dart";

// Controllers
import "package:wnalom/controller/signature_controller.dart";

// Component
class Signature extends StatelessWidget {
    Signature({
        Key? key,
        required this.mainServer
    }) : super(key: key);

    final SignatureControl signatureControl = Get.find();
    final String mainServer;

    final Map controls = {
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

    TextFormField getTextFormField(String controlsKey, String labelText) {
        return TextFormField(
            controller: controls[controlsKey],
            decoration: InputDecoration(
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
                    "member": controls["member"].text,
                    "apikey": controls["apikey"].text,
                    "secret": controls["secret"].text,
                };
                final String respResult = await signatureControl.saveSignature(mainServer, dataMap);
                FocusScope.of(context).unfocus();
                getDialog(respResult);
            },
        );
    }

    @override
    Widget build(BuildContext context) {
        return SafeArea(child: Scaffold(
            appBar: getAppBar(),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        getTextFormField("member", "Membership ID"),
                        getTextFormField("apikey", "API Key"),
                        getTextFormField("secret", "Secret Key"),
                        const SizedBox(height: 8),
                        getSaveButton(context)
                    ],
                ),
            ),
        ));
    }
}
