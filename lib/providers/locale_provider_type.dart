import 'package:sqflite_worker/model/module.dart';

abstract class LocaleProviderType {
  void onLocaleChanges(LanguageType languageType);
}