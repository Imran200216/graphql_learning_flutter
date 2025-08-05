import 'package:flutter/material.dart';
import 'package:graphql_learning_flutter/providers/internet_connectivity_provider.dart';
import 'package:graphql_learning_flutter/screens/country_list_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Graphql Hive
  await initHiveForFlutter();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // INTERNET PROVIDER
        ChangeNotifierProvider(create: (context) => InternetCheckerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grapql Learning implementation in flutter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: CountryListScreen(),
      ),
    );
  }
}
