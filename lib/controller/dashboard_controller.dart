import "package:get/get.dart";

class DashboardControl extends GetxController {
    static DashboardControl get to => Get.find();

    bool tradeActivationState = false;

    void setTradeActivation() {
        tradeActivationState = !tradeActivationState;
        update();
    }
}