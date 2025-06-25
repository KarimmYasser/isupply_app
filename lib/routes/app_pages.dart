import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:isupply_app/features/invoice/presentation/view/invoice_view.dart';

import '../features/home/presentation/view/home_view.dart';

final String initial = Routes.home;

final List<GetPage<Widget>> routes = <GetPage<Widget>>[
  // GetPage<SplashView>(
  //   name: Routes.splash,
  //   page: () => SplashView(),
  // ),
  // GetPage<LoginView>(
  //   name: Routes.login,
  //   page: () => LoginView(),
  // ),
  GetPage<HomeView>(name: Routes.home, page: () => HomeView()),
  GetPage<InvoiceView>(name: Routes.invoice, page: () => InvoiceView()),
];

abstract class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String invoice = '/invoice';
}
