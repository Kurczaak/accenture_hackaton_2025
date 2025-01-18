import 'package:accenture_hackaton_2025/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
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
      ),
    );
  }
}
