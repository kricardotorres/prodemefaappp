import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:prodemefa_app/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale){
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale .toString();
    final  String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    }
    );
  }

  static AppLocalizations of(BuildContext context ){
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title{
    return Intl.message(
      'Prodemefa Aplicacion',
      name: 'title',
      desc: 'the text on the bar'
    );
  }
}


class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) {
    return false;
  }
}