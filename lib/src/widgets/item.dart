import 'package:flutter/material.dart';
import 'package:intl_phone_number/src/models/country_model.dart';
import 'package:intl_phone_number/src/utils/util.dart';

class Item extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;
  final TextStyle? textStyle;
  final bool withCountryNames;
  final double? leadingPadding;
  final EdgeInsetsGeometry? selectorContentPadding;
  final BoxDecoration? selectorBoxDecoration;
  final bool trailingSpace;
  final Widget? leadingWidget;
  const Item(
      {Key? key,
      this.country,
      this.showFlag,
      this.useEmoji,
      this.textStyle,
      this.withCountryNames = false,
      this.leadingPadding = 12,
      this.trailingSpace = true,
      this.leadingWidget,
      this.selectorBoxDecoration,
      this.selectorContentPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    if (trailingSpace) {
      dialCode = dialCode.padRight(5, "");
    }
    return Container(
      padding: selectorContentPadding ?? EdgeInsets.all(0),
      decoration: selectorBoxDecoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(1),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: leadingPadding),
          _Flag(
            country: country,
            showFlag: showFlag,
            useEmoji: useEmoji,
          ),
          SizedBox(width: 5),
          Text(
            '$dialCode',
            textDirection: TextDirection.ltr,
            style: textStyle,
          ),
          leadingWidget ?? SizedBox()
        ],
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? showFlag;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.showFlag, this.useEmoji})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag!
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : Image.asset(
                    country!.flagUri,
                    width: 32.0,
                    package: 'intl_phone_number',
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox.shrink();
                    },
                  ),
          )
        : SizedBox.shrink();
  }
}
