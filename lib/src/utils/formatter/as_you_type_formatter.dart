import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl_phone_number/src/utils/phone_number/phone_number_util.dart';

typedef OnInputFormatted<T> = void Function(T value);

class AsYouTypeFormatter extends TextInputFormatter {
  final RegExp separatorChars = RegExp(r'[^\d]+');
  final RegExp allowedChars = RegExp(r'[\d+]');
  final RegExp bracketsBetweenDigitsOrSpace =
      RegExp(r'(?![\s\d])([()])(?=[\d\s])');

  final String isoCode;
  final String dialCode;
  final OnInputFormatted<TextEditingValue> onInputFormatted;

  AsYouTypeFormatter(
      {required this.isoCode,
      required this.dialCode,
      required this.onInputFormatted});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int oldValueLength = oldValue.text.length;
    int newValueLength = newValue.text.length;

    if (newValueLength > 0 && newValueLength > oldValueLength) {
      String newValueText = newValue.text;
      String rawText = newValueText.replaceAll(separatorChars, '');

      int rawCursorPosition = newValue.selection.end;

      int digitsBeforeCursor = 0, digitsAfterCursor = 0;

      if (rawCursorPosition > 0 && rawCursorPosition <= newValueText.length) {
        final rawTextBeforeCursor = newValueText
            .substring(0, rawCursorPosition)
            .replaceAll(separatorChars, '');
        final rawTextAfterCursor = newValueText
            .substring(rawCursorPosition)
            .replaceAll(separatorChars, '');

        digitsBeforeCursor = rawTextBeforeCursor.length;
        digitsAfterCursor = rawTextAfterCursor.length;
      }

      String textToParse = dialCode + rawText;

      formatAsYouType(input: textToParse).then(
        (String? value) {
          String parsedText = parsePhoneNumber(value);

          int newCursorPosition = 0;

          if (digitsBeforeCursor > 0 || digitsAfterCursor > 0) {
            for (var i = 0; i < parsedText.length; i++) {
              final startCursor = i;

              if (allowedChars.hasMatch(parsedText[startCursor])) {
                if (digitsBeforeCursor > 0) {
                  digitsBeforeCursor--;
                } else {
                  newCursorPosition = startCursor + 1;
                  break;
                }
              }

              final endCursor = parsedText.length - 1 - i;

              if (allowedChars.hasMatch(parsedText[endCursor])) {
                if (digitsAfterCursor > 0) {
                  digitsAfterCursor--;
                } else {
                  newCursorPosition = endCursor + 1;
                  break;
                }
              }
            }
          }

          newCursorPosition =
              min(max(newCursorPosition, 0), parsedText.length);

          this.onInputFormatted(
            TextEditingValue(
              text: parsedText,
              selection: TextSelection.collapsed(offset: newCursorPosition),
            ),
          );
        },
      );
    }

    return newValue;
  }

  Future<String?> formatAsYouType({required String input}) async {
    try {
      String? formattedPhoneNumber = await PhoneNumberUtil.formatAsYouType(
          phoneNumber: input, isoCode: isoCode);
      return formattedPhoneNumber;
    } on Exception {
      return '';
    }
  }

  String parsePhoneNumber(String? phoneNumber) {
    final filteredPhoneNumber =
        phoneNumber?.replaceAll(bracketsBetweenDigitsOrSpace, '');

    if (dialCode.length > 4) {
      if (isPartOfNorthAmericanNumberingPlan(dialCode)) {
        String northAmericaDialCode = '+1';
        String countryDialCodeWithSpace = northAmericaDialCode +
            ' ' +
            dialCode.replaceFirst(northAmericaDialCode, '');

        return filteredPhoneNumber!
            .replaceFirst(countryDialCodeWithSpace, '')
            .replaceFirst(separatorChars, '')
            .trim();
      }
    }
    return filteredPhoneNumber!.replaceFirst(dialCode, '').trim();
  }

  bool isPartOfNorthAmericanNumberingPlan(String dialCode) {
    return dialCode.contains('+1');
  }
}
