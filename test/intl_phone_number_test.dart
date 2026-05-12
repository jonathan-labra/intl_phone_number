import 'package:flutter_test/flutter_test.dart';
import 'package:intl_phone_number/intl_phone_number.dart';
import 'package:intl_phone_number/src/providers/country_provider.dart';
import 'package:intl_phone_number/src/utils/util.dart';

void main() {
  group('PhoneNumber', () {
    test('toString incluye los campos principales', () {
      final phone = PhoneNumber(
        phoneNumber: '+525512345678',
        isoCode: 'MX',
        dialCode: '+52',
      );
      expect(phone.toString(), contains('MX'));
      expect(phone.toString(), contains('+52'));
    });

    test('parseNumber elimina el dialCode del número', () {
      final phone = PhoneNumber(
        phoneNumber: '+525512345678',
        isoCode: 'MX',
        dialCode: '+52',
      );
      expect(phone.parseNumber(), '5512345678');
    });

    test('dos instancias con mismos datos son iguales (Equatable)', () {
      final a = PhoneNumber(phoneNumber: '+1234567890', isoCode: 'US', dialCode: '+1');
      final b = PhoneNumber(phoneNumber: '+1234567890', isoCode: 'US', dialCode: '+1');
      expect(a, equals(b));
    });

    test('instancias con distintos datos no son iguales', () {
      final a = PhoneNumber(phoneNumber: '+525512345678', isoCode: 'MX', dialCode: '+52');
      final b = PhoneNumber(phoneNumber: '+15512345678', isoCode: 'US', dialCode: '+1');
      expect(a, isNot(equals(b)));
    });

    test('getISO2CodeByPrefix retorna código ISO para +52', () {
      final iso = PhoneNumber.getISO2CodeByPrefix('+52');
      expect(iso, 'MX');
    });

    test('getISO2CodeByPrefix acepta prefijo sin + ', () {
      final iso = PhoneNumber.getISO2CodeByPrefix('1');
      expect(iso, isNotNull);
    });

    test('getISO2CodeByPrefix retorna null para prefijo inválido', () {
      final iso = PhoneNumber.getISO2CodeByPrefix('+000');
      expect(iso, isNull);
    });

    test('hash es único por instancia', () {
      final a = PhoneNumber(isoCode: 'MX');
      final b = PhoneNumber(isoCode: 'MX');
      // Distintas instancias tienen distintos hashes internos
      expect(a.hash, isNot(equals(b.hash)));
    });
  });

  group('PhoneNumberType', () {
    test('todos los tipos están definidos', () {
      expect(PhoneNumberType.values.length, 12);
    });

    test('contiene MOBILE y FIXED_LINE', () {
      expect(PhoneNumberType.values, contains(PhoneNumberType.MOBILE));
      expect(PhoneNumberType.values, contains(PhoneNumberType.FIXED_LINE));
    });
  });

  group('CountryProvider', () {
    test('retorna todos los países cuando no se filtra', () {
      final countries = CountryProvider.getCountriesData(countries: null);
      expect(countries, isNotEmpty);
      expect(countries.length, greaterThan(200));
    });

    test('filtra por lista de ISO codes', () {
      final countries =
          CountryProvider.getCountriesData(countries: ['MX', 'US', 'ES']);
      expect(countries.length, 3);
      final isoCodes = countries.map((c) => c.alpha2Code).toList();
      expect(isoCodes, containsAll(['MX', 'US', 'ES']));
    });

    test('lista vacía retorna todos los países', () {
      final countries = CountryProvider.getCountriesData(countries: []);
      expect(countries.length, greaterThan(200));
    });

    test('cada país tiene nombre, dialCode y alpha2Code', () {
      final countries = CountryProvider.getCountriesData(countries: null);
      for (final country in countries.take(10)) {
        expect(country.name, isNotNull);
        expect(country.dialCode, isNotNull);
        expect(country.alpha2Code, isNotNull);
      }
    });

    test('México tiene dial code +52', () {
      final countries =
          CountryProvider.getCountriesData(countries: ['MX']);
      expect(countries.length, 1);
      expect(countries.first.dialCode, '+52');
    });
  });

  group('Utils', () {
    late List countries;

    setUp(() {
      countries = CountryProvider.getCountriesData(countries: null);
    });

    test('getInitialSelectedCountry retorna el país por ISO', () {
      final country = Utils.getInitialSelectedCountry(
          List.from(countries), 'MX');
      expect(country.alpha2Code, 'MX');
    });

    test('getInitialSelectedCountry retorna el primero si no hay match', () {
      final all = CountryProvider.getCountriesData(countries: null);
      final country = Utils.getInitialSelectedCountry(all, 'XX');
      expect(country, equals(all.first));
    });

    test('generateFlagEmojiUnicode genera emoji para MX', () {
      final emoji = Utils.generateFlagEmojiUnicode('MX');
      expect(emoji, isNotEmpty);
      expect(emoji, '🇲🇽');
    });

    test('filterCountries filtra por nombre', () {
      final all = CountryProvider.getCountriesData(countries: null);
      final results = Utils.filterCountries(
        countries: all,
        locale: null,
        value: 'Mexico',
      );
      expect(results, isNotEmpty);
    });

    test('filterCountries filtra por dial code', () {
      final all = CountryProvider.getCountriesData(countries: null);
      final results = Utils.filterCountries(
        countries: all,
        locale: null,
        value: '+52',
      );
      expect(results, isNotEmpty);
      expect(results.any((c) => c.alpha2Code == 'MX'), isTrue);
    });

    test('filterCountries retorna todos si el valor está vacío', () {
      final all = CountryProvider.getCountriesData(countries: null);
      final results = Utils.filterCountries(
        countries: all,
        locale: null,
        value: '',
      );
      expect(results.length, all.length);
    });

    test('getCountryName retorna nombre en español con locale es', () {
      final all = CountryProvider.getCountriesData(countries: ['MX']);
      final name = Utils.getCountryName(all.first, 'es');
      expect(name, isNotNull);
      expect(name, isNotEmpty);
    });
  });

  group('SelectorConfig', () {
    test('valores por defecto son correctos', () {
      const config = SelectorConfig();
      expect(config.selectorType, PhoneInputSelectorType.DROPDOWN);
      expect(config.showFlags, isTrue);
      expect(config.useEmoji, isFalse);
      expect(config.setSelectorButtonAsPrefixIcon, isFalse);
      expect(config.trailingSpace, isTrue);
      expect(config.useBottomSheetSafeArea, isFalse);
    });

    test('se puede configurar selectorType a BOTTOM_SHEET', () {
      const config =
          SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET);
      expect(config.selectorType, PhoneInputSelectorType.BOTTOM_SHEET);
    });

    test('se puede configurar selectorType a DIALOG', () {
      const config =
          SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG);
      expect(config.selectorType, PhoneInputSelectorType.DIALOG);
    });
  });
}
