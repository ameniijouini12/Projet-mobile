import 'package:get/get.dart';

double calculateSize(String sizes, double value) {
  double val;
  if (sizes == "w") {
    val = ((value * 100) / 375) / 100;
    return Get.width * val;
  } else {
    val = ((value * 100) / 812) / 100;

    return Get.height * val;
  }
}
