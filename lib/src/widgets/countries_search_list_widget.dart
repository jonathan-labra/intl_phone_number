import 'package:flutter/material.dart';
import 'package:intl_phone_number/src/models/country_model.dart';
import 'package:intl_phone_number/src/utils/test/test_helper.dart';
import 'package:intl_phone_number/src/utils/util.dart';

class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;
  final TextEditingController? searchController;
  final TextStyle? nameCountryStyle;
  final TextStyle? dialCodeStyle;
  final EdgeInsetsGeometry? paddingContent;
  final ValueChanged<Country>? onCountrySelected;

  CountrySearchListWidget(
    this.countries,
    this.locale, {
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    this.searchController,
    this.nameCountryStyle,
    this.dialCodeStyle,
    this.paddingContent,
    this.onCountrySelected,
  });

  @override
  _CountrySearchListWidgetState createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  late TextEditingController _searchController;
  late List<Country> filteredCountries;

  @override
  void initState() {
    _searchController = widget.searchController ?? TextEditingController();
    final String value = _searchController.text.trim();
    _searchController.addListener(() {
      final String value = _searchController.text.trim();
      setState(
        () => filteredCountries = Utils.filterCountries(
          countries: widget.countries,
          locale: widget.locale,
          value: value,
        ),
      );
    });
    filteredCountries = Utils.filterCountries(
      countries: widget.countries,
      locale: widget.locale,
      value: value,
    );
    super.initState();
  }

  @override
  void dispose() {
    // Solo disponer si el controller fue creado internamente
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    super.dispose();
  }

  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        InputDecoration(
          hintText: 'Buscar',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                width: 0.69,
              ),
              bottom: BorderSide(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                width: 0.69,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            key: Key(TestHelper.CountrySearchInputKeyValue),
            decoration: getSearchBoxDecoration(),
            controller: _searchController,
            autofocus: widget.autoFocus,
            onChanged: (value) {
              final String value = _searchController.text.trim();
              return setState(
                () => filteredCountries = Utils.filterCountries(
                  countries: widget.countries,
                  locale: widget.locale,
                  value: value,
                ),
              );
            },
          ),
        ),
        Flexible(
          child: ListView.builder(
            controller: widget.scrollController,
            shrinkWrap: true,
            itemCount: filteredCountries.length,
            itemBuilder: (BuildContext context, int index) {
              Country country = filteredCountries[index];
              return DirectionalCountryListTile(
                country: country,
                locale: widget.locale,
                showFlags: widget.showFlags!,
                useEmoji: widget.useEmoji!,
                nameCountryStyle: widget.nameCountryStyle,
                dialCodeStyle: widget.dialCodeStyle,
                paddingContent: widget.paddingContent,
                onCountrySelected: widget.onCountrySelected,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DirectionalCountryListTile extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;
  final TextStyle? nameCountryStyle;
  final TextStyle? dialCodeStyle;
  final EdgeInsetsGeometry? paddingContent;
  final ValueChanged<Country>? onCountrySelected;

  const DirectionalCountryListTile(
      {Key? key,
      required this.country,
      required this.locale,
      required this.showFlags,
      required this.useEmoji,
      this.nameCountryStyle,
      this.dialCodeStyle,
      this.paddingContent,
      this.onCountrySelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCountrySelected?.call(country);
        Navigator.of(context).pop(country);
      },
      child: Container(
          padding: paddingContent ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                width: 0.69,
              ),
            ),
          ),
          child: Row(
            children: [
              if (showFlags)
                _Flag(
                  country: country,
                  useEmoji: useEmoji,
                ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Utils.getCountryName(country, locale)}',
                      textDirection: Directionality.of(context),
                      textAlign: TextAlign.start,
                      style: nameCountryStyle ?? TextStyle(),
                    ),
                    Text(
                      '${country.dialCode ?? ''}',
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.start,
                      style: dialCodeStyle ?? TextStyle(),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
  /*
ListTile(
        key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
        shape: Border.all(color: Colors.grey),
        contentPadding: EdgeInsets.only(left: 13),
        leading: showFlags ? _Flag(country: country, useEmoji: useEmoji) : null,
        title: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            '${Utils.getCountryName(country, locale)}',
            textDirection: Directionality.of(context),
            textAlign: TextAlign.start,
          ),
        ),
        subtitle: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            '${country.dialCode ?? ''}',
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
          ),
        ),
        onTap: () => Navigator.of(context).pop(country),
      ),
  */
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : country?.flagUri != null
                    ? Image(
                        height: 16,
                        width: 21,
                        image: AssetImage(
                          country!.flagUri,
                          package: 'intl_phone_number',
                        ))
                    : SizedBox.shrink(),
          )
        : SizedBox.shrink();
  }
}
