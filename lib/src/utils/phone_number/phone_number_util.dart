import 'package:dlibphonenumber/dlibphonenumber.dart' as p;
import 'package:intl_phone_number/src/utils/phone_number.dart';

class PhoneNumberUtil {
  static p.PhoneNumberUtil phoneUtil = p.PhoneNumberUtil.instance;

  static Future<bool?> isValidNumber(
      {required String phoneNumber, required String isoCode}) async {
    if (phoneNumber.length < 2) {
      return false;
    }
    final number = phoneUtil.parse(phoneNumber, isoCode.toUpperCase());
    return phoneUtil.isValidNumber(number);
  }

  static Future<String?> normalizePhoneNumber(
      {required String phoneNumber, required String isoCode}) async {
    final number = phoneUtil.parse(phoneNumber, isoCode.toUpperCase());
    return phoneUtil.format(number, p.PhoneNumberFormat.e164);
  }

  static Future<RegionInfo> getRegionInfo(
      {required String phoneNumber, required String isoCode}) async {
    final number = phoneUtil.parse(phoneNumber, isoCode.toUpperCase());
    final regionCode = phoneUtil.getRegionCodeForNumber(number);
    final countryCode = number.countryCode.toString();
    final formattedNumber =
        phoneUtil.format(number, p.PhoneNumberFormat.national);
    return RegionInfo(
      regionPrefix: countryCode,
      isoCode: regionCode,
      formattedPhoneNumber: formattedNumber,
    );
  }

  static Future<PhoneNumberType> getNumberType(
      {required String phoneNumber, required String isoCode}) async {
    final p.PhoneNumberType type = phoneUtil
        .getNumberType(phoneUtil.parse(phoneNumber, isoCode.toUpperCase()));
    return PhoneNumberTypeUtil.getType(type.index);
  }

  static Future<String?> formatAsYouType(
      {required String phoneNumber, required String isoCode}) async {
    final asYouTypeFormatter = phoneUtil.getAsYouTypeFormatter(isoCode);
    String? result;
    for (int i = 0; i < phoneNumber.length; i++) {
      result = asYouTypeFormatter.inputDigit(phoneNumber[i]);
    }
    return result;
  }
}

class RegionInfo {
  String? regionPrefix;
  String? isoCode;
  String? formattedPhoneNumber;

  RegionInfo({this.regionPrefix, this.isoCode, this.formattedPhoneNumber});

  RegionInfo.fromJson(Map<String, dynamic> json) {
    regionPrefix = json['regionCode'];
    isoCode = json['isoCode'];
    formattedPhoneNumber = json['formattedPhoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['regionCode'] = this.regionPrefix;
    data['isoCode'] = this.isoCode;
    data['formattedPhoneNumber'] = this.formattedPhoneNumber;
    return data;
  }

  @override
  String toString() {
    return '[RegionInfo prefix=$regionPrefix, iso=$isoCode, formatted=$formattedPhoneNumber]';
  }
}

class PhoneNumberTypeUtil {
  static PhoneNumberType getType(int? value) {
    switch (value) {
      case 0:
        return PhoneNumberType.FIXED_LINE;
      case 1:
        return PhoneNumberType.MOBILE;
      case 2:
        return PhoneNumberType.FIXED_LINE_OR_MOBILE;
      case 3:
        return PhoneNumberType.TOLL_FREE;
      case 4:
        return PhoneNumberType.PREMIUM_RATE;
      case 5:
        return PhoneNumberType.SHARED_COST;
      case 6:
        return PhoneNumberType.VOIP;
      case 7:
        return PhoneNumberType.PERSONAL_NUMBER;
      case 8:
        return PhoneNumberType.PAGER;
      case 9:
        return PhoneNumberType.UAN;
      case 10:
        return PhoneNumberType.VOICEMAIL;
      default:
        return PhoneNumberType.UNKNOWN;
    }
  }
}

extension PhoneNumberTypeProperties on PhoneNumberType {
  int get value {
    switch (this) {
      case PhoneNumberType.FIXED_LINE:
        return 0;
      case PhoneNumberType.MOBILE:
        return 1;
      case PhoneNumberType.FIXED_LINE_OR_MOBILE:
        return 2;
      case PhoneNumberType.TOLL_FREE:
        return 3;
      case PhoneNumberType.PREMIUM_RATE:
        return 4;
      case PhoneNumberType.SHARED_COST:
        return 5;
      case PhoneNumberType.VOIP:
        return 6;
      case PhoneNumberType.PERSONAL_NUMBER:
        return 7;
      case PhoneNumberType.PAGER:
        return 8;
      case PhoneNumberType.UAN:
        return 9;
      case PhoneNumberType.VOICEMAIL:
        return 10;
      default:
        return -1;
    }
  }
}
