import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:graphql_learning_flutter/log/app_logger_helper.dart';

class InternetCheckerProvider extends ChangeNotifier {
  bool isNetworkConnected = true;
  bool checkInternet = true;

  InternetCheckerProvider() {
    checkConnection();
  }

  void checkConnection() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      var connectivityResult = await Connectivity().checkConnectivity();

      bool isConnected =
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile);

      if (isConnected != isNetworkConnected) {
        isNetworkConnected = isConnected;
        checkInternet = isConnected;

        // ✅ Log connectivity state change
        AppLoggerHelper.logInfo(
          isConnected
              ? "✅ Network connected: $connectivityResult"
              : "❌ Network disconnected",
        );

        notifyListeners();
      }
    });
  }
}
