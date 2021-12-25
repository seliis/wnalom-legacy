import "package:flutter/material.dart";

class Signature extends StatelessWidget {
    Signature({Key? key}) : super(key: key);

    final Map controls = {
        "member": TextEditingController(),
        "apikey": TextEditingController(),
        "secret": TextEditingController()
    };

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

    ElevatedButton getSaveButton() {
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
            onPressed: () {},
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
                        getSaveButton()
                    ],
                ),
            ),
        ));
    }
}
