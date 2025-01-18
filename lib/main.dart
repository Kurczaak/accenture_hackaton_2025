import 'package:accenture_hackaton_2025/di/injection.dart';
import 'package:accenture_hackaton_2025/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
    fileName: 'dotenv',
  );

  OpenAI.apiKey = dotenv.get('OPEN_AI_KEY');
  await configureDependencies();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _appRouter = AppRouter();
  MainApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(
        deepLinkBuilder: (deepLink) {
          if (kIsWeb) {
            return deepLink;
          }
          if (deepLink.uri.fragment == '/' || deepLink.uri.fragment.isEmpty) {
            return DeepLink.defaultPath;
          }
          return DeepLink.path(deepLink.uri.fragment);
        },
    return MaterialApp.router(
      routerConfig: _appRouter.config(
        deepLinkBuilder: (deepLink) {
          if (kIsWeb) {
            return deepLink;
          }
          if (deepLink.uri.fragment == '/' || deepLink.uri.fragment.isEmpty) {
            return DeepLink.defaultPath;
          }
          return DeepLink.path(deepLink.uri.fragment);
        },
      ),
    );
  }
}
