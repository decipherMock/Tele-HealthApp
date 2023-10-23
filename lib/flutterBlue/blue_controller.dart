import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  FlutterBluePlus flutterBlue =  FlutterBluePlus();
  List<String> resp = [];
  

  Future scanDevice() async {
 await   FlutterBluePlus.startScan(timeout: const Duration(seconds: 5)).then((value) => log("done "));
   // FlutterBluePlus.stopScan();
  }//

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

}
