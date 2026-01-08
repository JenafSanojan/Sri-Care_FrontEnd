import 'dart:async';
// import 'package:SL_Explorer/common/snack_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:tastydog/views/error_pages/connection_erra_screen.dart';

import '../widget_common/snack_bar.dart';

class NetworkManager extends GetxController{

  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit(){
    super.onInit();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async{
    bool isConnected = false;
    for (var connectivityResult in result) { // if at least one connection is available, we consider it connected
      if (connectivityResult == ConnectivityResult.none) {
        continue;
      }
      isConnected = true;
      break;
    }
    if(!isConnected){
      CommonLoaders.warningSnackBar(
        title: 'No Internet',
        duration: 4,
        message: 'Please check your internet connection',
      );
    }
  }

  Future<bool> isConnected() async{
    try{
      final result = await _connectivity.checkConnectivity();
      if(result == ConnectivityResult.none){
        return false;
      }else{
        return true;
      }
    } on PlatformException catch (_){
      return false;
    }
  }

  @override
  void onClose(){
    super.onClose();
    _connectivitySubscription.cancel();
  }

}