import 'package:flutter/material.dart';
import 'package:intl_phone_number/src/models/country_model.dart';

typedef CountryComparator = int Function(Country, Country);

enum PhoneInputSelectorType { DROPDOWN, BOTTOM_SHEET, DIALOG }

class SelectorConfig {
  final PhoneInputSelectorType selectorType;
  final bool showFlags;
  final bool useEmoji;
  final CountryComparator? countryComparator;
  final bool setSelectorButtonAsPrefixIcon;
  final double? leadingPadding;
  final bool trailingSpace;
  final bool useBottomSheetSafeArea;
  final EdgeInsetsGeometry? selectorContentPadding;
  final BoxDecoration? selectorBoxDecoration;
  final Widget? leadingWidget;
  final TextStyle? nameCountryStyle;
  final TextStyle? dialCodeStyle;
  final EdgeInsetsGeometry? paddingContent;

  const SelectorConfig({
    this.selectorType = PhoneInputSelectorType.DROPDOWN,
    this.showFlags = true,
    this.useEmoji = false,
    this.countryComparator,
    this.setSelectorButtonAsPrefixIcon = false,
    this.leadingPadding,
    this.trailingSpace = true,
    this.useBottomSheetSafeArea = false,
    this.selectorContentPadding,
    this.leadingWidget,
    this.selectorBoxDecoration,
    this.nameCountryStyle,
    this.dialCodeStyle,
    this.paddingContent,
  });
}
