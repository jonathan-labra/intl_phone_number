import 'package:flutter/material.dart';
import 'package:intl_phone_number/intl_phone_number.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'intl_phone_number Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  PhoneNumber? _phone;
  bool _isValid = false;
  bool _hasTouched = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('intl_phone_number Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ejemplo 1: Dropdown (default) ─────────────────────────────
            Text('Dropdown (default)',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InternationalPhoneNumberInput(
              initialValue: PhoneNumber(isoCode: 'MX'),
              hintText: 'Número de teléfono',
              onInputChanged: (phone) => setState(() => _phone = phone),
              onInputValidated: (valid) => setState(() => _isValid = valid),
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
            ),
            const SizedBox(height: 12),
            if (_phone != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'País: ${_phone!.isoCode}  Código: ${_phone!.dialCode}'),
                      Text('Número: ${_phone!.phoneNumber}'),
                      Row(
                        children: [
                          const Text('Válido: '),
                          Icon(
                            _isValid ? Icons.check_circle : Icons.cancel,
                            color: _isValid ? Colors.green : Colors.red,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // ── Ejemplo 2: Bottom Sheet ────────────────────────────────────
            Text('Bottom Sheet',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InternationalPhoneNumberInput(
              initialValue: PhoneNumber(isoCode: 'US'),
              onInputChanged: (_) {},
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                showFlags: true,
                useEmoji: true,
                useBottomSheetSafeArea: true,
              ),
              inputBorder: const OutlineInputBorder(),
              hintText: 'Número (bottom sheet)',
            ),

            const SizedBox(height: 32),

            // ── Ejemplo 3: Dialog ─────────────────────────────────────────
            Text('Dialog', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InternationalPhoneNumberInput(
              backgroundColor: _hasTouched && !_isValid
                  ? Color(0xFFFFEEEE)
                  : Color(0XFFFAF2FF),
              onInputChanged: (phone) => setState(() {
                _phone = phone;
                _hasTouched = true;
              }),
              onInputValidated: (valid) => setState(() => _isValid = valid),
              textFieldController: TextEditingController(),
              searchController: _searchController,
              initialValue: PhoneNumber(isoCode: 'MX'),
              spaceBetweenSelectorAndTextField: 0,
              selectorTitleHeader: Text('Selecciona tu país'),
              selectorTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
                showFlags: true,
                useEmoji: false,
                setSelectorButtonAsPrefixIcon: true,
                leadingPadding: 0,
                paddingContent:
                    EdgeInsets.only(left: 13, bottom: 9.63, top: 9.63),
                nameCountryStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                dialCodeStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
                leadingWidget: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                selectorContentPadding:
                    EdgeInsets.only(top: 30, bottom: 30, left: 17),
                selectorBoxDecoration: BoxDecoration(
                  color: _hasTouched && !_isValid
                      ? Color(0xFFFFCCCC)
                      : Color(0XFFF4E6FD),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  border: _hasTouched && !_isValid
                      ? Border(
                          top: BorderSide(
                              color: Color(0xFFE53935), width: 1.5),
                          bottom: BorderSide(
                              color: Color(0xFFE53935), width: 1.5),
                          left: BorderSide(
                              color: Color(0xFFE53935), width: 1.5),
                          right: BorderSide.none,
                        )
                      : null,
                ),
              ),
              formatInput: true,
              autoValidateMode: AutovalidateMode.onUserInteractionIfError,
              inputBorder: InputBorder.none,
              searchBoxDecoration: InputDecoration(
                hintText: 'Buscar países...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF717182)),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF717182),
                    size: 10,
                  ),
                  onPressed: () => _searchController.clear(),
                ),
                filled: true,
                fillColor: Color(0XFFF3F3F5),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              inputDecoration: InputDecoration(
                hintText: '000 000 0000',
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: _hasTouched && !_isValid
                        ? BorderSide(color: Color(0xFFE53935), width: 1.5)
                        : BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide: _hasTouched && !_isValid
                        ? BorderSide(color: Color(0xFFE53935), width: 1.5)
                        : BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                contentPadding: const EdgeInsets.only(
                    top: 30, bottom: 30, right: 61, left: 1),
              ),
              countries: const [
                'MX',
                'US',
                'GB',
                'CA',
                'AU',
                'DE',
                'FR',
                'ES',
                'IT',
                'BR',
                'AR',
                'CO',
                'CL',
                'PE',
                'JP',
                'CN',
                'IN',
                'KR',
              ],
            ),

            const SizedBox(height: 32),

            // ── Ejemplo 4: Selector como prefijo ──────────────────────────
            Text('Selector como prefijo',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InternationalPhoneNumberInput(
              initialValue: PhoneNumber(isoCode: 'CO'),
              onInputChanged: (_) {},
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                setSelectorButtonAsPrefixIcon: true,
                useEmoji: true,
              ),
              inputDecoration: InputDecoration(
                hintText: 'Número con prefijo',
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Ejemplo 5: Solo países LATAM ──────────────────────────────
            Text('Solo países LATAM',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InternationalPhoneNumberInput(
              initialValue: PhoneNumber(isoCode: 'MX'),
              onInputChanged: (_) {},
              countries: const ['MX', 'CO', 'AR', 'CL', 'PE', 'VE', 'BR'],
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
                useEmoji: true,
              ),
              inputBorder: const OutlineInputBorder(),
              hintText: 'Solo LATAM',
            ),

            const SizedBox(height: 32),

            // ── Ejemplo 6: Sin formato, solo dígitos ──────────────────────
            Text('Sin formato (solo dígitos)',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InternationalPhoneNumberInput(
              initialValue: PhoneNumber(isoCode: 'MX'),
              onInputChanged: (_) {},
              formatInput: false,
              selectorConfig: const SelectorConfig(),
              inputBorder: const UnderlineInputBorder(),
              hintText: 'Sin formato',
            ),
          ],
        ),
      ),
    );
  }
}
