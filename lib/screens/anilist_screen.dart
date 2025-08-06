import 'package:flutter/material.dart';
import 'package:graphql_learning_flutter/constants/app_api_constants.dart';
import 'package:graphql_learning_flutter/extensions/provider_extensions.dart';
import 'package:graphql_learning_flutter/log/app_logger_helper.dart';
import 'package:graphql_learning_flutter/service/graphql_client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AnilistScreen extends StatelessWidget {
  const AnilistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String query = """
      query {
        Page(page: 1, perPage: 50) {
          media(type: ANIME, sort: POPULARITY_DESC) {
            id
            title {
              romaji
              english
              native
            }
            description(asHtml: false)
            coverImage {
              large
              medium
            }
            siteUrl
          }
        }
      }
    """;

    final isConnected = context.isNetworkConnected;

    return Scaffold(
      appBar: AppBar(title: const Text("Anime List")),
      body: FutureBuilder(
        future: getClient(baseUrl: AppApiConstants.anilistUrl),
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
                    : FetchPolicy.cacheFirst,
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
                return const Center(child: Text("Error loading anime list"));
              }

              final mediaList = snapshot.data?.data?['Page']?['media'] ?? [];

              if (mediaList.isEmpty) {
                return const Center(child: Text("No data available"));
              }

              return ListView.builder(
                itemCount: mediaList.length,
                itemBuilder: (context, index) {
                  final anime = mediaList[index];
                  final title =
                      anime['title']['english'] ??
                      anime['title']['romaji'] ??
                      anime['title']['native'];
                  final imageUrl = anime['coverImage']['medium'];
                  final description = anime['description'] ?? '';

                  return ListTile(
                    leading: Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      final siteUrl = anime['siteUrl'];
                      // Open detail view or launch URL
                    },
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
