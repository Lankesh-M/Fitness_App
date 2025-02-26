import 'package:fitgame_app/Features/Home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:fitgame_app/Features/Auth/AuthScreen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
      case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    default:
      return MaterialPageRoute(
        builder:
            (_) => const Scaffold(body: Center(child: Text("Page not Found"))),
      );
  }
}
