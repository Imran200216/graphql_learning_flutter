import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_learning_flutter/constants/app_local_db_constants.dart';
import 'package:graphql_learning_flutter/log/app_logger_helper.dart';

Future<GraphQLClient> getClient({required String baseUrl}) async {
  final store = await HiveStore.open(
    boxName: AppLocalDBConstants.countryCacheBox,
  );

  AppLoggerHelper.logInfo(
    "✅ HiveStore initialized with custom box: ${AppLocalDBConstants.countryCacheBox}",
  );

  final link = HttpLink(baseUrl);

  final client = GraphQLClient(
    link: link,
    cache: GraphQLCache(store: store),
  );

  AppLoggerHelper.logInfo("✅ GraphQLClient initialized with $baseUrl");

  return client;
}

