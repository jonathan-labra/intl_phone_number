import 'package:intl_phone_number/src/models/country_model.dart';

class Utils {
  static Country getInitialSelectedCountry(
      List<Country> countries, String countryCode) {
    return countries.firstWhere((country) => country.alpha2Code == countryCode,
        orElse: () => countries[0]);
  }

  static String generateFlagEmojiUnicode(String countryCode) {
    final base = 127397;
    return countryCode.codeUnits
        .map((e) => String.fromCharCode(base + e))
        .toList()
        .reduce((value, element) => value + element)
        .toString();
  }

  static List<Country> filterCountries({
    required List<Country> countries,
    required String? locale,
    required String value,
  }) {
    if (value.isNotEmpty) {
      return countries
          .where(
            (Country country) =>
                country.alpha3Code!
                    .toLowerCase()
                    .startsWith(value.toLowerCase()) ||
                country.name!.toLowerCase().contains(value.toLowerCase()) ||
                Utils.getCountryName(country, locale)!
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                country.dialCode!.contains(value.toLowerCase()),
          )
          .toList();
    }
    return countries;
  }

  static String? getCountryName(Country country, String? locale) {
    if (locale != null && country.nameTranslations != null) {
      String? translated = country.nameTranslations![locale];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }
    return country.name;
  }
}
