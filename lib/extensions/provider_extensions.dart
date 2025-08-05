import 'package:flutter/material.dart';
import 'package:graphql_learning_flutter/providers/internet_connectivity_provider.dart';
import 'package:provider/provider.dart';

extension ProviderExtensions on BuildContext {
  /// Watch changes to network state
  bool get isNetworkConnected =>
      watch<InternetCheckerProvider>().isNetworkConnected;

  /// Read network state once
  bool get isNetworkConnectedRead =>
      read<InternetCheckerProvider>().isNetworkConnected;

  /// Full access to the provider (if needed)
  InternetCheckerProvider get networkProvider =>
      read<InternetCheckerProvider>();
}
