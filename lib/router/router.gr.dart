// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:accenture_hackaton_2025/presentation/features/home/home_page.dart'
    as _i1;
import 'package:accenture_hackaton_2025/presentation/features/onboarding/onbarding_page.dart'
    as _i2;
import 'package:auto_route/auto_route.dart' as _i3;

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i3.PageRouteInfo<void> {
  const HomeRoute({List<_i3.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomePage();
    },
  );
}

/// generated route for
/// [_i2.OnboardingPage]
class OnboardingRoute extends _i3.PageRouteInfo<void> {
  const OnboardingRoute({List<_i3.PageRouteInfo>? children})
      : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.OnboardingPage();
    },
  );
}
