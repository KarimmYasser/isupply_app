import 'dart:ui';
import 'package:get/get.dart';

import 'lang/ar_eg.dart';
import 'lang/en_us.dart';

class LocalizationService extends Translations {
  static final locale = Locale('ar', 'EG');
  // Locale('en', 'US');
  static final langs = ['English', 'العربية'];
  static final locales = [Locale('en', 'US'), Locale('ar', 'EG')];
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'ar_EG': arEG};
  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale!);
  }

  Locale? _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale;
  }
}
