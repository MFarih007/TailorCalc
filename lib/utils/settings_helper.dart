import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:intl/intl.dart';

class SettingsHelper {
  // Settings keys
  static const String currencyKey = 'currency_key';
  static const String brandNameKey = 'brand_name_key';
  static const String defaultMarginKey = 'default_margin_key';
  static const String preparedByKey = 'prepared_by_key';

  // Default values
  static const String defaultCurrency = 'NGN';
  static const double defaultMargin = 20.0;
  static const String defaultBrandName = 'TailorCalc';
  static const String defaultPreparedBy = 'Tailor';

  // Currency symbols map
  static const Map<String, String> currencySymbols = {
    'NGN': '₦',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'GHS': '₵',
  };

  // Get currency
  static String getCurrency() {
    final currencyIndex = Settings.getValue<int>(currencyKey) ?? 1;
    final currencies = ['NGN', 'USD', 'EUR', 'GBP', 'GHS'];
    if (currencyIndex >= 1 && currencyIndex <= currencies.length) {
      return currencies[currencyIndex - 1];
    }
    return defaultCurrency;
  }

  // Get currency symbol
  static String getCurrencySymbol() {
    final currency = getCurrency();
    return currencySymbols[currency] ?? '₦';
  }

  // Get default profit margin percentage (handles String/num)
  static double getDefaultMargin() {
    final value = Settings.getValue<String>(defaultMarginKey);
    final parsed = double.tryParse(value!);
    return parsed ?? defaultMargin;
  }

  // Get brand name
  static String getBrandName() {
    return Settings.getValue<String>(brandNameKey) ?? defaultBrandName;
  }

  // Get prepared by name
  static String getPreparedBy() {
    return Settings.getValue<String>(preparedByKey) ?? defaultPreparedBy;
  }

  // Format currency amount
  static String formatCurrency(double amount) {
    final symbol = getCurrencySymbol();
    return NumberFormat.currency(symbol: symbol, decimalDigits: 2).format(amount);
  }

  // Set currency
  static Future<void> setCurrency(int index) async {
    await Settings.setValue(currencyKey, index);
  }

  // Set default margin
  static Future<void> setDefaultMargin(double margin) async {
    await Settings.setValue(defaultMarginKey, margin);
  }

  // Set brand name
  static Future<void> setBrandName(String name) async {
    await Settings.setValue(brandNameKey, name);
  }

  // Set prepared by
  static Future<void> setPreparedBy(String name) async {
    await Settings.setValue(preparedByKey, name);
  }
}

