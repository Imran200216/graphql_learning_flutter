import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_learning_flutter/extensions/provider_extensions.dart';
import 'package:graphql_learning_flutter/log/app_logger_helper.dart';
import 'package:graphql_learning_flutter/service/graphql_client.dart';

class CountryListScreen extends StatelessWidget {
  final String query = """
    {
      countries {
        code
        name
        emoji
      }
    }
  """;

  const CountryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isConnected = context.isNetworkConnected;

    return Scaffold(
      appBar: AppBar(title: Text("Countries")),
      body: FutureBuilder<GraphQLClient>(
        future: getClient(),
        builder: (context, clientSnapshot) {
          if (!clientSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final client = clientSnapshot.data!;

          return FutureBuilder<QueryResult>(
            future: client.query(
              QueryOptions(
                document: gql(query),
                fetchPolicy: isConnected
                    ? FetchPolicy.networkOnly
                    : FetchPolicy.cacheOnly,
              ),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || snapshot.data?.hasException == true) {
                AppLoggerHelper.logError(
                  'Error: ${snapshot.error ?? snapshot.data?.exception.toString()}',
                );
                return const Center(child: Text("Error loading countries"));
              }

              final countries = snapshot.data!.data?['countries'] ?? [];

              AppLoggerHelper.logInfo('Countries Data: ${snapshot.data!.data}');

              if (countries.isEmpty) {
                return const Center(child: Text("No cached data available"));
              }

              return ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  final country = countries[index];
                  return ListTile(
                    leading: Text(country['emoji']),
                    title: Text(country['name']),
                    subtitle: Text("Code: ${country['code']}"),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
