import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isupply_app/features/invoice/data/repositories/invoice_repository.dart';

class ConnectionController extends GetxController {
  RxBool isConnected = false.obs;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  static ConnectionController get to => Get.find<ConnectionController>();
  ConnectivityResult _lastResult = ConnectivityResult.none;
  bool _lastInternetStatus = false;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
    _checkInternetConnection();
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> result) async {
    if (result[0] != _lastResult) {
      _lastResult = result[0];
      await _checkInternetConnection();
    }
  }

  Future<void> _checkInternetConnection() async {
    bool hasInternet = false;

    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(Duration(seconds: 3));
      hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      hasInternet = false;
    }

    if (hasInternet != _lastInternetStatus) {
      isConnected.value = hasInternet;
      _lastInternetStatus = hasInternet;
      if (hasInternet) {
        await InvoiceRepository.storeUnsynced();
      }
    }
    update();
  }

  Future<void> forceCheckConnection() async {
    await _checkInternetConnection();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
