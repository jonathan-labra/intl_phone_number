import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:intl_phone_number/src/models/country_list.dart';
import 'package:intl_phone_number/src/utils/phone_number/phone_number_util.dart';

enum PhoneNumberType {
  FIXED_LINE,
  MOBILE,
  FIXED_LINE_OR_MOBILE,
  TOLL_FREE,
  PREMIUM_RATE,
  SHARED_COST,
  VOIP,
  PERSONAL_NUMBER,
  PAGER,
  UAN,
  VOICEMAIL,
  UNKNOWN,
}

class PhoneNumber extends Equatable {
  final String? phoneNumber;
  final String? dialCode;
  final String? isoCode;
  final int _hash;

  int get hash => _hash;

  @override
  List<Object?> get props => [phoneNumber, isoCode, dialCode];

  PhoneNumber({
    this.phoneNumber,
    this.dialCode,
    this.isoCode,
  }) : _hash = 1000 + Random().nextInt(99999 - 1000);

  @override
  String toString() {
    return 'PhoneNumber(phoneNumber: $phoneNumber, dialCode: $dialCode, isoCode: $isoCode)';
  }

  static Future<PhoneNumber> getRegionInfoFromPhoneNumber(
    String phoneNumber, [
    String isoCode = '',
  ]) async {
    RegionInfo regionInfo = await PhoneNumberUtil.getRegionInfo(
        phoneNumber: phoneNumber, isoCode: isoCode);

    String? internationalPhoneNumber =
        await PhoneNumberUtil.normalizePhoneNumber(
      phoneNumber: phoneNumber,
      isoCode: regionInfo.isoCode ?? isoCode,
    );

    return PhoneNumber(
      phoneNumber: internationalPhoneNumber,
      dialCode: regionInfo.regionPrefix,
      isoCode: regionInfo.isoCode,
    );
  }

  static Future<String> getParsableNumber(PhoneNumber phoneNumber) async {
    if (phoneNumber.isoCode != null) {
      PhoneNumber number = await getRegionInfoFromPhoneNumber(
        phoneNumber.phoneNumber!,
        phoneNumber.isoCode!,
      );
      String? formattedNumber = await PhoneNumberUtil.formatAsYouType(
        phoneNumber: number.phoneNumber!,
        isoCode: number.isoCode!,
      );

      return formattedNumber!.replaceAll(
        RegExp('^([\\+]?${number.dialCode}[\\s]?)'),
        '',
      );
    } else {
      throw Exception('ISO Code is "${phoneNumber.isoCode}"');
    }
  }

  String parseNumber() {
    return this.phoneNumber!.replaceAll('${this.dialCode}', '');
  }

  static String? getISO2CodeByPrefix(String prefix) {
    if (prefix.isNotEmpty) {
      prefix = prefix.startsWith('+') ? prefix : '+$prefix';
      var country = Countries.countryList
          .firstWhereOrNull((country) => country['dial_code'] == prefix);
      if (country != null && country['alpha_2_code'] != null) {
        return country['alpha_2_code'];
      }
    }
    return null;
  }

  static Future<PhoneNumberType> getPhoneNumberType(
      String phoneNumber, String isoCode) async {
    PhoneNumberType type = await PhoneNumberUtil.getNumberType(
        phoneNumber: phoneNumber, isoCode: isoCode);
    return type;
  }
}
