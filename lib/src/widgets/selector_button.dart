import 'package:flutter/material.dart';
import 'package:intl_phone_number/src/models/country_model.dart';
import 'package:intl_phone_number/src/utils/selector_config.dart';
import 'package:intl_phone_number/src/utils/test/test_helper.dart';
import 'package:intl_phone_number/src/widgets/countries_search_list_widget.dart';
import 'package:intl_phone_number/src/widgets/item.dart';

class SelectorButton extends StatelessWidget {
  final List<Country> countries;
  final Country? country;
  final SelectorConfig selectorConfig;
  final TextStyle? selectorTextStyle;
  final InputDecoration? searchBoxDecoration;
  final TextEditingController? searchController;
  final bool autoFocusSearchField;
  final String? locale;
  final bool isEnabled;
  final bool isScrollControlled;
  final ValueChanged<Country?> onCountryChanged;
  final Widget? selectorTitleHeader;

  const SelectorButton(
      {Key? key,
      required this.countries,
      required this.country,
      required this.selectorConfig,
      required this.selectorTextStyle,
      required this.searchBoxDecoration,
      this.searchController,
      required this.autoFocusSearchField,
      required this.locale,
      required this.onCountryChanged,
      required this.isEnabled,
      required this.isScrollControlled,
      required this.selectorTitleHeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectorConfig.selectorType == PhoneInputSelectorType.DROPDOWN
        ? countries.isNotEmpty && countries.length > 1
            ? DropdownButtonHideUnderline(
                child: DropdownButton<Country>(
                  key: Key(TestHelper.DropdownButtonKeyValue),
                  hint: Item(
                    country: country,
                    showFlag: selectorConfig.showFlags,
                    useEmoji: selectorConfig.useEmoji,
                    leadingPadding: selectorConfig.leadingPadding,
                    trailingSpace: selectorConfig.trailingSpace,
                    textStyle: selectorTextStyle,
                  ),
                  value: country,
                  items: mapCountryToDropdownItem(countries),
                  onChanged: isEnabled ? onCountryChanged : null,
                ),
              )
            : Item(
                country: country,
                showFlag: selectorConfig.showFlags,
                useEmoji: selectorConfig.useEmoji,
                leadingPadding: selectorConfig.leadingPadding,
                leadingWidget: selectorConfig.leadingWidget,
                trailingSpace: selectorConfig.trailingSpace,
                textStyle: selectorTextStyle,
              )
        : MaterialButton(
            key: Key(TestHelper.DropdownButtonKeyValue),
            padding: EdgeInsets.zero,
            minWidth: 0,
            onPressed: countries.isNotEmpty && countries.length > 1 && isEnabled
                ? () async {
                    Country? selected;
                    if (selectorConfig.selectorType ==
                        PhoneInputSelectorType.BOTTOM_SHEET) {
                      selected = await showCountrySelectorBottomSheet(
                          context, countries);
                    } else {
                      selected =
                          await showCountrySelectorDialog(context, countries);
                    }

                    if (selected != null) {
                      onCountryChanged(selected);
                    }
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Item(
                country: country,
                showFlag: selectorConfig.showFlags,
                useEmoji: selectorConfig.useEmoji,
                leadingWidget: selectorConfig.leadingWidget,
                leadingPadding: selectorConfig.leadingPadding,
                trailingSpace: selectorConfig.trailingSpace,
                textStyle: selectorTextStyle,
                selectorBoxDecoration: selectorConfig.selectorBoxDecoration,
                selectorContentPadding: selectorConfig.selectorContentPadding,
              ),
            ),
          );
  }

  List<DropdownMenuItem<Country>> mapCountryToDropdownItem(
      List<Country> countries) {
    return countries.map((country) {
      return DropdownMenuItem<Country>(
        value: country,
        child: Item(
          key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
          country: country,
          showFlag: selectorConfig.showFlags,
          useEmoji: selectorConfig.useEmoji,
          textStyle: selectorTextStyle,
          withCountryNames: false,
          trailingSpace: selectorConfig.trailingSpace,
        ),
      );
    }).toList();
  }

  Future<Country?> showCountrySelectorDialog(
      BuildContext inheritedContext, List<Country> countries) {
    return showDialog(
      context: inheritedContext,
      barrierDismissible: true,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: selectorTitleHeader ?? SizedBox.shrink(),
        content: Directionality(
          textDirection: Directionality.of(inheritedContext),
          child: Container(
            width: double.maxFinite,
            child: CountrySearchListWidget(
              countries,
              locale,
              searchBoxDecoration: searchBoxDecoration,
              searchController: searchController,
              showFlags: selectorConfig.showFlags,
              useEmoji: selectorConfig.useEmoji,
              autoFocus: autoFocusSearchField,
              nameCountryStyle: selectorConfig.nameCountryStyle,
              dialCodeStyle: selectorConfig.dialCodeStyle,
              paddingContent: selectorConfig.paddingContent,
              onCountrySelected: onCountryChanged,
            ),
          ),
        ),
      ),
    );
  }

  Future<Country?> showCountrySelectorBottomSheet(
      BuildContext inheritedContext, List<Country> countries) {
    return showModalBottomSheet(
      context: inheritedContext,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      useSafeArea: selectorConfig.useBottomSheetSafeArea,
      builder: (BuildContext context) {
        return Stack(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: DraggableScrollableSheet(
              builder: (BuildContext context, ScrollController controller) {
                return Directionality(
                  textDirection: Directionality.of(inheritedContext),
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Theme.of(context).canvasColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    child: CountrySearchListWidget(
                      countries,
                      locale,
                      searchBoxDecoration: searchBoxDecoration,
                      searchController: searchController,
                      scrollController: controller,
                      showFlags: selectorConfig.showFlags,
                      useEmoji: selectorConfig.useEmoji,
                      autoFocus: autoFocusSearchField,
                      onCountrySelected: onCountryChanged,
                    ),
                  ),
                );
              },
            ),
          ),
        ]);
      },
    );
  }
}
