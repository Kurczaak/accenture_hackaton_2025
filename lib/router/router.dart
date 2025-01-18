import 'package:accenture_hackaton_2025/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: OnboardingRoute.page),
      ];

  @override
  late final List<AutoRouteGuard> guards = [];
}
