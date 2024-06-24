// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:base_setup/data/models/news.model.dart' as _i7;
import 'package:base_setup/ui/auth/login_screen.dart' as _i2;
import 'package:base_setup/ui/auth/register_screen.dart' as _i4;
import 'package:base_setup/ui/home/home_screen.dart' as _i1;
import 'package:base_setup/ui/home/news_detail.dart' as _i3;
import 'package:flutter/foundation.dart' as _i6;

abstract class $AppRouter extends _i5.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    HomeScreen.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    LoginScreen.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
      );
    },
    NewsDetailViewScreen.name: (routeData) {
      final args = routeData.argsAs<NewsDetailViewScreenArgs>(
          orElse: () => const NewsDetailViewScreenArgs());
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.NewsDetailViewScreen(
          key: args.key,
          news: args.news,
        ),
      );
    },
    RegisterScreen.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.RegisterScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeScreen]
class HomeScreen extends _i5.PageRouteInfo<void> {
  const HomeScreen({List<_i5.PageRouteInfo>? children})
      : super(
          HomeScreen.name,
          initialChildren: children,
        );

  static const String name = 'HomeScreen';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i2.LoginScreen]
class LoginScreen extends _i5.PageRouteInfo<void> {
  const LoginScreen({List<_i5.PageRouteInfo>? children})
      : super(
          LoginScreen.name,
          initialChildren: children,
        );

  static const String name = 'LoginScreen';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i3.NewsDetailViewScreen]
class NewsDetailViewScreen extends _i5.PageRouteInfo<NewsDetailViewScreenArgs> {
  NewsDetailViewScreen({
    _i6.Key? key,
    _i7.News? news,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          NewsDetailViewScreen.name,
          args: NewsDetailViewScreenArgs(
            key: key,
            news: news,
          ),
          initialChildren: children,
        );

  static const String name = 'NewsDetailViewScreen';

  static const _i5.PageInfo<NewsDetailViewScreenArgs> page =
      _i5.PageInfo<NewsDetailViewScreenArgs>(name);
}

class NewsDetailViewScreenArgs {
  const NewsDetailViewScreenArgs({
    this.key,
    this.news,
  });

  final _i6.Key? key;

  final _i7.News? news;

  @override
  String toString() {
    return 'NewsDetailViewScreenArgs{key: $key, news: $news}';
  }
}

/// generated route for
/// [_i4.RegisterScreen]
class RegisterScreen extends _i5.PageRouteInfo<void> {
  const RegisterScreen({List<_i5.PageRouteInfo>? children})
      : super(
          RegisterScreen.name,
          initialChildren: children,
        );

  static const String name = 'RegisterScreen';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}
