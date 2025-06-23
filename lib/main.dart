import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/config.dart';
import 'localization/localization_service.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const ISupplyApp());
}

class ISupplyApp extends StatelessWidget {
  const ISupplyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      getPages: routes,
      initialRoute: initial,
      locale: LocalizationService.locale,
      // navigatorKey: navigatorKey,
      translations: LocalizationService(),
      builder:
          (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 800, name: MOBILE),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Color.fromRGBO(23, 143, 73, 1.0)),
        fontFamily: 'Cairo',
        dividerColor: const Color.fromRGBO(218, 218, 218, 1),
        primaryColor: const Color.fromRGBO(23, 143, 73, 1.0),
        scaffoldBackgroundColor: const Color.fromRGBO(244, 245, 250, 1),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color.fromRGBO(252, 189, 24, 1),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromRGBO(252, 189, 24, 1),
          sizeConstraints: BoxConstraints(minWidth: 80, minHeight: 80),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: Color.fromRGBO(23, 143, 73, 1),
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(23, 143, 73, 1)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(23, 143, 73, 1)),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

