class Country {
  final String? name;
  final String? alpha2Code;
  final String? alpha3Code;
  final String? dialCode;
  final String flagUri;
  final Map<String, String>? nameTranslations;

  Country({
    required this.name,
    required this.alpha2Code,
    required this.alpha3Code,
    required this.dialCode,
    required this.flagUri,
    this.nameTranslations,
  });

  factory Country.fromJson(Map<String, dynamic> data) {
    return Country(
      name: data['en_short_name'],
      alpha2Code: data['alpha_2_code'],
      alpha3Code: data['alpha_3_code'],
      dialCode: data['dial_code'],
      flagUri: 'assets/flags/${data['alpha_2_code'].toLowerCase()}.png',
      nameTranslations: data['nameTranslations'] != null
          ? Map<String, String>.from(data['nameTranslations'])
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Country &&
        other.alpha2Code == this.alpha2Code &&
        other.alpha3Code == this.alpha3Code &&
        other.dialCode == this.dialCode;
  }

  @override
  int get hashCode => Object.hashAll([alpha2Code, alpha3Code, dialCode]);

  @override
  String toString() => '[Country] { '
      'name: $name, '
      'alpha2: $alpha2Code, '
      'alpha3: $alpha3Code, '
      'dialCode: $dialCode '
      '}';
}
