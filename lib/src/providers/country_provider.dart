import 'package:intl_phone_number/src/models/country_list.dart';
import 'package:intl_phone_number/src/models/country_model.dart';

const String PropertyName = 'alpha_2_code';

class CountryProvider {
  static List<Country> getCountriesData({required List<String>? countries}) {
    List jsonList = Countries.countryList;

    if (countries == null || countries.isEmpty) {
      return jsonList.map((country) => Country.fromJson(country)).toList();
    }
    List filteredList = jsonList.where((country) {
      return countries.contains(country[PropertyName]);
    }).toList();

    return filteredList.map((country) => Country.fromJson(country)).toList();
  }
}
