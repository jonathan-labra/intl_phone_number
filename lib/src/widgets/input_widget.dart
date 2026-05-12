import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number/src/models/country_model.dart';
import 'package:intl_phone_number/src/providers/country_provider.dart';
import 'package:intl_phone_number/src/utils/formatter/as_you_type_formatter.dart';
import 'package:intl_phone_number/src/utils/phone_number.dart';
import 'package:intl_phone_number/src/utils/phone_number/phone_number_util.dart';
import 'package:intl_phone_number/src/utils/selector_config.dart';
import 'package:intl_phone_number/src/utils/test/test_helper.dart';
import 'package:intl_phone_number/src/utils/util.dart';
import 'package:intl_phone_number/src/utils/widget_view.dart';
import 'package:intl_phone_number/src/widgets/selector_button.dart';

class InternationalPhoneNumberInput extends StatefulWidget {
  final SelectorConfig selectorConfig;
  final ValueChanged<PhoneNumber>? onInputChanged;
  final ValueChanged<bool>? onInputValidated;
  final VoidCallback? onSubmit;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final ValueChanged<PhoneNumber>? onSaved;
  final Key? fieldKey;
  final TextEditingController? textFieldController;
  final TextInputType keyboardType;
  final TextInputAction? keyboardAction;
  final PhoneNumber? initialValue;
  final String? hintText;
  final String? errorMessage;
  final double selectorButtonOnErrorPadding;
  final double spaceBetweenSelectorAndTextField;
  final int maxLength;
  final bool isEnabled;
  final bool formatInput;
  final bool autoFocus;
  final bool autoFocusSearch;
  final AutovalidateMode autoValidateMode;
  final bool ignoreBlank;
  final bool countrySelectorScrollControlled;
  final String? locale;
  final TextStyle? textStyle;
  final TextStyle? selectorTextStyle;
  final Widget? selectorTitleHeader;
  final InputBorder? inputBorder;
  final InputDecoration? inputDecoration;
  final InputDecoration? searchBoxDecoration;
  final TextEditingController? searchController;
  final Color? cursorColor;
  final Color? backgroundColor;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final EdgeInsets scrollPadding;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final List<String>? countries;

  InternationalPhoneNumberInput({
    Key? key,
    this.selectorConfig = const SelectorConfig(),
    required this.onInputChanged,
    this.onInputValidated,
    this.onSubmit,
    this.onFieldSubmitted,
    this.validator,
    this.onSaved,
    this.fieldKey,
    this.textFieldController,
    this.keyboardAction,
    this.keyboardType = TextInputType.phone,
    this.initialValue,
    this.hintText = 'Phone number',
    this.errorMessage = 'Invalid phone number',
    this.selectorButtonOnErrorPadding = 24,
    this.spaceBetweenSelectorAndTextField = 12,
    this.maxLength = 15,
    this.isEnabled = true,
    this.formatInput = true,
    this.autoFocus = false,
    this.autoFocusSearch = false,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.ignoreBlank = false,
    this.countrySelectorScrollControlled = true,
    this.locale,
    this.textStyle,
    this.selectorTextStyle,
    this.selectorTitleHeader,
    this.inputBorder,
    this.inputDecoration,
    this.searchBoxDecoration,
    this.searchController,
    this.textAlign = TextAlign.start,
    this.textAlignVertical = TextAlignVertical.center,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.focusNode,
    this.cursorColor,
    this.backgroundColor,
    this.autofillHints,
    this.countries,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InternationalPhoneNumberInput> {
  TextEditingController? controller;
  double selectorButtonBottomPadding = 0;

  Country? country;
  List<Country> countries = [];
  bool isNotValid = true;

  @override
  void initState() {
    super.initState();
    loadCountries();
    controller = widget.textFieldController ?? TextEditingController();
    initialiseWidget();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _InputWidgetView(state: this);
  }

  @override
  void didUpdateWidget(InternationalPhoneNumberInput oldWidget) {
    loadCountries(previouslySelectedCountry: country);
    if (oldWidget.initialValue != widget.initialValue) {
      if (country!.alpha2Code != widget.initialValue?.isoCode) {
        loadCountries();
      }
      initialiseWidget();
    }
    super.didUpdateWidget(oldWidget);
  }

  void initialiseWidget() async {
    if (widget.initialValue != null) {
      if (widget.initialValue!.phoneNumber != null &&
          widget.initialValue!.phoneNumber!.isNotEmpty &&
          (await PhoneNumberUtil.isValidNumber(
              phoneNumber: widget.initialValue!.phoneNumber!,
              isoCode: widget.initialValue!.isoCode!))!) {
        String phoneNumber =
            await PhoneNumber.getParsableNumber(widget.initialValue!);

        controller!.text = widget.formatInput
            ? phoneNumber
            : phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

        phoneNumberControllerListener();
      }
    }
  }

  void loadCountries({Country? previouslySelectedCountry}) {
    if (this.mounted) {
      List<Country> countries =
          CountryProvider.getCountriesData(countries: widget.countries);

      Country country = previouslySelectedCountry ??
          Utils.getInitialSelectedCountry(
            countries,
            widget.initialValue?.isoCode ?? '',
          );

      countries = countries.toSet().toList();

      final CountryComparator? countryComparator =
          widget.selectorConfig.countryComparator;
      if (countryComparator != null) {
        countries.sort(countryComparator);
      }

      setState(() {
        this.countries = countries;
        this.country = country;
      });
    }
  }

  void phoneNumberControllerListener() {
    if (this.mounted) {
      String parsedPhoneNumberString =
          controller!.text.replaceAll(RegExp(r'[^\d+]'), '');

      getParsedPhoneNumber(parsedPhoneNumberString, this.country?.alpha2Code)
          .then((phoneNumber) {
        if (phoneNumber == null) {
          String phoneNumber =
              '${this.country?.dialCode}$parsedPhoneNumberString';

          if (widget.onInputChanged != null) {
            widget.onInputChanged!(PhoneNumber(
                phoneNumber: phoneNumber,
                isoCode: this.country?.alpha2Code,
                dialCode: this.country?.dialCode));
          }

          if (widget.onInputValidated != null) {
            widget.onInputValidated!(false);
          }
          this.isNotValid = true;
        } else {
          if (widget.onInputChanged != null) {
            widget.onInputChanged!(PhoneNumber(
                phoneNumber: phoneNumber,
                isoCode: this.country?.alpha2Code,
                dialCode: this.country?.dialCode));
          }

          if (widget.onInputValidated != null) {
            widget.onInputValidated!(true);
          }
          this.isNotValid = false;
        }
      });
    }
  }

  Future<String?> getParsedPhoneNumber(
      String phoneNumber, String? isoCode) async {
    if (phoneNumber.isNotEmpty && isoCode != null) {
      try {
        bool? isValidPhoneNumber = await PhoneNumberUtil.isValidNumber(
            phoneNumber: phoneNumber, isoCode: isoCode);

        if (isValidPhoneNumber!) {
          return await PhoneNumberUtil.normalizePhoneNumber(
              phoneNumber: phoneNumber, isoCode: isoCode);
        }
      } on Exception {
        return null;
      }
    }
    return null;
  }

  InputDecoration getInputDecoration(InputDecoration? decoration) {
    InputDecoration value = decoration ??
        InputDecoration(
          border: widget.inputBorder ?? UnderlineInputBorder(),
          hintText: widget.hintText,
        );

    if (widget.selectorConfig.setSelectorButtonAsPrefixIcon) {
      return value.copyWith(
          prefixIcon: SelectorButton(
        country: country,
        countries: countries,
        onCountryChanged: onCountryChanged,
        selectorConfig: widget.selectorConfig,
        selectorTextStyle: widget.selectorTextStyle,
        searchBoxDecoration: widget.searchBoxDecoration,
        searchController: widget.searchController,
        locale: locale,
        isEnabled: widget.isEnabled,
        autoFocusSearchField: widget.autoFocusSearch,
        isScrollControlled: widget.countrySelectorScrollControlled,
        selectorTitleHeader: widget.selectorTitleHeader,
      ));
    }

    return value;
  }

  void onChanged(String value) {
    phoneNumberControllerListener();
  }

  String? validator(String? value) {
    bool isValid =
        this.isNotValid && (value!.isNotEmpty || widget.ignoreBlank == false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isValid && widget.errorMessage != null) {
        setState(() {
          this.selectorButtonBottomPadding =
              widget.selectorButtonOnErrorPadding;
        });
      } else {
        setState(() {
          this.selectorButtonBottomPadding = 0;
        });
      }
    });

    return isValid ? widget.errorMessage : null;
  }

  void onCountryChanged(Country? country) {
    setState(() {
      this.country = country;
    });
    phoneNumberControllerListener();
  }

  void _phoneNumberSaved() {
    if (this.mounted) {
      String parsedPhoneNumberString =
          controller!.text.replaceAll(RegExp(r'[^\d+]'), '');

      String phoneNumber =
          '${this.country?.dialCode ?? ''}' + parsedPhoneNumberString;

      widget.onSaved?.call(
        PhoneNumber(
            phoneNumber: phoneNumber,
            isoCode: this.country?.alpha2Code,
            dialCode: this.country?.dialCode),
      );
    }
  }

  void onSaved(String? value) {
    _phoneNumberSaved();
  }

  String? get locale {
    if (widget.locale == null) return null;
    if (widget.locale!.toLowerCase() == 'nb' ||
        widget.locale!.toLowerCase() == 'nn') {
      return 'no';
    }
    return widget.locale;
  }
}

class _InputWidgetView
    extends WidgetView<InternationalPhoneNumberInput, _InputWidgetState> {
  final _InputWidgetState state;

  _InputWidgetView({Key? key, required this.state})
      : super(key: key, state: state);

  @override
  Widget build(BuildContext context) {
    final countryCode = state.country?.alpha2Code ?? '';
    final dialCode = state.country?.dialCode ?? '';

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (!widget.selectorConfig.setSelectorButtonAsPrefixIcon) ...[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SelectorButton(
                  country: state.country,
                  countries: state.countries,
                  onCountryChanged: state.onCountryChanged,
                  selectorConfig: widget.selectorConfig,
                  selectorTextStyle: widget.selectorTextStyle,
                  searchBoxDecoration: widget.searchBoxDecoration,
                  searchController: widget.searchController,
                  locale: state.locale,
                  isEnabled: widget.isEnabled,
                  autoFocusSearchField: widget.autoFocusSearch,
                  isScrollControlled: widget.countrySelectorScrollControlled,
                  selectorTitleHeader: widget.selectorTitleHeader,
                ),
                SizedBox(height: state.selectorButtonBottomPadding),
              ],
            ),
            SizedBox(width: widget.spaceBetweenSelectorAndTextField),
          ],
          Flexible(
            child: Container(
              decoration:
                  BoxDecoration(color: widget.backgroundColor ?? Colors.white),
              child: TextFormField(
                key: widget.fieldKey ?? Key(TestHelper.TextInputKeyValue),
                textDirection: TextDirection.ltr,
                controller: state.controller,
                cursorColor: widget.cursorColor,
                focusNode: widget.focusNode,
                enabled: widget.isEnabled,
                autofocus: widget.autoFocus,
                keyboardType: widget.keyboardType,
                textInputAction: widget.keyboardAction,
                style: widget.textStyle,
                decoration: state.getInputDecoration(widget.inputDecoration),
                textAlign: widget.textAlign,
                textAlignVertical: widget.textAlignVertical,
                onEditingComplete: widget.onSubmit,
                onFieldSubmitted: widget.onFieldSubmitted,
                autovalidateMode: widget.autoValidateMode,
                autofillHints: widget.autofillHints,
                validator: widget.validator ?? state.validator,
                onSaved: state.onSaved,
                scrollPadding: widget.scrollPadding,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(widget.maxLength),
                  widget.formatInput
                      ? AsYouTypeFormatter(
                          isoCode: countryCode,
                          dialCode: dialCode,
                          onInputFormatted: (TextEditingValue value) {
                            state.controller!.value = value;
                          },
                        )
                      : FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: state.onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
